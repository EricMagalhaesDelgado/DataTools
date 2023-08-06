function MessageBox(app, type, msg)

    appName = class.Constants.appName;

    msg = sprintf('<font style="font-size:12;">%s</font>', msg);
    switch type
        case 'error';   uialert(app.Container, msg, appName, 'Interpreter', 'html');
        case 'warning'; uialert(app.Container, msg, appName, 'Interpreter', 'html', 'Icon', 'warning');
        case 'info';    uialert(app.Container, msg, appName, 'Interpreter', 'html', 'Icon', 'info_24.png')
    end
end