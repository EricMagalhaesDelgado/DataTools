function File_SpectralData(src, event, app)

    d = uiprogressdlg(app.Container, 'Indeterminate', 'on', 'Interpreter', 'html');
    Playback_Startup(app)
    
    try
        Read_specData(app, d);
    catch ME
        app.specData = [];
        MessageBox(app, 'error', getReport(ME))
    end

    panel.SpectralData_TreeBuilding(app)
    delete(d)
end