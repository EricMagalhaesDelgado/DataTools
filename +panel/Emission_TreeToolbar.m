function Emission_TreeToolbar(src, event, app)

    switch src
        case app.SpectralData_Delete
            if ~isempty(app.SpectralData_Tree.SelectedNodes)
                idx = unique([app.SpectralData_Tree.SelectedNodes.NodeData]);
                app.specData(idx) = [];
                
                file.TreeBuilding_SpectralData(app)
            end

        case app.SpectralData_Up
            collapse(app.SpectralData_Tree, 'all')

        case app.SpectralData_Down
            expand(app.SpectralData_Tree, 'all')
    end
end