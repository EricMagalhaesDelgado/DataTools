function app = Read(app, ind)
    
    [~, name, ext] = fileparts(app.metaData(ind).File);
    
    switch lower(ext)
        case '.bin'
            fileID = fopen(app.metaData(ind).File);
            Format = fread(fileID, [1 36], '*char');
            fclose(fileID);

            if contains(Format, 'CRFS', "IgnoreCase", true)
                app.metaData(ind).Data = fileReader.CRFSBin(app.metaData(ind).File, 'MetaData', []);
            elseif contains(Format, 'RFlookBin v.1/1', "IgnoreCase", true)
                app.metaData(ind).Data = fileReader.RFLookBin(app.metaData(ind).File, 'MetaData');
            elseif contains(Format, 'RFlookBin v.2/1', "IgnoreCase", true)
                app.metaData(ind).Data = fileReader.RFlookBinV2(app.metaData(ind).File, 'MetaData');
            else
                error('O arquivo indicado a seguir parece não ser de um dos formatos binários cuja leitura foi implantada no appAnalise.\n• %s', [name ext])
            end
        
        case '.dbm'
            app.metaData(ind).Data = fileReader.CellPlanDBM(app.metaData(ind).File, 'MetaData', [], app.RootFolder);

        case '.sm1809'
            app.metaData(ind).Data = fileReader.SM1809(app.metaData(ind).File, 'MetaData', []);
            
        case '.csv'
            app.metaData(ind).Data = fileReader.ArgusCSV(app.metaData(ind).File, 'SingleFile', []);

        case '.mat'
            load(app.metaData(ind).File, '-mat', 'prj_metaData')
            app.metaData(ind).Data = prj_metaData;                
    end
    
    if isempty([app.metaData(ind).Data.Samples])
        error('O arquivo indicado a seguir não possui informação espectral.\n• %s', [name ext])
    end
    
    app.metaData(ind).Samples = [app.metaData(ind).Data.Samples]';
    app.metaData(ind).Memory  = File_GeneralReader_EstimatedMemory(app, ind);    
end


%-------------------------------------------------------------------------%
function EstimatedMemory = File_GeneralReader_EstimatedMemory(app, ii)
    EstimatedMemory = 0;
    for jj = 1:numel(app.metaData(ii).Data)
        EstimatedMemory = EstimatedMemory + 4 * app.metaData(ii).Data(jj).Samples .* app.metaData(ii).Data(jj).MetaData.DataPoints .* 1e-6;
    end    
end