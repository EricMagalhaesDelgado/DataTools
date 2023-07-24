function hApp = dataTools(varargin)

    hApp = getappdata(groot, class.Constants.appName);
    
    isStartUp = isempty(hApp) || ~isa(hApp, 'handle') || ~isvalid(hApp);
    if isStartUp
        hApp = class.DataTools(varargin{:});
    else
        hApp.Container.bringToFront()
    end
end