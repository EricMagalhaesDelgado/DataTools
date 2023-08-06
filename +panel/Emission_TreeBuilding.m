function Emission_TreeBuilding(src, event, app, idx)

    if ~isempty(app.Playback_EmissionTree.Children)
        delete(app.Playback_EmissionTree.Children)
    end

    emissionTable = app.specData(idx).UserData.Emissions;
    if ~isempty(emissionTable)
        set(app.ManualEditionGrid.Children, 'Enable', 'on')

        for ii = 1:height(emissionTable)
            if emissionTable.isTruncated(ii); treeIcon = 'play_Truncated.png';
            else;                             treeIcon = 'play_Untruncated.png';
            end
    
            uitreenode(app.Playback_EmissionTree, 'Text', sprintf('%d: %.3f MHz @ %.3f kHz', ii, emissionTable.FreqCenter(ii), emissionTable.BW(ii)), ...
                                                  'NodeData', ii, 'Icon', treeIcon);
        end

        app.Playback_EmissionTree.SelectedNode = app.Playback_EmissionTree.Children(1);
        playback.callbacks.EmissionTreeSelectionChanged([], [], app)

    else
        set(app.ManualEditionGrid.Children, 'Enable', 'off')
        app.Playback_FreqCenter.Value = 0;
        app.Playback_BW.Value         = 0;
        app.TruncatedCheckBox.Value   = 0;
    end
end