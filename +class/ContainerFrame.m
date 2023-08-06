classdef ContainerFrame < handle & dynamicprops

    properties
        %-----------------------------------------------------------------%
        pathToMFILE
        
        Container
        hWebWindow
        hDynamicProperties = table('Size', [0, 2], 'VariableTypes', {'cell', 'cell'}, 'VariableNames', {'id', 'handle'})
        
        metaData = class.metaData.empty;
        specData = [];
        
        uuid     = char(matlab.lang.internal.uuid())
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

            % Window size/position, and listener
            [x,y,w,h] = imageslib.internal.apputil.ScreenUtilities.getInitialToolPosition();
            set(this.Container, 'WindowBounds', [x,y,w,h], 'WindowMinSize', [640, 480]);
            addlistener(this.Container, 'StateChanged', @this.appStateChangedCallback);

            % Main containers/components building
            startupBuilding_TabGroup(this, class.Constants.appName)
            TabCreation(this, 'FILE')

            PanelCreation(this, 'File',         'left')
            PanelCreation(this, 'SpectralData', 'left')
            PanelCreation(this, 'Emission',     'left')

            startupBuilding_DocumentGroup(this)
            startupBuilding_QuickAccessBar(this)
            startupBuilding_StatusBar(this)

            % Visibility
            this.Container.Visible = true;            

            % Register app
            setappdata(groot, class.Constants.appName, this);

            % App startup (varargin - name of the file or folder to read)
        end


        %-----------------------------------------------------------------%
        function TabCreation(this, Tag)

            % Verifica se a aba existe...
            tabGroup = this.Container.getTabGroup(class.Constants.appName);
            try
                tabGroup.getChildByTag(Tag);
                return
            catch
            end

            % Parseando o arquivo de configuração e criando os objetos...
            tempFile = jsondecode(fileread(fullfile(fileparts(this.pathToMFILE), '+toolstrip', sprintf('toolstrip_ConfigFile_%s.json', Tag))));
            
            TabStruct  = tempFile.Tab;
            TabFields  = fields(TabStruct);
            
            % Objetos "TAB" e "SECTION"
            objStruct  = struct();
            for ii1 = 1:numel(TabFields)
                objStruct(ii1).Tab = matlab.ui.internal.toolstrip.Tab(TabFields{ii1});
                objStruct(ii1).Tab.Tag = TabFields{ii1};
                
                SectionNames = TabStruct.(TabFields{ii1});
                for jj1 = 1:numel(SectionNames)
                    objStruct(ii1).Section(jj1) = objStruct(ii1).Tab.addSection(SectionNames{jj1});
                end
            end

            CompTable = struct2table(tempFile.Components);
            CompTable = sortrows(CompTable, 'PositionID');

            % Objetos "GROUP"
            Groups = unique(CompTable.Group);
            GroupTable = table('Size', [0,2], 'VariableTypes', {'cell', 'cell'}, 'VariableNames', {'name', 'handle'});
            for ii = 1:numel(Groups)
                if ~isempty(Groups{ii})
                    GroupTable(end+1,:) = {Groups{ii}, {matlab.ui.internal.toolstrip.ButtonGroup()}};
                end
            end

            % Objeto COLUMN e componentes da GUI (atualmente limitado ao BUTTON, 
            % GRIDPICKERBUTTON, LABEL, SPINNER, DROPDOWN, TOGGLEBUTTON, 
            % RADIOBUTTON e DROPDOWNBUTTON)
            idx1 = fix(CompTable.PositionID/1000);                                      % Tab index
            for ii = 1:numel(TabFields)
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
                        if any(~strcmp(unique(tempTable_COLUMN.ColumnWidth), 'auto'))
                            colWidth = tempTable_COLUMN.ColumnWidth(cellfun(@(x) ~isnan(str2double(x)), tempTable_COLUMN.ColumnWidth));
                            colWidth = str2double(colWidth{1});
                        end
        
                        % ColumnHorizontalAlignment
                        colHorAlign = [];
                        if any(~strcmp(unique(tempTable_COLUMN.ColumnAlign), 'auto'))
                            colHorAlign = tempTable_COLUMN.ColumnAlign(cellfun(@(x) ~strcmp(x, 'auto'), tempTable_COLUMN.ColumnAlign));
                            colHorAlign = colHorAlign{1};
                        end

                        if colWidth & colHorAlign; Column = objStruct(ii).Section(jj).addColumn('Width', colWidth, 'HorizontalAlignment', colHorAlign);
                        elseif colWidth;           Column = objStruct(ii).Section(jj).addColumn('Width', colWidth);
                        elseif colHorAlign;        Column = objStruct(ii).Section(jj).addColumn(                   'HorizontalAlignment', colHorAlign);
                        else;                      Column = objStruct(ii).Section(jj).addColumn();
                        end

                        for ll = 1:height(tempTable_COLUMN)
                            Parameters = fields(tempTable_COLUMN.Parameters{ll});

                            switch tempTable_COLUMN.Type{ll}
                                case 'Button'
                                    Component = matlab.ui.internal.toolstrip.Button();
                                
                                case 'GridPickerButton'
                                    Component = matlab.ui.internal.toolstrip.GridPickerButton('', tempTable_COLUMN.Parameters{ll}.maxRows, tempTable_COLUMN.Parameters{ll}.maxColumns);
                                
                                case 'Label'
                                    Component = matlab.ui.internal.toolstrip.Label();
                                
                                case 'Spinner'
                                    Component = matlab.ui.internal.toolstrip.Spinner();
                                
                                case 'DropDown'
                                    Component = matlab.ui.internal.toolstrip.DropDown(tempTable_COLUMN.Parameters{ll}.Items);
                                
                                case 'ToggleButton'
                                    if isempty(tempTable_COLUMN.Group{ll})
                                        Component = matlab.ui.internal.toolstrip.ToggleButton();
                                    else
                                        idx = find(strcmp(GroupTable.name, tempTable_COLUMN.Group{ll}), 1);
                                        Component = matlab.ui.internal.toolstrip.ToggleButton('', GroupTable.handle{idx});
                                    end

                                case 'RadioButton'
                                    idx = find(strcmp(GroupTable.name, tempTable_COLUMN.Group{ll}), 1);
                                    Component = matlab.ui.internal.toolstrip.RadioButton(GroupTable.handle{idx});

                                case 'DropDownButton'
                                    popup = matlab.ui.internal.toolstrip.PopupList();
                                    for mm = 1:numel(tempTable_COLUMN.Parameters{ll}.Children)
                                        childComponent  = eval(sprintf('matlab.ui.internal.toolstrip.%s', tempTable_COLUMN.Parameters{ll}.Children(mm).Type));
                                        childParameters = fields(tempTable_COLUMN.Parameters{ll}.Children(mm).Parameters);
                                        ComponentProperties(this, tempTable_COLUMN(ll,:), childParameters, childComponent, 'childComponent', mm)

                                        popup.add(childComponent)
                                    end
                                    
                                    Component = matlab.ui.internal.toolstrip.DropDownButton();
                                    Component.Popup = popup;

                                case 'Gallery'
                                    popup = matlab.ui.internal.toolstrip.GalleryPopup();

                                    [categoryList, ~, categoryIndex] = unique({tempTable_COLUMN.Parameters{ll}.Children.Group});
                                    for mm = 1:numel(categoryList)
                                        categoryMember = matlab.ui.internal.toolstrip.GalleryCategory(categoryList{mm});

                                        idx = find(categoryIndex == mm)';
                                        for nn = idx
                                            childComponent  = eval(sprintf('matlab.ui.internal.toolstrip.%s', tempTable_COLUMN.Parameters{ll}.Children(nn).Type));
                                            childParameters = fields(tempTable_COLUMN.Parameters{ll}.Children(nn).Parameters);
                                            ComponentProperties(this, tempTable_COLUMN(ll,:), childParameters, childComponent, 'childComponent', nn)
    
                                            categoryMember.add(childComponent)
                                        end
                                        
                                        popup.add(categoryMember)
                                    end
                                    
                                    Component = matlab.ui.internal.toolstrip.Gallery(popup, 'MaxColumnCount', tempTable_COLUMN.Parameters{ll}.MaxColumnCount);
                            end
                            ComponentProperties(this, tempTable_COLUMN(ll,:), Parameters, Component, 'Component', -1)
                            Column.add(Component)

                            if tempTable_COLUMN.appProperty(ll)
                                % Registro do componente:
                                this.registerComponents(tempTable_COLUMN.appPropertyName{ll}, Component)
                            end
                        end
                    end
                end
                tabGroup.add(objStruct(ii).Tab)
            end
        end


        %-----------------------------------------------------------------%
        function TabRemove(this, Tag, propPrefix)
            
            % Verifica se a aba existe...
            tabGroup = this.Container.getTabGroup(class.Constants.appName);
            try
                hTab = tabGroup.getChildByTag(Tag);
                tabGroup.remove(hTab);

                if ~isempty(propPrefix)
                    idx = find(contains(this.hDynamicProperties.id, propPrefix));
                    for ii = numel(idx):-1:1
                        this.hDynamicProperties.handle{idx(ii)}.delete
                        this.hDynamicProperties(idx(ii),:) = [];
                    end
                end
                return
            catch
            end
        end


        %-----------------------------------------------------------------%
        function status = isValidObject(this, objType, objTag)

            switch objType
                case 'Panel'
                    hPanelList = struct(struct(this.Container).PanelMap).serialization.values;
                    if ismember(objTag, cellfun(@(x) x.Tag, hPanelList))
                        Panel = hPanelList{strcmp(cellfun(@(x) x.Tag, hPanelList), objTag)};
                        PanelFocus(this, hPanelList, Panel)
        
                        status = true;
                    else
                        status = false;
                    end

                case 'Figure'
                    hFigureList = struct(struct(this.Container).DocumentMap).serialization.values;
                    if ismember(objTag, cellfun(@(x) x.Tag, hFigureList))
                        Figure = hFigureList{strcmp(cellfun(@(x) x.Tag, hFigureList), objTag)};
                        PanelFocus(this, hFigureList, Figure)
        
                        status = true;
                    else
                        status = false;
                    end
            end
        end


        %-----------------------------------------------------------------%
        function PanelCreation(this, Tag, Position)

            Panel = matlab.ui.internal.FigurePanel(struct('Tag', Tag, 'Title', Tag, 'PermissibleRegions', Position, 'Region', Position, 'Maximizable', false, 'Opened', false));
            obj = eval(sprintf('panel.%s_PanelCreation(this, Panel.Figure)', Tag));
            
            % Registra componentes do novo painel como propriedade do objeto
            % "ContainerFrame".
            objFields = fields(obj);
            for ii = 1:numel(objFields)
                this.registerComponents(sprintf('%s_%s', Tag, objFields{ii}), obj.(objFields{ii}))
            end
            this.Container.addPanel(Panel)
        end


        %-----------------------------------------------------------------%
        function PanelFocus(this, Tag)

            Panel = [];
            hPanelList = struct(struct(this.Container).PanelMap).serialization.values;
            
            idx = find(strcmp(cellfun(@(x) x.Tag, struct(struct(this.Container).PanelMap).serialization.values), Tag), 1);
            if ~isempty(idx)
                Panel = hPanelList{idx};
            end

            for ii = 1:numel(hPanelList)
                if isequal(hPanelList{ii}, Panel)
                    hPanelList{ii}.Opened    = true;
                    hPanelList{ii}.Selected  = true;
                else
                    hPanelList{ii}.Collapsed = true;
                end
            end

            pause(.1)
            customComponents_PanelTitle(this)
        end


        %-----------------------------------------------------------------%
        function docFig = FigureCreation(this, Tag)
            % C:\Program Files\MATLAB\R2022b\toolbox\matlab\uitools\uicomponents\components\+matlab\+ui\+internal\FigureDocumentGroup.m

            docFig = matlab.ui.internal.FigureDocument();
            set(docFig, DocumentGroupTag='Tabs', Tag=Tag, Title=Tag)

            this.Container.addDocument(docFig)
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
        function startupBuilding_TabGroup(this, Tag)
            tabGroup = matlab.ui.internal.toolstrip.TabGroup();
            tabGroup.Tag = Tag;
            tabGroup.SelectedTabChangedFcn = {@toolstrip.TabGroup_SelectedTabChanged, this};

            this.Container.addTabGroup(tabGroup)
        end

        %-----------------------------------------------------------------%
        function startupBuilding_DocumentGroup(this)
            % C:\Program Files\MATLAB\R2022b\toolbox\matlab\uitools\uicomponents\components\+matlab\+ui\+internal\FigureDocumentGroup.m

            docGroup = matlab.ui.internal.FigureDocumentGroup(struct('Tag', 'Tabs', 'Title', 'Tabs'));
            this.Container.add(docGroup)
        end


        %-----------------------------------------------------------------%
        function startupBuilding_QuickAccessBar(this)
            % C:\Program Files\MATLAB\R2022b\toolbox\matlab\toolstrip\+matlab\+ui\+internal\+toolstrip\+qab
            helpButton = matlab.ui.internal.toolstrip.qab.QABHelpButton();
            helpButton.ButtonPushedFcn = {@toolstrip.QAB_Help, this};

            this.Container.add(helpButton) 
        end


        %-----------------------------------------------------------------%
        function startupBuilding_StatusBar(this)
            % C:\Program Files\MATLAB\R2022b\toolbox\matlab\appcontainer\+matlab\+ui\+internal\+statusbar\StatusBar.m
            
            statusLabel = matlab.ui.internal.statusbar.StatusLabel(struct('Icon', 'info_16.png', 'Text', 'Select files to read...', 'Region', 'left'));
            statusBar   = matlab.ui.internal.statusbar.StatusBar();
            statusBar.add(statusLabel)

            this.Container.addStatusBar(statusBar)   
        end


        %-----------------------------------------------------------------%
        function appStateChangedCallback(this, ~, ~)
            % Os estados de um objeto "AppContainer" são definidos por uma
            % enumeração. Fluxo:
            % INITIALIZING >> RUNNING >> TERMINATED
            switch this.Container.State
                case matlab.ui.container.internal.appcontainer.AppState.RUNNING
                    this.hWebWindow = struct(this.Container).Window;

                case matlab.ui.container.internal.appcontainer.AppState.TERMINATED
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


        %-----------------------------------------------------------------%
        % ## PARSING TOOLSTRIP CONFIG FILE (JSON) ##
        %-----------------------------------------------------------------%
        function ComponentProperties(this, tempTable_COLUMN, Parameters, Component, Tag, idx)

            for ii = 1:numel(Parameters)
                switch Tag
                    case 'Component'
                        parameterValue = tempTable_COLUMN.Parameters{1}.(Parameters{ii});
                    case 'childComponent'
                        parameterValue = tempTable_COLUMN.Parameters{1}.Children(idx).Parameters.(Parameters{ii});
                end

                switch Parameters{ii}
                    case {'ButtonPushedFcn', 'ValueChangedFcn', 'ItemPushedFcn'}
                        parameterValue = {str2func(parameterValue), this};
                    case 'Icon'
                        if strcmp(parameterValue(1:5), 'Icon.')
                            parameterValue = eval(sprintf('matlab.ui.internal.toolstrip.%s', parameterValue));
                        end
                    case {'Items', 'maxRows', 'maxColumns', 'Children', 'MaxColumnCount'}
                        % Properties that must be passing into the constructor
                        continue
                end
                Component.(Parameters{ii}) = parameterValue;
            end
        end

        %-----------------------------------------------------------------%
        % ## CUSTOM COMPONENTS ##
        %-----------------------------------------------------------------%
        function customComponents_PanelTitle(this)

            jsCommand = sprintf(['var elements = document.querySelectorAll(''span[class="title"]'');\n' ...
                                 'for (let ii = 0; ii < elements.length; ii++) {\n'                     ...
                                 '\telements[ii].style.fontSize = "11px";\n'                            ...
                                 '}\nelements = undefined;']);

            pause(.001)
            try
                this.hWebWindow.executeJS(jsCommand);     
            catch
            end
        end
    end
end