classdef DataTools < handle & dynamicprops

    % !! ASPECTOS GERAIS !!
    
    % (a) Como dentro de cada painel e cada documento há uma uifigure,
    % preciso manter handle para cada uma delas. Inicialmente, vou deixar
    % esses handles nas propriedades "hFigDocuments" e "hPanels".
    % - "hFigDocuments" é um cell array dos objetos "FigureDocument", os quais registram os handles para as "uifigures" relacionadas a cada um.
    %    hFigDocuments = struct(struct(app).DocumentMap).serialization.values;
    % - "hPanels" é um cell array dos objetos "FigurePanel", os quais registram os handles para as "uifigures" relacionadas a cada um dos três painéis - "Left", "Bottom" e "Right".
    %    hPanels = struct(struct(app).PanelMap).serialization.values;
    
    % (b) Para trabalhar de forma semelhante ao AppDesigner, devo criar uma
    % forma de "REGISTRO" dos componentes que podem ser referenciados no
    % app. Por conta disso, inserida "dynamicprops" como super classe, o
    % que possibilita a inclusão programática de propriedades na instância 
    % do app. 
    %     - newProp = addprop(obj, 'propName', propValue)
    %     - delete(newProp)

    % (c) De forma geral, os ícones devem ser imagens PNG ou JPEG, com
    % 16x16 pixels. Exceção aos ícones grandes do Toolstrip, os quais
    % são 24x24 pixels.
    % O ícone do Matlab, no topo da janela, é o ícone do navegador. Até
    % existe a propriedade "Icon" no objeto "WebWindow", mas nada acontece... 
    % testar no R2023a.
    %    - hWindow = struct(app.Container).Window

    % (d) O registro dos componentes, incluindo-os como propriedades do
    % app, demanda a inclusão de um prefixo. Inicialmente, inseri o nome do
    % módulo: "file", "playback", "driveTest" e "anatelDB", por exemplo.
    % Refletir como implementar a abertura de mais de um módulo "driveTest", 
    % por exemplo. Como referenciar os seus componentes?

    % Preciso ter uma propriedade que registre os módulos que estão
    % abertos.... {'Playback', 'DriveTest', 'Report'} por exemplo.

    % Um objeto do tipo 'matlab.ui.internal.FigureDocument' tem a propriedade 
    % "Figure" que armazena o handle pra uifigure. A ordem da figura (apresentada no
    % docked container) fica registrada na propriedade "Index".
    %
    % As propriedades "Title" e "Visible" do objeto são "sincronizadas" com as propriedades
    % "Name" e "Visible" dauifigure.
    %
    % Armazena na ordem de criação das figuras, a posição é armazenada na propriedade Index do pai da Figure, o FigureDocument.
    % Ao fechar, ele apaga da lista...

    % figDoc1 = struct(struct(app).DocumentMap).serialization.values{1}; % Index = 1;
    % uiFig1  = figDoc1.Figure;

    % Exemplos para desenvolvimento dos módulos:
    % - TOOLSTRIP: C:\Program Files\MATLAB\R2022b\toolbox\stats\mlearnapps\+mlearnapp\+internal\+ui\DialogFactory.m
    % - QUICKACCESSBAR: ...

    properties
        pathToMFILE
        Container
        hFigDocuments
        hPanels
        hDynamicProperties = table('Size', [0, 2], 'VariableTypes', {'cell', 'cell'}, 'VariableNames', {'id', 'handle'})
        uuid
    end
    
    methods
        %-----------------------------------------------------------------%
        function this = DataTools(varargin)

            warning('off', 'MATLAB:structOnObject')

            % RootFolder
            this.pathToMFILE   = fileparts(mfilename('fullpath'));

            % AppContainer object
            appContainerOptions = struct('Tag', 'AppContainer', 'Title', 'DataTools');
            this.Container = matlab.ui.container.internal.AppContainer(appContainerOptions);

            % Window size & position
            [x,y,w,h] = imageslib.internal.apputil.ScreenUtilities.getInitialToolPosition();
            set(this.Container, 'WindowBounds', [x,y,w,h], 'WindowMinSize', [640, 480]);

            % Main containers/components building
            startupBuilding_Toolstrip(this)
            startupBuilding_QuickAccessBar(this)
            startupBuilding_FigureDocumentGroup(this)
            startupBuilding_PanelGroup(this)
            startupBuilding_StatusBar(this)

            % Others properties
            this.hFigDocuments = struct(struct(this.Container).DocumentMap).serialization.values;
            this.hPanels       = struct(struct(this.Container).PanelMap).serialization.values;
            this.uuid          = char(matlab.lang.internal.uuid());

            setappdata(groot, class.Constants.appName, this);
            this.Container.Visible = true;
            
            % Listener
            addlistener(this.Container, 'StateChanged', @this.appStateChangedCallback);
        end


        %-----------------------------------------------------------------%
        function delete(this)
            if isappdata(groot, class.Constants.appName)
                rmappdata(groot, class.Constants.appName);
            end

            delete(this)
        end
    end


    methods (Access = private)
        %-----------------------------------------------------------------%
        % ## STARTUP ##
        %-----------------------------------------------------------------%
        function startupBuilding_Toolstrip(this)
            % C:\Program Files\MATLAB\R2022b\toolbox\matlab\toolstrip\+matlab\+ui\+internal\+toolstrip

            import matlab.ui.internal.toolstrip.*

            tab1 = Tab();
            tab1.Tag   = 'Tab1';
            tab1.Title = 'TAB1';
            
            hSection = tab1.addSection();
            hSection.Title = 'SEÇÃO 1';
            hColumn = hSection.addColumn();
            hButton = Button('Open...', Icon.OPEN_24);
            hButton.ButtonPushedFcn = {@callbacks.openButtonPushed, this};
            hColumn.add(hButton);
        
            tab2 = Tab();
            tab2.Tag   = 'Tab2';
            tab2.Title = 'TAB2';
            
            tabGroup = TabGroup();
            tabGroup.Tag = 'myTabGroup';
            tabGroup.add(tab1);
            tabGroup.add(tab2);

            this.Container.addTabGroup(tabGroup);
        end


        %-----------------------------------------------------------------%
        function startupBuilding_QuickAccessBar(this)
            % C:\Program Files\MATLAB\R2022b\toolbox\matlab\toolstrip\+matlab\+ui\+internal\+toolstrip\+qab
            helpButton = matlab.ui.internal.toolstrip.qab.QABHelpButton();
            helpButton.ButtonPushedFcn = {@callbacks.helpButtonPushed, this};

            this.Container.add(helpButton) 
        end


        %-----------------------------------------------------------------%
        function startupBuilding_FigureDocumentGroup(this)
            % C:\Program Files\MATLAB\R2022b\toolbox\matlab\uitools\uicomponents\components\+matlab\+ui\+internal\FigureDocumentGroup.m

            % Cria aqui as figuras inicialmente já criadas no app... talvez
            % uma única figura com uma imagem pra preencher o vazio...

            docGroupOptions = struct('Tag', 'Tabs', 'Title', 'Tabs');
            docGroup = matlab.ui.internal.FigureDocumentGroup(docGroupOptions);

            this.Container.add(docGroup)
        end


        %-----------------------------------------------------------------%
        function startupBuilding_PanelGroup(this)
            leftPanelOptions      = struct('Tag', 'LeftPanel',  'Title', 'Spectral data', 'PermissibleRegions', 'left',  'Region', 'left');
            leftPanel             = matlab.ui.internal.FigurePanel(leftPanelOptions);
            leftPanel.Maximizable = false;
            obj = createComponents.file(leftPanel.Figure);
            this.registerComponents(obj, 'file')

            % Por enquanto não criarei os painéis abaixo e à direita do
            % documento.

            bottomPanel = [];
            rightPanel  = [];

            panelGroup  = {leftPanel, bottomPanel, rightPanel};
            panelGroup  = panelGroup(cellfun(@(x) ~isempty(x), panelGroup));

            for ii = 1:numel(panelGroup)
                this.Container.addPanel(panelGroup{ii})
            end
        end


        %-----------------------------------------------------------------%
        function startupBuilding_StatusBar(this)
            % C:\Program Files\MATLAB\R2022b\toolbox\matlab\appcontainer\+matlab\+ui\+internal\+statusbar\StatusBar.m
            
            statusLabel = matlab.ui.internal.statusbar.StatusLabel(struct('Icon', 'anatelDB_16.png', 'Text', 'Iniciando...', 'Region', 'left'));
            statusBar   = matlab.ui.internal.statusbar.StatusBar();
            statusBar.add(statusLabel)

            this.Container.addStatusBar(statusBar)   
        end


        %-----------------------------------------------------------------%
        function appStateChangedCallback(this, ~, ~)
            % Os estados de um objeto "AppContainer" são definidos por uma
            % enumeração. Fluxos de estados:
            % INITIALIZING >> RUNNING >> TERMINATED
            if this.Container.State == matlab.ui.container.internal.appcontainer.AppState.TERMINATED
                delete(this);
            end
        end
    end


    methods (Access = private)
        %-----------------------------------------------------------------%
        % ## REGISTER COMPONENTS ##
        %-----------------------------------------------------------------%
        function registerComponents(this, obj, tag)
            compNames = fields(obj);
            for ii = 1:numel(compNames)
                propName = sprintf('%s_%s', tag, compNames{ii});

                if ~ismember(propName, this.hDynamicProperties.id)
                    propHandle = addprop(this, propName);
                    this.hDynamicProperties{end+1,:} = {propName, propHandle};
                end
                this.(propName) = obj.(compNames{ii});
            end
        end
    end
end