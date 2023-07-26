


            % TAB1
%             hTab1     = Tab('HOME'); hTab1.Tag = 'HomeTab';
%             hSection1 = hTab1.addSection('FILE');
%             hColumn1  = hSection1.addColumn();
%             hBtn1     = Button('Open', Icon.OPEN_24);
%             hColumn1.add(hBtn1)
%             this.Container.addTabGroup(hTab1)

%             hColumn12 = hSection1.addColumn();
%             hColumn13 = hSection1.addColumn();
% 
            
            

            

%             btn111.ButtonPushedFcn = {@callbacks.openButtonPushed, this};
% 
%             btn121  = ToggleButton('New', Icon.NEW_24);
%             % btn131  = ToggleButton('Active star', Icon('activeStar')); % CSS ICON
%             btn131  = ToggleButton('Active star', Icon('anatelDB_24.png'));
% 
%             
% %             hCheckBox1 = matlab.ui.internal.toolstrip.CheckBox('CheckBox1', true);
% %             hCheckBox1.ValueChangedFcn = {@callbacks.CheckBoxStateChanged, this};
% %             hCheckBox2 = matlab.ui.internal.toolstrip.CheckBox('CheckBox2', true);
% %             hCheckBox2.ValueChangedFcn = {@callbacks.CheckBoxStateChanged, this};
% %             hCheckBox3 = matlab.ui.internal.toolstrip.CheckBox('CheckBox3', true);
% %             hCheckBox3.ValueChangedFcn = {@callbacks.CheckBoxStateChanged, this};
% 
% 
%             hSection2 = tab1.addSection('BUTTON GROUP');
%             hColumn21 = hSection2.addColumn();
% 
%             radioButtonGroup = ButtonGroup;
%             btn211 = RadioButton(radioButtonGroup, 'Radio button group 1');
%             btn212 = RadioButton(radioButtonGroup, 'Radio button group 2');
%             btn211.ValueChangedFcn = {@callbacks.RadioButtonSelectionChanged, this};
%             btn212.ValueChangedFcn = {@callbacks.RadioButtonSelectionChanged, this};
% 
% 
%             hSection3 = tab1.addSection('POP-UP LIST');
% 
%             sub_item1 = matlab.ui.internal.toolstrip.ListItem('Add Plot');
%             sub_item2 = matlab.ui.internal.toolstrip.ListItem('Delete Plot');
%             sub_popup = matlab.ui.internal.toolstrip.PopupList();
%             sub_popup.add(sub_item1);
%             sub_popup.add(sub_item2);
%             
%             item1 = matlab.ui.internal.toolstrip.ListItem('Add Plot',matlab.ui.internal.toolstrip.Icon.ADD_16);
%             item2 = matlab.ui.internal.toolstrip.ListItemWithPopup('Delete Plot',matlab.ui.internal.toolstrip.Icon.CUT_16);
%             item2.Popup = sub_popup;
%             
%             popup = matlab.ui.internal.toolstrip.PopupList();
%             popup.add(item1);
%             popup.add(item2);
%             
%             btn = matlab.ui.internal.toolstrip.DropDownButton('New', Icon.NEW_24);
%             btn.Popup = popup;
% 
%             hColumn31 = hSection3.addColumn();
%             hColumn31.add(btn)
% 
% 
% 
%             hSection4 = tab1.addSection('x-Limits');
%             Column41  = hSection4.addColumn('Width', 70);
%             Column42  = hSection4.addColumn('Width', 20, 'HorizontalAlignment', 'center');
%             Column43  = hSection4.addColumn('Width', 70);
% 
%             hSpinner1 = Spinner([-100 100], 0);  % [min,max], initialValue
%             hSpinner1.StepSize = 10;
%             hSpinner1.NumberFormat = 'double';
%             hSpinner1.DecimalFormat = '2f';
%             
%             hSpinner2 = Spinner([-100 100], 0);  % [min,max], initialValue
% 
%             Column41.add(hSpinner1)
%             Column41.add(hSpinner2)
% 
%             Column42.add(Label('x'))
%             Column42.add(Label('y'))
% 
%             hSpinner3 = Spinner([-100 100], 0);  % [min,max], initialValue
%             hSpinner4 = Spinner([-100 100], 0);  % [min,max], initialValue
% 
%             Column43.add(hSpinner3)
%             Column43.add(hSpinner4)
% 
% 
%             hSection5 = tab1.addSection('plot control');
%             Column51  = hSection5.addColumn();
%             Column52  = hSection5.addColumn();
%             Column53  = hSection5.addColumn();
% 
%             btn511  = ToggleButton(Icon.PAN_16);
%             btn512  = ToggleButton(Icon.ZOOM_IN_16);
%             btn521  = ToggleButton(Icon.UP_ONE_LEVEL_16);
%             btn522  = ToggleButton(Icon.UNLOCK_16);
%             btn531  = ToggleButton(Icon.STOP_16);
%             btn532  = ToggleButton(Icon.RUN_16);
% 
%             Column51.add(btn511)
%             Column51.add(btn512)
%             Column52.add(btn521)
%             Column52.add(btn522)
%             Column53.add(btn531)
%             Column53.add(btn532)
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
%             % ADD COMPONENTS
%             hColumn11.add(btn111)
% 
%             hColumn12.add(btn121);
%             hColumn13.add(btn131);
% 
%             hColumn21.add(btn211)
%             hColumn21.add(btn212)
% 
%                       
% 
%             
% %             hColumn2.add(hCheckBox1);
% %             hColumn2.add(hCheckBox2);
% %             hColumn2.add(hCheckBox3);
% 
% 
%             
%             % INSERINDO EDIT FIELD (LABEL + EDITFIELD OBJECTS)
%             % EditField controls
%             hSection3 = tab1.addSection('ADD TEXT');
% 
%             column1 = hSection3.addColumn('HorizontalAlignment', 'left');
%             column1.add(Label('Label1:'))
%             column1.add(Label('Label Text 2:'))
% 
%             column2 = hSection3.addColumn('Width', 110);
%             column2.add(EditField);
%             column2.add(EditField('Initial text'));
% 
% 
%         
%             % TAB2
%             tab2     = Tab('PLOT');
%             tab2.Tag = 'PlotTab';
% 
%             % TAB3
%             tab3     = Tab('REPORT');
%             tab3.Tag = 'ReportTab';
%             
%             % TABGROUP
%             tabGroup = TabGroup();
%             tabGroup.Tag = 'myTabGroup';
%             
%             tabGroup.add(tab1, 1);
%             tabGroup.add(tab2, 2);
%             tabGroup.add(tab3, 3);
% 
%             this.Container.addTabGroup(tabGroup);