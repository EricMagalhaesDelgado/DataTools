function Playback_Plot(app)            
    
    app.fig = figure('Name', 'appAnalise: Plot', 'NumberTitle', 'off', ...
                     'Visible', 'off', 'Color', [.98,.98,.98],         ...
                     'GraphicsSmoothing', 'on', 'CloseRequestFcn', @app.Plot_CloseFigure);
    delete(findall(app.fig, '-not', 'Type', 'Figure'));

    tb = uitoolbar(app.fig);            
    app.tb_refreshView =   uipushtool(tb, 'ClickedCallback', @(~,~) plotFcn.toolbar_refreshView(app), 'CData', Fcn_ToolbarIcon(app, 'refreshView'));
    app.tb_interaction =   uipushtool(tb, 'ClickedCallback', @(~,~) plotFcn.toolbar_interaction(app), 'CData', Fcn_ToolbarIcon(app, 'interaction_pan'),                      'Tag', 'pan');
    app.tb_plotclone   =   uipushtool(tb, 'ClickedCallback', @(~,~) plotFcn.toolbar_plotclone(app),   'CData', Fcn_ToolbarIcon(app, 'plotclone'),         'Separator', 'on', 'Tag', 'plotclone');
    app.tb_layout      =   uipushtool(tb, 'ClickedCallback', @(~,~) plotFcn.toolbar_layout(app),      'CData', Fcn_ToolbarIcon(app, 'layout1'),           'Separator', 'on', 'Tag', '1:1');
    app.tb_meanFcn     =   uipushtool(tb, 'ClickedCallback', @(~,~) plotFcn.toolbar_meanFcn(app),     'CData', Fcn_ToolbarIcon(app, 'meanFcn'),                              'Tag', 'meanFcn');
    app.tb_persistance = uitoggletool(tb, 'ClickedCallback', @(~,~) plotFcn.toolbar_persistance(app), 'CData', Fcn_ToolbarIcon(app, 'persistance'),       'Separator', 'on');
    app.tb_minHold     = uitoggletool(tb, 'ClickedCallback', @(~,~) plotFcn.toolbar_minHold(app),     'CData', Fcn_ToolbarIcon(app, 'minHold'));
    app.tb_meanHold    = uitoggletool(tb, 'ClickedCallback', @(~,~) plotFcn.toolbar_meanHold(app),    'CData', Fcn_ToolbarIcon(app, 'meanHold'));
    app.tb_maxHold     = uitoggletool(tb, 'ClickedCallback', @(~,~) plotFcn.toolbar_maxHold(app),     'CData', Fcn_ToolbarIcon(app, 'maxHold'));
    app.tb_occ         = uitoggletool(tb, 'ClickedCallback', @(~,~) plotFcn.toolbar_occ(app),         'CData', Fcn_ToolbarIcon(app, 'occ'),               'Separator', 'on');
    app.tb_waterfall   = uitoggletool(tb, 'ClickedCallback', @(~,~) plotFcn.toolbar_waterfall(app),   'CData', Fcn_ToolbarIcon(app, 'waterfall'),         'Separator', 'on');
    app.tb_loop        =   uipushtool(tb, 'ClickedCallback', @(~,~) plotFcn.toolbar_loop(app),        'CData', Fcn_ToolbarIcon(app, 'playback_straight'), 'Separator', 'on', 'Tag', 'straight');
    app.tb_playback    =   uipushtool(tb, 'ClickedCallback', @(~,~) plotFcn.toolbar_playback(app),    'CData', Fcn_ToolbarIcon(app, 'playback_play'),                        'Tag', 'play');
    
    jFrame = get(app.fig, 'javaframe');
    jFrame.setFigureIcon(javax.swing.ImageIcon(fullfile(app.RootFolder, 'Icons', 'LR_icon.png')));
    jFrame.showTopSeparator(false);

%             jToolbar = get(get(tb, 'JavaContainer'), 'ComponentPeer');
%             jToolbar.setBackground(java.awt.Color(.98,.98,.98));
%             jToolbar.getParent.getParent.setBackground(java.awt.Color(.98,.98,.98));
    
    app.axes1 = axes(app.fig, 'Box', 'on', 'Color', [0,0,0], 'FontName', 'Helvetica',    ...
                              'FontSize', 7, 'FontSmoothing', 'on', 'YDir', 'normal', 'ColorScale', 'log', ...
                              'XColor', [0,0,0], 'XGrid', 'on', 'XMinorGrid', 'on',      ...
                              'YColor', [0,0,0], 'YGrid', 'on', 'YMinorGrid', 'on',      ...
                              'XTickLabel', {}, 'GridAlpha', .25, 'GridColor', [0.94,0.94,0.94], ...
                              'MinorGridAlpha', .2 , 'MinorGridColor', [0.94,0.94,0.94], ...
                              'Unit',  'normalized', 'InnerPosition',  [.08 .1 .85 .82], ...
                              'TitleHorizontalAlignment', 'right', 'Toolbar', []);
    
    app.axes2 = axes(app.fig, 'Box', 'on', 'Color', [0,0,0], 'FontName', 'Helvetica', ...
                              'FontSize', 7, 'FontSmoothing', 'on',                   ...
                              'XColor', [0,0,0], 'XGrid', 'on', 'XMinorGrid', 'on',   ...
                              'YColor', [0,0,0], 'YGrid', 'on', 'YMinorGrid', 'on',   ...
                              'XTickLabel', {}, 'GridAlpha', .25, 'GridColor', [0.94,0.94,0.94],  ...
                              'MinorGridAlpha', .2 , 'MinorGridColor', [0.94,0.94,0.94], ...
                              'Unit', 'normalized', 'InnerPosition', [0 0 0 0], 'Toolbar', []);
    
    app.axes3 = axes(app.fig, 'Box', 'on', 'LineWidth', 1, 'Color', [.94,.94,.94],           ...
                              'FontName', 'Helvetica', 'FontSize', 7, 'FontSmoothing', 'on', ...
                              'XColor', [0,0,0], 'YColor', [0,0,0], 'XTickLabel', {},        ...
                              'Unit', 'normalized', 'InnerPosition', [0 0 0 0], 'Toolbar', []);

    startup_Colormap_axes1(app)
    startup_Colormap_axes3(app)

    set(app.axes1.Title,    'FontSize', 7, 'FontWeight',   'bold', 'Color', [0,0,0], 'FontSmoothing', 'on', 'Interactions', [])
    set(app.axes1.Subtitle, 'FontSize', 7, 'FontWeight', 'normal', 'Color', [0,0,0], 'FontSmoothing', 'on', 'Interactions', [])
    set(app.axes1.XLabel,   'FontSize', 7, 'FontWeight', 'normal', 'Color', [0,0,0], 'FontSmoothing', 'on', 'Interactions', [])
    set(app.axes1.YLabel,   'FontSize', 7, 'FontWeight', 'normal', 'Color', [0,0,0], 'FontSmoothing', 'on', 'Interactions', [])

    set(app.axes2.XLabel,   'FontSize', 7, 'FontWeight', 'normal', 'Color', [0,0,0], 'FontSmoothing', 'on', 'Interactions', [])
    set(app.axes2.YLabel,   'FontSize', 7, 'FontWeight', 'normal', 'Color', [0,0,0], 'FontSmoothing', 'on', 'Interactions', [])
    
    set(app.axes3.XLabel,   'FontSize', 7, 'FontWeight', 'normal', 'Color', [0,0,0], 'FontSmoothing', 'on', 'Interactions', [])
    set(app.axes3.YLabel,   'FontSize', 7, 'FontWeight', 'normal', 'Color', [0,0,0], 'FontSmoothing', 'on', 'Interactions', [])
    
    hold(app.axes1, 'on')
    hold(app.axes2, 'on')
    hold(app.axes3, 'on')
    
    app.axes1.Interactions = [regionZoomInteraction, zoomInteraction, dataTipInteraction];
    app.axes2.Interactions = [regionZoomInteraction, zoomInteraction, dataTipInteraction];
    app.axes3.Interactions = [regionZoomInteraction, zoomInteraction, dataTipInteraction];
    
    enableDefaultInteractivity(app.axes1)
    enableDefaultInteractivity(app.axes2)
    enableDefaultInteractivity(app.axes3)

    % appAnalise only
    addlistener(app.axes1, 'XLim', 'PostSet', @app.Playback_xLimits);
    addlistener(app.axes1, 'YLim', 'PostSet', @app.Playback_yLimits);                
    
    app.cBar1 = colorbar('Location', 'manual', 'Units', 'normalized', 'Position', [0.935, 0.1, 0.01, 0.1], ...
                         'AxisLocation', 'out', 'FontName', 'Helvetica', 'FontSize', 7, 'Color', [0,0,0]);

end


function startup_Colormap_axes1(app)

    colormap(app.axes1, app.play_Persistance_Colormap.Value);
    app.axes1.Colormap(1,:) = [0,0,0];

end


function startup_Colormap_axes3(app)

    colormap(app.axes3, app.play_Waterfall_Colormap.Value);
    app.axes3.Colormap(1,:) = [0,0,0];

end



function Playback_xLimits(app, src, evt)

    app.play_Limits_xLim1.Value = round(app.axes1.XLim(1), 3);
    app.play_Limits_xLim2.Value = round(app.axes1.XLim(2), 3);

end
        

function Playback_yLimits(app, src, evt)

    app.play_Limits_yLim1.Value = round(double(app.axes1.YLim(1)), 1);
    app.play_Limits_yLim2.Value = round(double(app.axes1.YLim(2)), 1);

end


function Plot(app)

    Plot_CloseFigure(app, [], struct('EventName', 'Open'))
    
    t1 = 0;
    while app.timeIndex <= app.specData(app.traceInfo.SelectedNode).Samples
        if ~app.plotFlag
            return
        elseif app.axesFlag
            Plot_Layout1(app)
            Plot_Layout2(app)
            Plot_StartUp1(app)
            Plot_StartUp2(app);
            Plot_StartUp3(app)
        end
        idx = app.traceInfo.SelectedNode;
        
% %             TimeStamp and Slider Update
        tic
        
% %             Axes 1: Spectrum plot ans its markers
        if app.traceInfo.Persistance & app.play_Persistance_Samples.Value ~= "full"
            Plot_Persistance_Update(app, idx)
        end

        app.line_ClearWrite.YData = app.specData(idx).Data{2}(:, app.timeIndex)';
        
        for ii = 1:numel(app.mkr_Label)
            app.mkr_Label(ii).Position(2) = app.line_ClearWrite.YData(app.line_ClearWrite.MarkerIndices(ii));
        end
        
% %             Axes2: OCC Plot
        if ismember(app.traceInfo.plotLayout, [1,3])
            switch app.Playback_occType.Value
                case 'Linear'
                    app.axes2.Children(1).YData = ((app.Playback_occTime.Value-1)*app.axes2.Children(1).YData ...
                                                   +100*single(app.line_ClearWrite.YData > app.Playback_occValue.Value))/app.Playback_occTime.Value;
                case 'Piso de ruído (Offset)'
                    app.axes2.Children(1).YData = ((app.Playback_occTime.Value-1)*app.axes2.Children(1).YData ...
                                                   +100*single(app.line_ClearWrite.YData > app.occTHR))/app.Playback_occTime.Value;
            end
            app.axes2.Children(2).YData = max(app.axes2.Children(1).YData, app.axes2.Children(2).YData);
        end

% %             Axes3: WaterFall Plot
        if ismember(app.traceInfo.plotLayout, [2, 3])
            timestampValue = repmat(app.specData(idx).Data{1}(app.timeIndex), 1, 2);
            app.line_wfTime.YData = timestampValue;
        end
        drawnow

% %             Miscelâneas                
        app.Playback_Slider.Value = 100 * app.timeIndex/app.specData(idx).Samples;
        Misc_DriveTestUpdate(app)
        
% %             Pause
        pause(app.play_MinPlotTime.Value/1000 - toc)
        t1 = (9*t1+toc)/10;                
        app.axes1.Title.String{4} = sprintf('%s (%d de %d). Tempo de escrita: %.0f ms.', ...
                                    datestr(app.specData(idx).Data{1}(app.timeIndex), 'dd/mm/yyyy HH:MM:SS'), ...
                                    app.timeIndex, app.specData(idx).Samples, 1000*t1);
        
% %             Reload Flag
        if app.timeIndex == app.specData(idx).Samples
            if app.tb_loop.Tag == "loop"; app.timeIndex = 1;
            else;                         break
            end
        else
            app.timeIndex = app.timeIndex+1;
        end                
    end
    
    plotFcn.toolbar_playback(app)
    
end


function Plot_Layout1(app)
    
    cla(app.axes1)
    cla(app.axes2)
    cla(app.axes3)
    
    app.timeIndex             = 1;
    app.Playback_Slider.Value = 0;
    
    app.line_ClearWrite = [];
    app.line_OCC        = [];
    app.line_OCCLabel   = [];
    app.mkr_ROI         = [];
    app.mkr_Label       = [];
    app.line_wfTime     = [];
    
% %         Desabilita WaterFall e OCC caso fluxo de dados tenha até duas amostras.    
    if app.specData(app.traceInfo.SelectedNode).Samples > 2
        if ~app.occFlag
            app.tb_occ.Visible = 1;
        end
        app.tb_waterfall.Visible = 1;

    else
        set(app.tb_occ, 'Visible', 0, 'State', 0)
        plotFcn.toolbar_occ(app)

        set(app.tb_waterfall, 'Visible', 0, 'State', 0)
        plotFcn.toolbar_waterfall(app)
    end
    
end
    

function Plot_Layout2(app)
    
% %         Layout
    linkaxes([app.axes1, app.axes2, app.axes3], 'off')
                
    switch app.traceInfo.plotLayout
        case 0
            app.axes1.InnerPosition = [.08 .08 .85 .8];
            app.axes2.InnerPosition = [0 0 0 0];
            app.axes3.InnerPosition = [0 0 0 0];
            app.cBar1.Position      = [0 0 0 0];
            
            app.axes1.XTickLabelMode = 'auto';

            xlabel(app.axes1, 'Frequência (MHz)')
            
        case 1
            app.axes1.InnerPosition = [.08 .48 .85 .4];
            app.axes2.InnerPosition = [.08 .08 .85 .38];
            app.axes3.InnerPosition = [0 0 0 0];
            app.cBar1.Position      = [0 0 0 0];
            
            app.axes1.XTickLabel     = {};
            app.axes2.XTickLabelMode = 'auto';
            
            xlabel(app.axes1, '')
            xlabel(app.axes2, 'Frequência (MHz)')
            
            linkaxes([app.axes1, app.axes2], 'x')

        case 2
            if app.tb_layout.Tag == "1:1"
                app.axes1.InnerPosition = [.08 .48 .85 .4];
                app.axes2.InnerPosition = [0 0 0 0];
                app.axes3.InnerPosition = [.08 .08 .85 .38];
            else
                app.axes1.InnerPosition = [.08 .72 .85 .16];
                app.axes2.InnerPosition = [0 0 0 0];
                app.axes3.InnerPosition = [.08 .08 .85 .62];
            end
            app.cBar1.Position      = [.9405 .08 .0145 .10];
            
            app.axes1.XTickLabel = {};
            app.axes3.XTickLabelMode = 'auto';
            
            xlabel(app.axes1, '')
            xlabel(app.axes2, '')
            xlabel(app.axes3, 'Frequência (MHz)')
            
            linkaxes([app.axes1, app.axes3], 'x')

        case 3
            if app.tb_layout.Tag == "1:1"
                app.axes1.InnerPosition = [.08 .58 .85 .30];
                app.axes2.InnerPosition = [.08 .40 .85 .16];
                app.axes3.InnerPosition = [.08 .08 .85 .30];
            else
                app.axes1.InnerPosition = [.08 .72 .85 .16];
                app.axes2.InnerPosition = [.08 .54 .85 .16];
                app.axes3.InnerPosition = [.08 .08 .85 .44];
            end
            app.cBar1.Position      = [.9405 .08  .0145 .10];
            
            app.axes1.XTickLabel = {};
            app.axes2.XTickLabel = {};
            app.axes3.XTickLabelMode = 'auto';
            
            xlabel(app.axes1, '')
            xlabel(app.axes2, '')
            xlabel(app.axes3, 'Frequência (MHz)')
            
            linkaxes([app.axes1, app.axes2, app.axes3], 'x')
    end
    
end


function Plot_StartUp1(app)
    
    ind1 = app.traceInfo.SelectedNode;
    
% %         Axes1 (Spectrum plot): Figure UserData, title and subtitle.
    app.fig.UserData = app.mainInfo_Tree.SelectedNodes;

    metaString = app.specData(ind1).MetaData.metaString([3,4,2]);
    idx1       = cellfun(@(x) ~isempty(x), metaString);
    metaString = strjoin(metaString(idx1), ', ');

    app.axes1.Title.String = sprintf(['\\fontsize{8}\\bf%s\n'                               ...
                                      '\\fontsize{7}\\rm%.3f - %.3f MHz, %s, %.0f pontos\n' ...
                                      'GPS: %.6f, %.6f (%s)'],                      ...
                                      app.specData(ind1).Node,                      ...
                                      app.specData(ind1).MetaData.FreqStart / 1e+6, ...
                                      app.specData(ind1).MetaData.FreqStop  / 1e+6, ...
                                      metaString,                             ...
                                      app.specData(ind1).MetaData.DataPoints, ...
                                      app.specData(ind1).gps.Latitude,        ...
                                      app.specData(ind1).gps.Longitude,       ...
                                      app.specData(ind1).gps.Location);
    
    app.axes1.Title.String{4} = sprintf('%s (%d de %d)',                                               ...
                                        datestr(app.specData(ind1).Data{1}(1), 'dd/mm/yyyy HH:MM:SS'), ...
                                        app.timeIndex, app.specData(ind1).Samples);
    
    if ~ismember(app.specData(ind1).MetaData.DataType, class.Constants.occDataTypes)
        app.Unit = app.specData(ind1).MetaData.metaString{1};
        yLabel   = sprintf('Nível (%s)', app.Unit);
        app.play_FindPeaks_THRLabel.Text{2} = sprintf('(%s):', app.Unit);
    else
        yLabel   = 'Ocupação (%)';
        app.Unit = '%';
    end
    
    set(app.axes1, XLim=app.RestoreView{1}, YLim=app.RestoreView{2})
    ylabel(app.axes1, yLabel);
    
% %          Axes 2 (OCC plot)
    if app.tb_occ.State
        Plot_StartUp1_OCC(app)
    end
    
% %          Axes 3 (WaterFall plot)
    if app.tb_waterfall.State
        set(app.axes3, XLim=app.axes1.XLim)
        ylabel(app.axes3, 'Amostras');
    end
    
end


function Plot_StartUp1_OCC(app)

    set(app.axes2, XLim=app.axes1.XLim, YLim=[0, 100]);
    ylabel(app.axes2, 'Ocupação (%)');

end


function Plot_StartUp2(app)
    
    ind1 = app.traceInfo.SelectedNode;
    
    app.x = round(linspace(app.specData(ind1).MetaData.FreqStart ./ 1e+6, ...
                           app.specData(ind1).MetaData.FreqStop  ./ 1e+6, ...
                           app.specData(ind1).MetaData.DataPoints), 3);
    
    app.Span  = (app.specData(ind1).MetaData.FreqStop - app.specData(ind1).MetaData.FreqStart);
    app.aCoef = app.Span ./ (app.specData(ind1).MetaData.DataPoints - 1);
    app.bCoef = app.specData(ind1).MetaData.FreqStart - app.aCoef;

    if app.tb_persistance.State                                 % Persistance
        Plot_StartUp2_Persistance(app)
    end
    
    Plot_StartUp2_Spectrum(app, 'InitialPlot', ind1, 1)         % Main trace (ClearWrite) and its markers
    Plot_StartUp2_TraceMode(app, ind1)                          % Optional traces (MinHold, Median/Mean, MaxHold)

    if app.tb_occ.State                                         % OCC
        Plot_StartUp2_OCC(app, ind1)
    end
    
    if app.tb_waterfall.State
        Plot_StartUp2_WaterFall(app)                            % WaterFall
    end
    drawnow nocallbacks
    app.axesFlag = 0;
    
end


function Plot_StartUp2_Spectrum(app, Type, ind1, selectedEmission)
    
    % Startup
    switch Type
        case 'InitialPlot'
            app.line_ClearWrite = plot(app.axes1, app.x, app.specData(ind1).Data{2}(:, app.timeIndex), Tag='ClearWrite',                   ...
                                       Color=app.General.Colors(4,:), Marker='.', MarkerIndices=[], MarkerFaceColor=[0.40,0.73,0.88], ...
                                       MarkerEdgeColor=[0.40,0.73,0.88], MarkerSize=14, Visible=app.play_ClearWriteVisibility.Value);

        case 'TreeSelectionChanged'
            ind2 = app.play_FindPeaks_Tree.SelectedNodes.NodeData;
            app.mkr_ROI.Position(:, [1, 3]) = [app.specData(ind1).Emissions.Frequency(ind2)-app.specData(ind1).Emissions.BW(ind2)/(2*1000), ...
                                                app.specData(ind1).Emissions.BW(ind2)/1000];
        
        case {'AddButtonPushed', 'PeakValueChanged'}
            delete(findobj('Tag', 'mkrTemp', '-or', 'Tag', 'mkrLine', '-or', 'Tag', 'mkrLabels'))

        case 'DeleteButtonPushed'
            delete(findobj('Tag', 'mkrTemp', '-or', 'Tag', 'mkrLine', '-or', 'Tag', 'mkrLabels', '-or', 'Tag', 'mkrROI'))
            
            app.mkr_ROI       = [];
            app.mkr_Label = [];
    end

    % Processing...
    switch Type
        case {'InitialPlot', 'AddButtonPushed', 'PeakValueChanged', 'DeleteButtonPushed'}
            Playback_TreeBuilding(app, selectedEmission)

            if isempty(app.specData(ind1).Emissions)
                app.line_ClearWrite.MarkerIndices = [];

            else
                app.line_ClearWrite.MarkerIndices = app.specData(ind1).Emissions.Index;

                mkrLabels = {};
                for ii = 1:height(app.specData(ind1).Emissions)
                    mkrLabels = [mkrLabels {['  ' num2str(ii)]}];

                    FreqStart = app.specData(ind1).Emissions.Frequency(ii)-app.specData(ind1).Emissions.BW(ii)/(2*1000);
                    FreqStop  = app.specData(ind1).Emissions.Frequency(ii)+app.specData(ind1).Emissions.BW(ii)/(2*1000);
                    BW        = app.specData(ind1).Emissions.BW(ii)/1000;
                    Level     = app.RestoreView{2}(1)+1;
                    
                    % Cria uma linha por emissão, posicionando-o na parte inferior
                    % do plot.
                    line(app.axes1, [FreqStart, FreqStop], [Level, Level], ...
                                    Color=[0.40,0.73,0.88], LineWidth=1, ...
                                    Marker='.',             MarkerSize=14, ...
                                    PickableParts='none',   Tag='mkrLine')
    
                    % Cria um ROI para a emissão selecionada, posicionando-o em
                    % todo o plot.
                    if ii == selectedEmission
                        newPosition = [FreqStart, app.RestoreView{2}(1)+1, ...
                                       BW,        app.RestoreView{2}(2)-app.RestoreView{2}(1)-2];
                        
                        if isempty(app.mkr_ROI)
                            Plot_StartUp2_ROI(app, newPosition)
                        else
                            app.mkr_ROI.Position = newPosition;
                        end
                    end
                end
                uistack(app.line_ClearWrite, 'top');

                app.mkr_Label = text(app.axes1, app.specData(ind1).Emissions.Frequency, double(app.specData(ind1).Data{2}(app.specData(ind1).Emissions.Index, app.timeIndex)), mkrLabels, ...
                                                     Color=[0.40,0.73,0.88], FontSize=7, FontWeight='bold', FontName='Helvetica', FontSmoothing='on', Tag='mkrLabels');
            end
    end

end


function Plot_StartUp2_ROI(app, newPosition)

    app.mkr_ROI = images.roi.Rectangle(app.axes1, Position=newPosition, ...
                                                   Color=[0.40,0.73,0.88], ...
                                                   MarkerSize=5,           ...
                                                   Deletable=0,            ...
                                                   LineWidth=1,            ...
                                                   Tag='mkrROI');

    addlistener(app.mkr_ROI, 'MovingROI', @app.mkrLineROI);
    addlistener(app.mkr_ROI, 'ROIMoved',  @app.mkrLineROI);

end


function Plot_StartUp2_TraceMode(app, ind1)
    
    auxIndex1 = find(app.traceInfo.Mode ~= 0);
    if ~isempty(auxIndex1)
            for ii = auxIndex1                        
                switch ii
                    case 1; auxStr = 'MinHold';
                    case 2
                        switch app.traceInfo.Mode(2)
                            case 2; auxStr = 'medianFcn';
                            case 3; auxStr = 'meanFcn';
                        end
                    case 3; auxStr = 'MaxHold';
                end
                plot(app.axes1, app.x, app.specData(ind1).statsData(:, app.traceInfo.Mode(ii)), ...
                     'Tag', auxStr, 'Color', app.General.Colors(ii,:));
            end
    end
    
end


function Plot_StartUp2_Persistance(app)

    % SELECTED DATA
    ind = app.traceInfo.SelectedNode;
    
    FreqStart  = app.specData(ind).MetaData.FreqStart / 1e+6;
    FreqStop   = app.specData(ind).MetaData.FreqStop  / 1e+6;
    DataPoints = app.specData(ind).MetaData.DataPoints;


    % IMAGE
    % (a) RESOLUTION (801x201 pixels)
    yResolution   = 201;
    xResolution   = 801;
    if DataPoints < xResolution; xResolution = DataPoints;
    end

    % (b) INTERPOLATION, LEVEL AMPLITUDE AND ALPHADATA
    Interpolation = app.play_Persistance_Interpolation.Value;
    yAmplitude    = 100;

    % (c) WINDOW SIZE (PLAYBACK)
    ySamples = str2double(app.play_Persistance_Samples.Value);
    if isnan(ySamples); ySamples = app.specData(ind).Samples;
    end


    % PROCESSING...
    yMin = min(app.specData(ind).Data{2}, [], 'all');
    yMax = yMin+yAmplitude;
    
    xEdges = linspace(FreqStart, FreqStop, xResolution+1);
    yEdges = linspace(yMin, yMax, yResolution+1);            
    
    specHist = zeros(yResolution, xResolution);
    hImg = image(app.axes1, specHist, 'alphadata', im2double(specHist),'XData', [FreqStart, FreqStop], 'YData', [yMin, yMax], 'Tag', 'Persistance');
    set(hImg, CDataMapping = "scaled", Interpolation = Interpolation, AlphaData = im2double(specHist))
    
    app.obj_Persistance = struct('handle',   hImg,     ...
                                 'ySamples', ySamples, ...
                                 'xEdges',   xEdges,   ...
                                 'yEdges',   yEdges);
    
    Plot_Persistance_Update(app, ind)

    app.play_Persistance_cLim1.Value = app.axes1.CLim(1);
    app.play_Persistance_cLim2.Value = app.axes1.CLim(2);

    uistack(hImg, 'bottom')

end


function Plot_Persistance_Update(app, ind)

    if app.play_Persistance_Samples.Value == "full"
        specHist = histcounts2(app.specData(ind).Data{2}, repmat(app.x', 1, app.specData(ind).Samples), ...
                               app.obj_Persistance.yEdges, ...
                               app.obj_Persistance.xEdges);

    else
        idx2 = app.timeIndex;
        idx1 = idx2 - (app.obj_Persistance.ySamples-1);
        if idx1 < 1; idx1 = 1;
        end            
        
        specHist = histcounts2(app.specData(ind).Data{2}(:, idx1:idx2), repmat(app.x', 1, idx2-idx1+1), ...
                               app.obj_Persistance.yEdges, ...
                               app.obj_Persistance.xEdges);
    end

    set(app.obj_Persistance.handle, 'CData', (100 * specHist ./ sum(specHist)), ...
                                    'AlphaData', double(logical(specHist))*app.play_Persistance_Transparency.Value)
    
    drawnow

end


function Plot_StartUp2_OCC(app, ind1)
    
    occObj = findobj('Tag', 'occROI');

    if isempty(occObj)
        if strcmp(app.specData(ind1).MetaData.metaString{1}, 'dBm') && (app.Playback_occValue.Value > 0)
            app.Playback_occValueLabel.Text{2} = '(dBm):';
            app.Playback_occValue.Value        = -80;

        elseif strcmp(app.specData(ind1).MetaData.metaString{1}, 'dBµV') && (app.Playback_occValue.Value < 0)
            app.Playback_occValueLabel.Text{2} = '(dBµV):';
            app.Playback_occValue.Value        = 27;
            
        elseif strcmp(app.specData(ind1).MetaData.metaString{1}, 'dBµV/m') && (app.Playback_occValue.Value < 0)
            app.Playback_occValueLabel.Text{2} = '(dBµV/m):';
            app.Playback_occValue.Value        = 40;
        end
        
        if app.Playback_occValue.Value > app.axes1.YLim(2)
            app.Playback_occValue.Value = double(app.axes1.YLim(2));
        end
        
        switch app.Playback_occType.Value
            case 'Linear'
                app.occTHR   = app.Playback_occValue.Value;
                app.line_OCC = images.roi.Line(app.axes1,'Position',[app.x(1) app.Playback_occValue.Value; app.x(end) app.Playback_occValue.Value], 'Color', 'red', 'MarkerSize', 4, 'Deletable', 0, 'LineWidth', 1, 'InteractionsAllowed', 'translate', 'Tag', 'occROI');
                
                addlistener(app.line_OCC, 'MovingROI', @app.occLineROI);
                addlistener(app.line_OCC, 'ROIMoved',  @app.occLineROI);
                
            case 'Piso de ruído (Offset)'
                occInfo = struct('Offset',   app.Playback_occOffset.Value,                              ...
                                 'Fcn',      app.Playback_occFcn.Value,                                 ...
                                 'Samples', [app.Playback_tSamples.Value, app.Playback_uSamples.Value], ...
                                 'Factor',   app.Playback_occConfLevel.Value);

                app.occTHR   = Misc_occThreshold('Piso de ruído (Offset)', app.specData(ind1), occInfo);
                app.line_OCC = plot(app.axes1, app.x, app.occTHR, 'Color', 'red', 'LineStyle', '-', 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 4, 'MarkerIndices', [1, app.specData(ind1).MetaData.DataPoints], 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'black', 'Tag', 'occROI');
        end
        app.line_OCCLabel = text(app.axes1, app.x(end), double(app.occTHR(end)), '  THR', 'FontName', 'Helvetica', 'FontSize', 7, 'Color', 'red', 'Tag', 'occROI');
        
        plot(app.axes2, app.x, zeros(1, numel(app.line_ClearWrite.YData), 'single'), 'Tag', 'maxOCC',  'Color', app.General.Colors(3,:));   % MaxHold
        plot(app.axes2, app.x, zeros(1, numel(app.line_ClearWrite.YData), 'single'), 'Tag', 'meanOCC', 'Color', app.General.Colors(2,:));   % Média
    
    else
        if isa(occObj(end), 'images.roi.Line')
            app.line_OCC.Position(:,2)    = [app.Playback_occValue.Value; app.Playback_occValue.Value];
            app.line_OCCLabel.Position(2) = app.Playback_occValue.Value;

        else
            occInfo = struct('Offset',   app.Playback_occOffset.Value,                              ...
                             'Fcn',      app.Playback_occFcn.Value,                                 ...
                             'Samples', [app.Playback_tSamples.Value, app.Playback_uSamples.Value], ...
                             'Factor',   app.Playback_occConfLevel.Value);

            app.occTHR                    = Misc_occThreshold('Piso de ruído (Offset)', app.specData(ind1), occInfo);                    
            app.line_OCC.YData            = app.occTHR;
            app.line_OCCLabel.Position(2) = double(app.occTHR(end));
        end
        
        set(app.axes2.Children, 'YData', zeros(1, numel(app.line_ClearWrite.YData), 'single'));
    end
    
end    
        

function Plot_StartUp2_WaterFall(app)

    ind1 = app.traceInfo.SelectedNode;
    
    if isempty(findobj('Tag', 'wfSurface'))
        if strcmp(app.play_Waterfall_Decimation.Value, 'auto')
            auxSize = app.specData(ind1).MetaData.DataPoints .* app.specData(ind1).Samples;
            if auxSize > 1474560; Decimate = ceil(auxSize/1474560);
            else;                 Decimate = 1;
            end
        else
            Decimate = str2double(app.play_Waterfall_Decimation.Value);
        end

        while true
            t = app.specData(ind1).Data{1}(1:Decimate:end);
            if numel(t) > 1; break
            else;            Decimate = round(Decimate/2);
            end
        end

        if ~strcmp(app.play_Waterfall_Decimation.Value, 'auto')
            app.play_Waterfall_Decimation.Value = num2str(Decimate);
        end

        if t(1) == t(end)
            t(end) = t(1)+seconds(1);
        end
        app.RestoreView{3} = [t(1), t(end)];
        
        [X, Y] = meshgrid(app.x, t);

        app.axes3.CLimMode = 'auto';
        mesh(app.axes3, X, Y, app.specData(ind1).Data{2}(:,1:Decimate:end)', 'MeshStyle', app.play_Waterfall_Interpolation.Value, 'SelectionHighlight', 'off', 'Tag', 'wfSurface')
        view(app.axes3, 0, 90);
        
        if strcmp(app.play_Waterfall_Timestamp.Value, 'on')
            app.line_wfTime = line(app.axes3, [app.x(1), app.x(end)], [app.specData(ind1).Data{1}(app.timeIndex), app.specData(ind1).Data{1}(app.timeIndex)], [app.axes1.YLim(2) app.axes1.YLim(2)], ...
                                              'Color', 'red', 'LineWidth', 1, 'PickableParts', 'none', 'Tag', 'wfTimeStamp');
        end
        
        tTickLabel    = linspace(t(1), t(end), 3);
        [~, tIndex]   = min(abs(app.specData(ind1).Data{1} - tTickLabel(2)));
        tTickLabel(2) =  app.specData(ind1).Data{1}(tIndex);

        set(app.axes3, 'YLim' , [t(1), t(end)], 'YTick', tTickLabel, 'YTickLabel', [1, round(tIndex), app.specData(ind1).Samples])

        hText = findobj('Tag', 'DecimateLabel');
        if isempty(hText)
            text(app.axes3, 1.01, .98, 0, sprintf('FD: %.0f', Decimate), 'Units', 'normalized', 'FontName', 'Helvetica', 'FontSize', 7, 'Tag', 'DecimateLabel')
        else
            hText.String = sprintf('FD: %.0f', Decimate);
        end

        % Colors limits
        app.axes3.CLim(2)  = round(app.axes3.CLim(2));
        app.axes3.CLim(1)  = round(app.axes3.CLim(2) - diff(app.axes3.CLim)/2);

        app.RestoreView{4} = app.axes3.CLim;

        app.play_Waterfall_cLim1.Value = app.axes3.CLim(1);
        app.play_Waterfall_cLim2.Value = app.axes3.CLim(2);

        Li = app.axes3.CLim(1);
        Ls = app.axes3.CLim(2);
        
        set(app.cBar1, Limits=[Li, Ls], Ticks=[Li, Ls], TickLabels={num2str(Li), num2str(Ls)})
    end
    
end


function Plot_StartUp3(app)
    
    ind1 = app.traceInfo.SelectedNode;

    % axes1
    for ii = 1:numel(app.axes1.Children)
        if strcmpi(app.axes1.Children(ii).Type, 'line')
            if ~strcmp(app.axes1.Children(ii).Tag, 'mkrLine')
                Misc_DataTipSettings(app.axes1.Children(ii), app.specData(ind1).MetaData.metaString{1})
            end
        end
    end
    
    % axes2
    for ii = 1:numel(app.axes2.Children)
        if strcmpi(app.axes2.Children(ii).Type, 'line')
            Misc_DataTipSettings(app.axes2.Children(ii), '%%')
        end
    end
    
    % axes3
    for ii = 1:numel(app.axes3.Children)
        if strcmpi(app.axes3.Children(ii).Type, 'surface')
            Misc_DataTipSettings(app.axes3.Children(ii), app.specData(ind1).MetaData.metaString{1})
        end
    end
    
end