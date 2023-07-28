function toolHome_OpenFile(src, event, app)

    [fileName, filePath, fileFormat] = uigetfile({'*.bin',    'appColeta/Logger (*.bin)';      ...
                                                  '*.dbm',    'CellPlan (*.dbm)';              ...
                                                  '*.sm1809', 'SM1809 (*.sm1809)';             ...
                                                  '*.csv',    'Argus (*.csv)';                 ...
                                                  '*.mat',    'appAnalise/appColeta (*.mat)'}, ...
                                                  'MultiSelect', 'on');
    app.Container.bringToFront()
    
    if ~fileFormat
        return
    end

    app.hStatusBar.Text = 'In progress...';
    
    if ~iscell(fileName)
        fileName = {fileName};
    end
    
    RepeteadFiles = {};
    for ii = 1:numel(fileName)
        app.hStatusBar.Text = sprintf('In progress the metadata reading of the file "%s" (%d of %d)', fileName{ii}, ii, numel(fileName));
        
        RelatedFiles = {};
        for jj = 1:numel(app.metaData)
            RelatedFiles = [RelatedFiles; auxFcn_RelatedFiles(app.metaData(jj))];
        end
           
        switch fileFormat
            case {1, 2, 3, 4}
                if ~any(contains(RelatedFiles, fileName(ii)))
                    ind = numel(app.metaData)+1;
                    
                    app.metaData(ind).File = fullfile(filePath, fileName{ii});
                    app.metaData(ind).Type = {'Spectral data'};
                else
                    RepeteadFiles(end+1) = fileName(ii);
                    continue
                end
                
            case 5
                lastwarn('')
                load(fullfile(filePath, fileName{ii}), '-mat', 'prj_Type', 'prj_RelatedFiles')
                [~, warnID] = lastwarn;
                
                % Validações...
                if strcmp(warnID, 'MATLAB:load:variableNotFound')
                    msg = sprintf('O arquivo indicado a seguir não possui a variável "prj_Type", não sendo, portanto, um arquivo gerado pelo appAnálise ou appColeta.\n• %s', fileName{ii});
                    MessageBox(app, 'warning', msg)
                    
                    continue
                    
                elseif ~isempty(strfind([app.metaData.File], fileName{ii}))
                    msg = sprintf('O arquivo indicado a seguir já tinha sido lido.\n• %s', fileName{ii});
                    MessageBox(app, 'warning', msg)
                    
                    continue
                    
                elseif any(contains(RelatedFiles, prj_RelatedFiles))
                    msg = sprintf(['O arquivo indicado a seguir não será lido por já ter sido lido ao menos um arquivo relacionado ao ' ...
                                   'projeto appAnálise.\n• %s\n\nArquivo(s) relacionado(s) ao projeto appAnálise já lido(s):\n%s'],   ...
                                   fileName{ii}, strjoin(cellfun(@(x) sprintf('• %s', x), RelatedFiles(contains(RelatedFiles, prj_RelatedFiles)), 'UniformOutput', false), '\n'));
                    MessageBox(app, 'warning', msg)
                    
                    continue
    
                elseif ~isempty(app.metaData) && strcmp(prj_Type{1}, 'Project data') && ismember({'Project data'}, [app.metaData.Type])
                    msg = sprintf('O arquivo indicado a seguir não será lido porque já foram lidos os metadados de outro projeto appAnálise.\n• %s', fileName{ii});
                    MessageBox(app, 'warning', msg)
                    
                    continue
                    
                else
                    ind = numel(app.metaData)+1;
                    
                    app.metaData(ind).File = fullfile(filePath, fileName{ii});
                    app.metaData(ind).Type = prj_Type;
                end
        end
        
        try
            fileReader.Read(app, ind);
    
        catch ME
            fprintf('%s\n', jsonencode(ME))
            MessageBox(app, 'error', getReport(ME))
            
            if contains(ME.message, 'O arquivo indicado a seguir')
                if ind == 1; app.metaData = struct('File', {}, 'Type', {}, 'Data', {}, 'Samples', {}, 'Memory', {});
                else;        app.metaData(ind) = [];
                end
                
                ErrorFlag = 0;
            else
                app.metaData = struct('File', {}, 'Type', {}, 'Data', {}, 'Samples', {}, 'Memory', {});
                app.Samples  = [];
                
                ErrorFlag = 1;
            end
            fclose all;
    
            if ErrorFlag
                break
            end
        end
    end
        
    fileReader.Tree1Building(app)
end


%-------------------------------------------------------------------------%
    function FilesList = auxFcn_RelatedFiles(specData)
    FilesList = {};
    for ii = 1:numel(specData.Data)
        FilesList = [FilesList; specData.Data(ii).RelatedFiles.Name];
    end
    FilesList = unique(FilesList);
end