function icon = treeIcon(IDN)            
    if     contains(IDN, 'RFeye', 'IgnoreCase', true);        icon = 'CRFS_24.png';
    elseif contains(IDN, {'FSL','FSVR','FSW','EB500','ETM'}); icon = 'R&S_24.png';
    elseif contains(IDN, {'N9344C', 'N9936B'});               icon = 'KeySight_24.png';
    elseif contains(IDN, 'MS2720T');                          icon = 'Anritsu_24.png';
    elseif contains(IDN, 'SA2500');                           icon = 'Tektronix_24.png';
    elseif contains(IDN, 'CWSM2');                            icon = 'CellPlan_24.png';
    else;                                                     icon = '';
    end            
end