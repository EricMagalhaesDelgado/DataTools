classdef ContainerFrame < handle & dynamicprops

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
        hStatusBar
        
        hDynamicProperties = table('Size', [0, 2], 'VariableTypes', {'cell', 'cell'}, 'VariableNames', {'id', 'handle'})

        % Toolstrip componentes handles
        % tool_OpenButton = struct(struct(struct(struct(struct(app.Container).TabGroupOrder).Children(1)).Children).Children).Children

        
        metaData = struct('File', {}, 'Type', {}, 'Data', {}, 'Samples', {}, 'Memory', {});
        Samples  = [];
        specData = [];
        
        uuid
    end
    
    methods
        %-----------------------------------------------------------------%
        function this = ContainerFrame(varargin)

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
            this.hStatusBar    = struct(struct(this.Container).StatusBar).Children;
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
            % Hierarquia:
            % TABGROUP >> TAB >> SECTION >> COLUMN >> COMPONENTS

            import matlab.ui.internal.toolstrip.*            
            
            % Leitura do arquivo de configuração do toolstrip em JSON:
            tempFile = jsondecode(fileread('name3.json'));            
            
            % Criação dos objetos TAB e SECTION:
            TabStruct  = tempFile.Tab;
            TabFields  = fields(TabStruct);
            
            objStruct  = struct();
            for ii = 1:numel(TabFields)
                objStruct(ii).Tab = Tab(TabFields{ii});
                objStruct(ii).Tab.Tag = TabFields{ii};
                
                SectionNames = TabStruct.(TabFields{ii});
                for jj = 1:numel(SectionNames)
                    objStruct(ii).Section(jj) = objStruct(ii).Tab.addSection(SectionNames{jj});
                end
            end            
            
            % Criação dos componentes:
            CompTable = struct2table(tempFile.Components);
            CompTable = sortrows(CompTable, 'PositionID');

            tabGroup = TabGroup();
            tabGroup.Tag = 'myTabGroup';
            
            for ii = 1:numel(TabFields)
                idx1 = fix(CompTable.PositionID/1000);                                  % Tab index
                tempTable_TAB = CompTable(idx1==ii,:);
            
                SectionNames = TabStruct.(TabFields{ii});
                for jj = 1:numel(SectionNames)
                    idx2 = fix((tempTable_TAB.PositionID - ii*1000)/100);               % Section index
                    tempTable_SECTION = tempTable_TAB(idx2==jj,:);
            
                    idx3 = fix((tempTable_SECTION.PositionID - ii*1000 - jj*100)/10);   % Column index
                    for kk = 1:numel(unique(idx3))
                        tempTable_COLUMN = tempTable_SECTION(idx3==kk,:);
            
                        % ColumnWidth
                        colWidth = [];
                        if ~strcmp(unique(tempTable_COLUMN.ColumnWidth), 'auto')
                            colWidth = tempTable_COLUMN.ColumnWidth(cellfun(@(x) ~isnan(str2double(x)), tempTable_COLUMN.ColumnWidth));
                            colWidth = str2double(colWidth{1});
                        end
        
                        % ColumnHorizontalAlignment
                        colHorAlign = [];
                        if ~strcmp(unique(tempTable_COLUMN.ColumnHorAlign), 'auto')
                            colHorAlign = tempTable_COLUMN.ColumnHorAlign(cellfun(@(x) ~strcmp(x, 'auto'), tempTable_COLUMN.ColumnHorAlign));
                            colHorAlign = colHorAlign{1};
                        end

                        if colWidth & colHorAlign; Column = objStruct(ii).Section(jj).addColumn('Width', colWidth, 'HorizontalAlignment', colHorAlign);
                        elseif colWidth;           Column = objStruct(ii).Section(jj).addColumn('Width', colWidth);
                        elseif colHorAlign;        Column = objStruct(ii).Section(jj).addColumn(                   'HorizontalAlignment', colHorAlign);
                        else;                      Column = objStruct(ii).Section(jj).addColumn();
                        end

                        for ll = 1:height(tempTable_COLUMN)
                            switch tempTable_COLUMN.Type{ll}
                                case 'Button';       Component = Button();
                                case 'ToggleButton'; Component = ToggleButton();
                                case 'Label';        Component = Label();
                                case 'Spinner';      Component = Spinner();
                            end
            
                            Parameters = fields(tempTable_COLUMN.Parameters{ll});
                            for mm = 1:numel(Parameters)
                                ParameterValue = tempTable_COLUMN.Parameters{ll}.(Parameters{mm});
            
                                switch Parameters{mm}
                                    case {'ButtonPushedFcn', 'ValueChangedFcn'}
                                        ParameterValue = {str2func(ParameterValue), this};
                                    case 'Icon'
                                        if strcmp(ParameterValue(1:5), 'Icon.')
                                            ParameterValue = eval(ParameterValue);
                                        end
                                end
            
                                Component.(Parameters{mm}) = ParameterValue;
                            end
                            Column.add(Component)
            
                            if tempTable_COLUMN.appProperty(ll)
                                this.registerComponents(tempTable_COLUMN.appPropertyName{ll}, Component)
                            end
                        end
                    end
                end
                tabGroup.add(objStruct(ii).Tab)
            end
            this.Container.addTabGroup(tabGroup)
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

            docFig1  = matlab.ui.internal.FigureDocument();
            docFig2  = matlab.ui.internal.FigureDocument();
            set(docFig1, DocumentGroupTag='Tabs', Tag='Figure1', Title='FIG 1', Closable=false)
            set(docFig2, DocumentGroupTag='Tabs', Tag='Figure2', Title='FIG 2')

            this.Container.add(docGroup)

            this.Container.addDocument(docFig1)
            this.Container.addDocument(docFig2)
        end


        %-----------------------------------------------------------------%
        function startupBuilding_PanelGroup(this)
            leftPanelOptions      = struct('Tag', 'LeftPanel1',  'Title', 'Spectral data', 'PermissibleRegions', 'left',  'Region', 'left');
            leftPanel             = matlab.ui.internal.FigurePanel(leftPanelOptions);
            
            leftPanel.Maximizable = true;
            leftPanel.Closable    = true;
%             leftPanel.Contextual  = true;

            leftPanelOptions2      = struct('Tag', 'LeftPanel2',  'Title', 'Spectral data', 'PermissibleRegions', 'left',  'Region', 'left');
            leftPanel2             = matlab.ui.internal.FigurePanel(leftPanelOptions2);
            
            leftPanel2.Maximizable = true;
            leftPanel2.Closable    = true;
%             leftPanel2.Contextual  = true;

            obj = createComponents.file(leftPanel.Figure);
            objFields = fields(obj);
            for ii = 1:numel(objFields)
                this.registerComponents(sprintf('leftPanel%d', ii), obj.(objFields{ii}))
            end

            % Por enquanto não criarei os painéis abaixo e à direita do
            % documento.

            bottomPanel = [];
            rightPanel  = [];

            panelGroup  = {leftPanel, leftPanel2, bottomPanel, rightPanel};
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
        function registerComponents(this, propName, propObj)
            if ~ismember(propName, this.hDynamicProperties.id)
                propHandle = addprop(this, propName);
                this.hDynamicProperties{end+1,:} = {propName, propHandle};
            end
            this.(propName) = propObj;
        end
    end
end