function hApp = dataTools(varargin)

    warning('off', 'MATLAB:structOnObject')

    hApp = getappdata(groot, class.Constants.appName);
    
    isStartUp = isempty(hApp) || ~isa(hApp, 'handle') || ~isvalid(hApp) || ~struct(hApp.Container).Window.isWindowValid;
    if isStartUp
        hApp = class.DataTools(varargin{:});
    else
        hApp.Container.bringToFront()
    end
end