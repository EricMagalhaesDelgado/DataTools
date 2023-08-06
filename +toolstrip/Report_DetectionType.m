function Report_DetectionType(src, event, app)

    if src.Selected % "Manual ROI"
        app.Report_emissionNPeaks.Enabled     = false;
        app.Report_emissionProminence.Enabled = false;
        app.Report_emissionSeparation.Enabled = false;
        app.Report_emissionWidth.Enabled      = false;
    else % "Automatic findpeaks"
        app.Report_emissionNPeaks.Enabled     = true;
        app.Report_emissionProminence.Enabled = true;
        app.Report_emissionSeparation.Enabled = true;
        app.Report_emissionWidth.Enabled      = true;
    end
end