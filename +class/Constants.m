classdef (Abstract) Constants

    properties (Constant)
        appName         = 'DataTools'
        newAppName      = 'ContainerFrame'
        stationName     = 'EMSat'

        windowSize      = [1244, 660]
        windowMinSize   = [ 640, 580]

        gps2locAPI      = 'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=<Latitude>&longitude=<Longitude>&localityLanguage=pt'
        gps2loc_City    = 'city'
        gps2loc_Unit    = 'principalSubdivisionCode'

        yMinLimRange    = 80                                                % Minimum y-Axis limit range
        yMaxLimRange    = 100                                               % Maximum y-Axis limit range

        channelStep   = 0.025                                               % MHz (Channel Step)

        specDataTypes = [1, 2, 4, 7, 60, 61, 63, 64, 67, 68, 167, 168, 1000, 1809];
        occDataTypes  = [8, 62, 65, 69];

        averageFcn    = 'mean'                                              % 'mean' | 'median' | 'mode'
        mergeDistance = 100                                                 % meters


        % Inserir como constantes os valores relacionados à OCC do
        % offset-noise level (80% method), descartando os valores muito
        % diferentes... 

    end

    methods (Static = true)
        function [upYLim, strUnit] = yAxisUpLimit(Unit)
            switch lower(Unit)
                case 'dbm';                    upYLim = -20; strUnit = 'dBm';
                case {'dbµv', 'dbμv', 'dbuv'}; upYLim =  87; strUnit = 'dBµV';
                case {'dbµv/m', 'dbμv/m'};     upYLim = 100; strUnit = 'dBµV/m';
            end
        end
    end

end