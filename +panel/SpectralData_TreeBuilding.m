function SpectralData_TreeBuilding(app)

    app.PanelFocus('SpectralData')
    
    delete(app.SpectralData_Tree.Children)
    app.SpectralData_Metadata.HTMLSource = ' ';
                
    if numel(app.specData)
        app.File_EditLocation.Enabled = true;
        app.File_Export.Enabled       = true;

        TabCreation(app, 'PLAYBACK')
        TabCreation(app, 'REPORT')
        
        [uniqueNodes, ~, ic] = unique({app.specData.Receiver});        
        for ii = 1:numel(uniqueNodes)
            idx1 = find(ic == ii)';
    
            imageIcon = treeIcon(app.specData(ii).Receiver);
            Category  = uitreenode(app.SpectralData_Tree, 'Text', uniqueNodes{ii}, ...
                                                          'NodeData', idx1,        ...
                                                          'Icon', imageIcon);

            for jj = idx1
                occMsg = '';
                if ismember(app.specData(jj).MetaData.DataType, class.Constants.occDataTypes)
                    occMsg = '(Occupancy)';
                end
    
                Attributes = uitreenode(Category, 'Text', sprintf('ID %d: %.3f - %.3f MHz %s',                ...
                                                                  app.specData(jj).TaskData.ID,               ...
                                                                  app.specData(jj).MetaData.FreqStart / 1e+6, ...
                                                                  app.specData(jj).MetaData.FreqStop  / 1e+6, ...
                                                                  occMsg),                                    ...
                                                  'NodeData', jj);

                % GPS
                if app.specData(jj).GPS.Status
                    gpsNode = uitreenode(Attributes, 'Text', sprintf('%.6f, %.6f (%s)', app.specData(jj).GPS.Latitude,  ...
                                                                                        app.specData(jj).GPS.Longitude, ...
                                                                                        app.specData(jj).GPS.Location), ...
                                                     'NodeData', jj);
                    if app.specData(jj).GPS.Status == -1
                        gpsNode.Icon = 'LT_manual.png';
                    end
                
                else
                    uitreenode(Attributes, 'Text', sprintf('%.6f, %.6f (%s)', app.specData(jj).GPS.Latitude,  ...
                                                                              app.specData(jj).GPS.Longitude, ...
                                                                              app.specData(jj).GPS.Location), ...
                                           'NodeData', jj);
                end
    
                % THRESHOLD
                if ismember(app.specData(jj).MetaData.DataType, class.Constants.specDataTypes)
                    if ~isempty(app.specData(jj).UserData.reportOCC.Related)
                    Temp2 = uitreenode(Attributes, 'Text', 'Fluxo(s) de ocupação', 'NodeData', jj);
    
                        if isempty(app.specData(jj).UserData.reportOCC.Index)
                            uitreenode(Temp2, 'Text', 'Ocupação a ser aferida', 'NodeData', jj, 'Icon', 'LT_manual.png');
                        end
                        
                        idx2 = app.specData(jj).UserData.reportOCC.Related;
                        for kk = idx2
                            occNode = uitreenode(Temp2, 'Text', sprintf('Threshold: %d %s (ID %d)',           ...
                                                                         app.specData(kk).MetaData.Threshold, ...
                                                                         app.specData(kk).MetaData.LevelUnit, ...
                                                                         app.specData(kk).ID),                ...
                                                        'NodeData', jj);
                            if (app.specData(jj).UserData.reportOCC.Index == kk) & (kk == idx2(1))
                                occNode.Icon = 'LT_auto.png';
                            elseif app.specData(jj).UserData.reportOCC.Index == kk
                                occNode.Icon = 'LT_manual.png';
                            end
                        end
                    end
    
                else
                    uitreenode(Attributes, 'Text', sprintf('Threshold: %d %s',                    ...
                                                            app.specData(jj).MetaData.Threshold,  ...
                                                            app.specData(jj).MetaData.LevelUnit), ...
                                           'NodeData', jj);
                end
            end
            expand(app.SpectralData_Tree.Children(ii))
        end

    else
        app.File_EditLocation.Enabled = false;
        app.File_Export.Enabled       = false;

        TabRemove(app, 'PLAYBACK', 'Playback_')
        TabRemove(app, 'REPORT',   'Report_')
    end
end