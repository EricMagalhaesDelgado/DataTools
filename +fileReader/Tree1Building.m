function Tree1Building(app)

    delete(app.file_Tree1.Children)
                
    if numel(app.metaData)
        % app.File_Button_ReadFiles.Enable = 1; % Inserir o botão de
        % espectro aqui
        
        for ii = 1:numel(app.metaData)
            imageIcon      = treeIcon(app.metaData(ii).Data(1).Node);                    
            [~, name, ext] = fileparts(app.metaData(ii).File);
            
            fileNode = uitreenode(app.file_Tree1, 'Text', [name ext], ...
                                                  'NodeData', ii);

            idnNode  = uitreenode(fileNode,       'Text', app.metaData(ii).Data(1).Node, ...
                                                  'NodeData', ii,                        ...
                                                  'Icon', imageIcon);

            for jj = 1:numel(app.metaData(ii).Data)
                if ismember(app.metaData(ii).Data(jj).MetaData.DataType, class.Constants.specDataTypes)
                    uitreenode(idnNode, 'Text', sprintf('ID %d: %.3f - %.3f MHz',                              ...
                                                        app.metaData(ii).Data(jj).ThreadID,                    ...
                                                        app.metaData(ii).Data(jj).MetaData.FreqStart .* 1e-6,  ...
                                                        app.metaData(ii).Data(jj).MetaData.FreqStop  .* 1e-6), ...
                                        'NodeData', jj);
                    
                else
                    uitreenode(idnNode, 'Text', sprintf('ID %d: %.3f - %.3f MHz (Ocupação)',                  ...
                                                        app.metaData(ii).Data(jj).ThreadID,                   ...
                                                        app.metaData(ii).Data(jj).MetaData.FreqStart .* 1e-6, ...
                                                        app.metaData(ii).Data(jj).MetaData.FreqStop .* 1e-6), ... 
                                        'NodeData', jj);
                end
            end
        end
        expand(app.file_Tree1, 'all')
        app.file_Tree1.SelectedNodes = app.file_Tree1.Children(1);
        
    else
        % app.File_Button_ReadFiles.Enable = 0;
    end
    
%     File_Tree1SelectionChanged(app)
end


%-------------------------------------------------------------------------%
function File_Tree2_Building(app)
    
    delete(app.File_Tree2.Children);
    
    ind = app.File_Tree1.SelectedNodes.NodeData;
    
    Category = {};
    for ii = 1:numel(app.metaData(ind).Data)
        Category = [Category, app.metaData(ind).Data(ii).Node];
    end
    Category = unique(Category);
    
    for ii = 1:numel(Category)
        imageIcon = Fcn_TreeIcon(app, Category{ii});
        TempNode  = uitreenode(app.File_Tree2, 'Text', Category{ii},     ...
                                               'NodeData', Category{ii}, ...
                                               'Icon', imageIcon);
        
        for jj = 1:numel(app.metaData(ind).Data)
            if strcmp(Category{ii}, app.metaData(ind).Data(jj).Node)
                if ismember(app.metaData(ind).Data(jj).MetaData.DataType, class.Constants.specDataTypes)
                    uitreenode(TempNode, 'Text', sprintf('ThreadID %d: %.3f - %.3f MHz',                         ...
                                                         app.metaData(ind).Data(jj).ThreadID,                    ...
                                                         app.metaData(ind).Data(jj).MetaData.FreqStart .* 1e-6,  ...
                                                         app.metaData(ind).Data(jj).MetaData.FreqStop  .* 1e-6), ...
                                         'NodeData', jj, 'ContextMenu', app.ContextMenu_File2);
                    
                else
                    uitreenode(TempNode, 'Text', sprintf('ThreadID %d: %.3f - %.3f MHz (Ocupação)',       ...
                                                         app.metaData(ind).Data(jj).ThreadID,             ...
                                                         app.metaData(ind).Data(jj).MetaData.FreqStart .* 1e-6, ...
                                                         app.metaData(ind).Data(jj).MetaData.FreqStop .* 1e-6), ... 
                                         'NodeData', jj, 'ContextMenu', app.ContextMenu_File2);
                end
            end
        end
    end
    Fcn_expandTree(app, 'File')
    
    app.File_Tree2.SelectedNodes = app.File_Tree2.Children(1).Children(1);
    File_Tree2SelectionChanged(app)
    
end