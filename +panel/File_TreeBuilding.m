function File_TreeBuilding(app)

    app.PanelFocus('File')    
    delete(app.File_Tree.Children)
                
    if numel(app.metaData)
        app.File_SpectralData.Enabled = true;
        
        for ii = 1:numel(app.metaData)
            imageIcon      = treeIcon(app.metaData(ii).Data(1).Receiver);
            [~, name, ext] = fileparts(app.metaData(ii).File);
            
            fileNode  = uitreenode(app.File_Tree, 'Text', [name ext], ...
                                                  'NodeData', struct('level', 1, 'idx1', ii, 'idx2', 1:numel(app.metaData(ii).Data)));
            [idnValues, ~, idnIndex] = unique({app.metaData(ii).Data.Receiver});
            for jj = 1:numel(idnValues)
                idx = find(idnIndex == jj)';
                idnNode  = uitreenode(fileNode,   'Text', idnValues{jj},                                   ...
                                                  'NodeData', struct('level', 2, 'idx1', ii, 'idx2', idx), ...
                                                  'Icon', imageIcon);
    
                for kk = idx
                    if ismember(app.metaData(ii).Data(kk).MetaData.DataType, class.Constants.specDataTypes)
                        uitreenode(idnNode, 'Text', sprintf('ID %d: %.3f - %.3f MHz',                              ...
                                                            app.metaData(ii).Data(kk).TaskData.ID,                 ...
                                                            app.metaData(ii).Data(kk).MetaData.FreqStart .* 1e-6,  ...
                                                            app.metaData(ii).Data(kk).MetaData.FreqStop  .* 1e-6), ...
                                            'NodeData', struct('level', 3, 'idx1', ii, 'idx2', kk));
                        
                    else
                        uitreenode(idnNode, 'Text', sprintf('ID %d: %.3f - %.3f MHz (Occupancy)',                  ...
                                                            app.metaData(ii).Data(kk).TaskData.ID,                 ...
                                                            app.metaData(ii).Data(kk).MetaData.FreqStart .* 1e-6,  ...
                                                            app.metaData(ii).Data(kk).MetaData.FreqStop  .* 1e-6), ... 
                                            'NodeData', struct('level', 3, 'idx1', ii, 'idx2', kk));
                    end
                end
            end
        end
        app.File_Tree.SelectedNodes = app.File_Tree.Children(1);
        
    else
        app.File_SpectralData.Enabled = false;
    end
    
    panel.File_TreeSelectionChanged([],[],app)
end