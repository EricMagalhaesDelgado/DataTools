function file_Tree1SelectionChanged(src, event, app)
    
    if numel(app.File_Tree1.SelectedNodes) == 1
        File_Tree1SelectionChanged_Aux(app, 'On')
        
        ind1 = app.File_Tree1.SelectedNodes.NodeData;
        
        app.File_FileType.Value  = app.metaData(ind1).Type;
        app.File_FilesList.Value = strjoin(Misc_RelatedFiles(app, app.metaData(ind1)), '\n');
        
        File_Tree2_Building(app)
    
    else
        File_Tree1SelectionChanged_Aux(app, 'Off')
    end    
end


%-------------------------------------------------------------------------%
function File_Tree1SelectionChanged_Aux(app, Status)
    
    switch Status
        case 'Off'
            app.File_FileType.Value        = '';
            app.File_FilesList.Value       = '';
                                                    
            File_Layout(app, 'Off')
            
            set(app.File_GridA1.Children, 'Enable', 0)
            
            delete(app.File_Tree2.Children)
            app.File_Tree2.Enable = 0;                    
            
        case 'On'
            set(app.File_GridA1.Children, 'Enable', 1)
            app.File_Tree2.Enable = 1;
    end    
end