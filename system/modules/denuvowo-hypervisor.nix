 { config, pkgs, ... }:
 
let
  cpuid-fault-emulation = pkgs.callPackage ../../pkgs/cpuid-fault-emulation {
    kernel = config.boot.kernelPackages.kernel;
  };
in
{
  # Disable UMIP
  boot.kernelParams = [ "clearcpuid=umip" ];
 
  # Hypervisor
  boot.extraModulePackages = [ cpuid-fault-emulation ];
 
  # Optional shell scripts to disable and enable the hypervisor
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "denuvowo-enable-hypervisor" ''
      sudo modprobe -r kvm_amd kvm
      sudo modprobe cpuid_fault_emulation
    '')
    (pkgs.writeShellScriptBin "denuvowo-disable-hypervisor" ''
      sudo modprobe -r cpuid_fault_emulation
      sudo modprobe kvm_amd kvm
    '')
  ];
}
 