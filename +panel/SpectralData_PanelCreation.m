function app = SpectralData_PanelCreation(this, hFig)

    app = struct();

    %---------------------------------------------------------------------%
    % ## APPDESIGNER ##
    %---------------------------------------------------------------------%
    % Create Grid
    app.Grid = uigridlayout(hFig);
    app.Grid.ColumnWidth = {16, '1x', 16, 16};
    app.Grid.RowHeight = {'1x', 16, 25, '0.5x'};
    app.Grid.ColumnSpacing = 3;
    app.Grid.RowSpacing = 3;
    app.Grid.BackgroundColor = [0.9608 0.9608 0.9608];

    % Create Tree
    app.Tree = uitree(app.Grid);
    app.Tree.Multiselect = 'on';
    app.Tree.FontSize = 11;
    app.Tree.Layout.Row = 1;
    app.Tree.Layout.Column = [1 4];

    % Create Delete
    app.Delete = uiimage(app.Grid);
    app.Delete.Layout.Row = 2;
    app.Delete.Layout.Column = 1;
    app.Delete.ImageSource = 'X_16.png';

    % Create Up
    app.Up = uiimage(app.Grid);
    app.Up.Layout.Row = 2;
    app.Up.Layout.Column = 3;
    app.Up.VerticalAlignment = 'top';
    app.Up.ImageSource = 'LT_upArrow_Zoom.png';

    % Create Down
    app.Down = uiimage(app.Grid);
    app.Down.Layout.Row = 2;
    app.Down.Layout.Column = 4;
    app.Down.VerticalAlignment = 'top';
    app.Down.ImageSource = 'LT_downArrow_Zoom.png';

    % Create MetadataLabel
    app.MetadataLabel = uilabel(app.Grid);
    app.MetadataLabel.VerticalAlignment = 'bottom';
    app.MetadataLabel.FontSize = 11;
    app.MetadataLabel.Layout.Row = 3;
    app.MetadataLabel.Layout.Column = [1 4];
    app.MetadataLabel.Text = 'Metadata:';

    % Create MetadataPanel
    app.MetadataPanel = uipanel(app.Grid);
    app.MetadataPanel.Layout.Row = 4;
    app.MetadataPanel.Layout.Column = [1 4];

    % Create MetadataGrid
    app.MetadataGrid = uigridlayout(app.MetadataPanel);
    app.MetadataGrid.ColumnWidth = {'1x'};
    app.MetadataGrid.RowHeight = {'1x'};
    app.MetadataGrid.BackgroundColor = [1 1 1];

    % Create Metadata
    app.Metadata = uihtml(app.MetadataGrid);
    app.Metadata.HTMLSource = ' ';
    app.Metadata.Layout.Row = 1;
    app.Metadata.Layout.Column = 1;

    %---------------------------------------------------------------------%
    % ## CALLBACKS ##
    %---------------------------------------------------------------------%
    app.Tree.SelectionChangedFcn = {@panel.SpectralData_TreeSelectionChanged, this};
    app.Delete.ImageClickedFcn   = {@panel.SpectralData_TreeToolbar,          this};
    app.Up.ImageClickedFcn       = {@panel.SpectralData_TreeToolbar,          this};
    app.Down.ImageClickedFcn     = {@panel.SpectralData_TreeToolbar,          this};
end