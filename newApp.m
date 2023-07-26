function hApp = newApp(varargin)

    warning('off', 'MATLAB:structOnObject')

    hApp = getappdata(groot, class.Constants.newAppName);
    
    isStartUp = isempty(hApp) || ~isa(hApp, 'handle') || ~isvalid(hApp) || ~struct(hApp.Container).Window.isWindowValid;
    if isStartUp
        hApp = class.ContainerFrame(varargin{:});
    else
        hApp.Container.bringToFront()
    end
end