function ParsingConfigMFile(this)

    import matlab.ui.internal.toolstrip.*
    
    
    % Leitura do arquivo de configuração do toolstrip em JSON:
    tempFile = jsondecode(fileread('name2.json'));
    
    
    % Criação dos objetos TAB e SECTION:
    TabStruct  = tempFile.Tab;
    TabFields  = fields(TabStruct);
    
    objStruct  = struct();
    for ii = 1:numel(TabFields)
        objStruct(ii).Tab = Tab(TabFields{ii});
        
        SectionNames = TabStruct.(TabFields{ii});
        for jj = 1:numel(SectionNames)
            objStruct(ii).Section(jj) = objStruct(ii).Tab.addSection(SectionNames{jj});
        end
    end
    
    
    % Criação dos componentes:
    CompTable = struct2table(tempFile.Components);
    CompTable = sortrows(CompTable, 'PositionID');
    
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
    
                Column = objStruct(ii).Section(jj).addColumn();
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
    
                    if ~strcmp(tempTable_COLUMN.ColumnWidth{ll}, 'auto')
                        Column.Width = str2double(tempTable_COLUMN.ColumnWidth{ll});
                    end
    
                    if ~strcmp(tempTable_COLUMN.ColumnHorAlign{ll}, 'auto')
                        Column.HorizontalAlignment = tempTable_COLUMN.ColumnHorAlign{ll};
                    end
    
                    if tempTable_COLUMN.appProperty(ll)
                        addprop(this, tempTable_COLUMN.appPropertyName{ll})
                        this.(tempTable_COLUMN.appPropertyName{ll}) = Component;
                    end
                end
            end
        end
    end
end