function Emission_TreeSelectionChanged(src, event, app, idx)

    if ~isempty(app.Emission_Tree.Children)
        delete(app.Emission_Tree.Children)
    end

    emissionTable = app.specData(idx).UserData.Emissions;
    if ~isempty(emissionTable)
        set(app.ManualEditionGrid.Children, 'Enable', 'on')

        for ii = 1:height(emissionTable)
            if emissionTable.isTruncated(ii); treeIcon = 'play_Truncated.png';
            else;                             treeIcon = 'play_Untruncated.png';
            end
    
            uitreenode(app.Emission_Tree, 'Text', sprintf('%d: %.3f MHz @ %.3f kHz', ii, emissionTable.FreqCenter(ii), emissionTable.BW(ii)), ...
                                          'NodeData', ii, 'Icon', treeIcon);
        end

        app.Playback_EmissionTree.SelectedNode = app.Playback_EmissionTree.Children(1);
        panel.Emission_TreeSelectionChanged([], [], app)

    else
        set(app.Emission_ManualEditionGrid.Children, 'Enable', 'off')
        app.Emission_FreqCenter.Value        = 0;
        app.Emission_Bandwidth.Value         = 0;
        app.Emission_TruncatedCheckBox.Value = 0;
    end
end