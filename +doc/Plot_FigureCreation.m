function Plot_FigureCreation(app, fHandle)
    t = tiledlayout(fHandle, 5, 1, "Padding", "tight", "TileSpacing", "tight");

    % app.axes1
    app.axes1 = uiaxes(t);
    app.axes1.Layout.Tile = 1;
    set(app.axes1, Color=[0 0 0], FontName='Helvetica', FontSize=9, FontSmoothing='on',     ...
                                  XGrid='on', XMinorGrid='on', YGrid='on', YMinorGrid='on', ...
                                  GridAlpha=.25, GridColor=[.94,.94,.94], MinorGridAlpha=.2, MinorGridColor=[.94,.94,.94], Interactions=[], XTickLabel={})
    ylabel(app.axes1, 'Level (dB)')

    % app.axes2
    app.axes2 = uiaxes(t);
    app.axes2.Layout.Tile = 2;
    set(app.axes2, Color=[0 0 0], FontName='Helvetica', FontSize=9, FontSmoothing='on',     ...
                                  XGrid='on', XMinorGrid='on', YGrid='on', YMinorGrid='on', ...
                                  GridAlpha=.25, GridColor=[.94,.94,.94], MinorGridAlpha=.2, MinorGridColor=[.94,.94,.94], Interactions=[], XTickLabel={})
    ylabel(app.axes2, 'Occupancy (%)')
    
    % app.axes3
    app.axes3 = uiaxes(t);
    app.axes3.Layout.Tile = 3;
    app.axes3.Layout.TileSpan = [3,1];
    set(app.axes3, Color=[.94,.94,.94], FontName='Helvetica', FontSize=9, FontSmoothing='on', Interactions = [])
    xlabel(app.axes3, 'Frequency (MHz)')
    ylabel(app.axes3, 'Samples')

    % Others aspects...
    hold(app.axes1, 'on')
    hold(app.axes2, 'on')
    hold(app.axes3, 'on')
    
    disableDefaultInteractivity(app.axes1)
    disableDefaultInteractivity(app.axes2)
    disableDefaultInteractivity(app.axes3)

    axtoolbar(app.axes1, {'datacursor', 'pan', 'zoomin', 'zoomout', 'restoreview'});
    axtoolbar(app.axes2, {'datacursor', 'pan', 'zoomin', 'zoomout', 'restoreview'});
    axtoolbar(app.axes3, {'datacursor', 'pan', 'zoomin', 'zoomout', 'restoreview'});

    linkaxes([app.axes1, app.axes2, app.axes3], 'x')
%     ButtonPushed_plotLayout(app)
end