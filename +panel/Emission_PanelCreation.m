function app = Emission_PanelCreation(this, hFig)

    app = struct();

    %---------------------------------------------------------------------%
    % ## APPDESIGNER ##
    %---------------------------------------------------------------------%
    % Create Grid
    app.Grid = uigridlayout(hFig);
    app.Grid.ColumnWidth = {16, '1x', 16};
    app.Grid.RowHeight = {'1x', 16, 25, 96};
    app.Grid.ColumnSpacing = 3;
    app.Grid.RowSpacing = 3;
    app.Grid.BackgroundColor = [0.9608 0.9608 0.9608];

    % Create Tree
    app.Tree = uitree(app.Grid);
    app.Tree.Multiselect = 'on';
    app.Tree.FontSize = 11;
    app.Tree.Layout.Row = 1;
    app.Tree.Layout.Column = [1 3];

    % Create Delete
    app.Delete = uiimage(app.Grid);
    app.Delete.Enable = 'off';
    app.Delete.Layout.Row = 2;
    app.Delete.Layout.Column = 1;
    app.Delete.HorizontalAlignment = 'right';
    app.Delete.ImageSource = 'X_16.png';

    % Create Info
    app.Info = uiimage(app.Grid);
    app.Info.Enable = 'off';
    app.Info.Layout.Row = 2;
    app.Info.Layout.Column = 3;
    app.Info.HorizontalAlignment = 'right';
    app.Info.ImageSource = 'info_16.png';

    % Create ManualEditionLabel
    app.ManualEditionLabel = uilabel(app.Grid);
    app.ManualEditionLabel.VerticalAlignment = 'bottom';
    app.ManualEditionLabel.FontSize = 11;
    app.ManualEditionLabel.Layout.Row = 3;
    app.ManualEditionLabel.Layout.Column = [1 3];
    app.ManualEditionLabel.Text = 'Manual edition:';

    % Create ManualEditionPanel
    app.ManualEditionPanel = uipanel(app.Grid);
    app.ManualEditionPanel.Layout.Row = 4;
    app.ManualEditionPanel.Layout.Column = [1 3];

    % Create ManualEditionGrid
    app.ManualEditionGrid = uigridlayout(app.ManualEditionPanel);
    app.ManualEditionGrid.ColumnWidth = {'1x', 110};
    app.ManualEditionGrid.RowHeight = {22, 22, 22};
    app.ManualEditionGrid.RowSpacing = 5;
    app.ManualEditionGrid.BackgroundColor = [0.9608 0.9608 0.9608];

    % Create FreqCenterLabel
    app.FreqCenterLabel = uilabel(app.ManualEditionGrid);
    app.FreqCenterLabel.FontSize = 11;
    app.FreqCenterLabel.Enable = 'off';
    app.FreqCenterLabel.Layout.Row = 1;
    app.FreqCenterLabel.Layout.Column = 1;
    app.FreqCenterLabel.Text = 'Center frequency (MHz):';

    % Create FreqCenter
    app.FreqCenter = uieditfield(app.ManualEditionGrid, 'numeric');
    app.FreqCenter.Limits = [0 Inf];
    app.FreqCenter.ValueDisplayFormat = '%3f';
    app.FreqCenter.FontSize = 11;
    app.FreqCenter.Enable = 'off';
    app.FreqCenter.Layout.Row = 1;
    app.FreqCenter.Layout.Column = 2;

    % Create BandwidthLabel
    app.BandwidthLabel = uilabel(app.ManualEditionGrid);
    app.BandwidthLabel.FontSize = 11;
    app.BandwidthLabel.Enable = 'off';
    app.BandwidthLabel.Layout.Row = 2;
    app.BandwidthLabel.Layout.Column = 1;
    app.BandwidthLabel.Text = 'Occupied bandwidth (kHz):';

    % Create Bandwidth
    app.Bandwidth = uieditfield(app.ManualEditionGrid, 'numeric');
    app.Bandwidth.Limits = [0 Inf];
    app.Bandwidth.ValueDisplayFormat = '%3f';
    app.Bandwidth.FontSize = 11;
    app.Bandwidth.Enable = 'off';
    app.Bandwidth.Layout.Row = 2;
    app.Bandwidth.Layout.Column = 2;

    % Create TruncatedCheckBox
    app.TruncatedCheckBox = uicheckbox(app.ManualEditionGrid);
    app.TruncatedCheckBox.Enable = 'off';
    app.TruncatedCheckBox.Text = 'Truncated center frequency';
    app.TruncatedCheckBox.FontSize = 11;
    app.TruncatedCheckBox.Layout.Row = 3;
    app.TruncatedCheckBox.Layout.Column = [1 2];

    %---------------------------------------------------------------------%
    % ## CALLBACKS ##
    %---------------------------------------------------------------------%
    app.Tree.SelectionChangedFcn          = {@panel.Emission_TreeSelectionChanged, this};
    app.Delete.ImageClickedFcn            = {@panel.Emission_TreeToolbar,          this};
    app.FreqCenter.ValueChangedFcn        = {@panel.Emission_TreeToolbar,          this};
    app.Bandwidth.ValueChangedFcn         = {@panel.Emission_TreeToolbar,          this};
    app.TruncatedCheckBox.ValueChangedFcn = {@panel.Emission_TreeToolbar,          this};
end