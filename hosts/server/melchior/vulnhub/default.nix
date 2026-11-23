{ ... }:

{
  imports = [ ../../../../system/modules/vm-lab.nix ];

  vmLab = {
    internet = false; # true while GOAD provisions Windows, rebuild to toggle
    vulnhubBoxes = [ ];
    windowsVms.kingslanding = 3; # GOAD-Mini DC
  };
}
