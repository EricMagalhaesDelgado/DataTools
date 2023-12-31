classdef toolstripComponent

    properties
        %-----------------------------------------------------------------%
        Type            (1,:) char {mustBeMember(Type, {'Button',                  ...
                                                        'CheckBox',                ...
                                                        'DropDown',                ...
                                                        'DropDownButton',          ...
                                                        'Gallery',                 ...
                                                        'GridPickerButton',        ...
                                                        'Label',                   ...
                                                        'ListItemWithCheckBox',    ...
                                                        'ListItemWithRadioButton', ...
                                                        'RadioButton',             ...
                                                        'Spinner',                 ...
                                                        'SplitButton',             ...
                                                        'ToggleButton'})} = 'Button'
        Group           (1,:) char
        onConstructor   (1,1) struct
        postConstructor (1,1) struct
    end
end