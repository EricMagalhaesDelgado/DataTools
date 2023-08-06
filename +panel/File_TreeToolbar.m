function File_TreeToolbar(src, event, app)

    switch src
        %-----------------------------------------------------------------%
        case app.File_Delete
            NN  = numel(app.File_Tree.SelectedNodes);
            idx = {};

            for ii = NN:-1:1
                idx1 = app.File_Tree.SelectedNodes(ii).NodeData.idx1;
                idx2 = app.File_Tree.SelectedNodes(ii).NodeData.idx2;

                if any(cellfun(@(x) isequal([idx1, idx2], x), idx))
                    continue
                else
                    idx{end+1} = [idx1, idx2];
                end
    
                if numel(app.metaData(idx1).Data) == numel(idx2)
                    app.metaData(idx1) = [];
                else
                    app.metaData(idx1).Data(idx2) = [];
                end
            end

            panel.File_TreeBuilding(app)

        
        %-----------------------------------------------------------------%
        case app.File_Up
            collapse(app.File_Tree, 'all')


        %-----------------------------------------------------------------%
        case app.File_Down
            expand(app.File_Tree, 'all')
    end
end