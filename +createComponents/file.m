function app = file(hFig)

    app = struct();

    % Create Grid
    app.Grid = uigridlayout(hFig);
    app.Grid.ColumnWidth = {'1x', 22};
    app.Grid.RowHeight = {22, '1x', 22, '1x', 22, '0.5x'};
    app.Grid.ColumnSpacing = 5;
    app.Grid.RowSpacing = 5;

    % Create Tree1Label
    app.Tree1Label = uilabel(app.Grid);
    app.Tree1Label.VerticalAlignment = 'bottom';
    app.Tree1Label.FontSize = 11;
    app.Tree1Label.FontWeight = 'bold';
    app.Tree1Label.Layout.Row = 1;
    app.Tree1Label.Layout.Column = 1;
    app.Tree1Label.Text = 'Arquivo(s):';

    % Create Tree1
    app.Tree1 = uitree(app.Grid);
    app.Tree1.Layout.Row = 2;
    app.Tree1.Layout.Column = 1;

    % Create Tree1Grid
    app.Tree1Grid = uigridlayout(app.Grid);
    app.Tree1Grid.ColumnWidth = {'1x'};
    app.Tree1Grid.RowHeight = {'1x', 22};
    app.Tree1Grid.ColumnSpacing = 5;
    app.Tree1Grid.RowSpacing = 5;
    app.Tree1Grid.Padding = [0 0 0 0];
    app.Tree1Grid.Layout.Row = 2;
    app.Tree1Grid.Layout.Column = 2;

    % Create Tree1Button
    app.Tree1Button = uibutton(app.Tree1Grid, 'push');
    app.Tree1Button.Icon = 'edit_24.png';
    app.Tree1Button.Layout.Row = 2;
    app.Tree1Button.Layout.Column = 1;
    app.Tree1Button.Text = '';

    % Create Tree2Label
    app.Tree2Label = uilabel(app.Grid);
    app.Tree2Label.VerticalAlignment = 'bottom';
    app.Tree2Label.FontSize = 11;
    app.Tree2Label.FontWeight = 'bold';
    app.Tree2Label.Layout.Row = 3;
    app.Tree2Label.Layout.Column = 1;
    app.Tree2Label.Text = 'Fluxo(s) de dados:';

    % Create Tree2
    app.Tree2 = uitree(app.Grid);
    app.Tree2.Layout.Row = 4;
    app.Tree2.Layout.Column = 1;

    % Create Tree2Grid
    app.Tree2Grid = uigridlayout(app.Grid);
    app.Tree2Grid.ColumnWidth = {'1x'};
    app.Tree2Grid.RowHeight = {'1x', 22, 22};
    app.Tree2Grid.ColumnSpacing = 5;
    app.Tree2Grid.RowSpacing = 5;
    app.Tree2Grid.Padding = [0 0 0 0];
    app.Tree2Grid.Layout.Row = 4;
    app.Tree2Grid.Layout.Column = 2;

    % Create Tree2Button1
    app.Tree2Button1 = uibutton(app.Tree2Grid, 'push');
    app.Tree2Button1.Icon = 'edit_24.png';
    app.Tree2Button1.Layout.Row = 2;
    app.Tree2Button1.Layout.Column = 1;
    app.Tree2Button1.Text = '';

    % Create Tree2Button2
    app.Tree2Button2 = uibutton(app.Tree2Grid, 'push');
    app.Tree2Button2.Icon = 'play_24.png';
    app.Tree2Button2.Layout.Row = 3;
    app.Tree2Button2.Layout.Column = 1;
    app.Tree2Button2.Text = '';

    % Create MetadataLabel
    app.MetadataLabel = uilabel(app.Grid);
    app.MetadataLabel.VerticalAlignment = 'bottom';
    app.MetadataLabel.FontSize = 11;
    app.MetadataLabel.Layout.Row = 5;
    app.MetadataLabel.Layout.Column = 1;
    app.MetadataLabel.Text = 'Metadados:';

    % Create Metadata
    app.Metadata = uitextarea(app.Grid);
    app.Metadata.FontSize = 11;
    app.Metadata.Layout.Row = 6;
    app.Metadata.Layout.Column = 1;

    % Create MetadataGrid
    app.MetadataGrid = uigridlayout(app.Grid);
    app.MetadataGrid.ColumnWidth = {'1x'};
    app.MetadataGrid.RowHeight = {'1x', 22};
    app.MetadataGrid.ColumnSpacing = 5;
    app.MetadataGrid.RowSpacing = 5;
    app.MetadataGrid.Padding = [0 0 0 0];
    app.MetadataGrid.Layout.Row = 6;
    app.MetadataGrid.Layout.Column = 2;

    % Create MetadataButton
    app.MetadataButton = uibutton(app.MetadataGrid, 'push');
    app.MetadataButton.Icon = 'info_24.png';
    app.MetadataButton.Layout.Row = 2;
    app.MetadataButton.Layout.Column = 1;
    app.MetadataButton.Text = '';
end