function hApp = newApp(varargin)

    hApp = getappdata(groot, class.Constants.newAppName);
    
    isStartUp = isempty(hApp) || ~isa(hApp, 'handle') || ~isvalid(hApp) || ~hApp.hWebWindow.isWindowValid;
    if isStartUp
        hApp = class.ContainerFrame(varargin{:});
    else
        hApp.Container.bringToFront()
    end
end