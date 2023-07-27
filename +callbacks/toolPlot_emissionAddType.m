function toolPlot_emissionAddType(src, event, app)

    if src.Selected % "Manual ROI"
        app.toolPlot_emissionNPeaks.Enabled     = false;
        app.toolPlot_emissionProminence.Enabled = false;
        app.toolPlot_emissionSeparation.Enabled = false;
        app.toolPlot_emissionWidth.Enabled      = false;
    else % "Automatic findpeaks"
        app.toolPlot_emissionNPeaks.Enabled     = true;
        app.toolPlot_emissionProminence.Enabled = true;
        app.toolPlot_emissionSeparation.Enabled = true;
        app.toolPlot_emissionWidth.Enabled      = true;
    end
end