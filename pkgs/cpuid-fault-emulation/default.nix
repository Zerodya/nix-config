 { stdenv, kernel, kernelModuleMakeFlags }:
 
stdenv.mkDerivation {
  pname = "cpuid_fault_emulation";
  version = "0.1";
 
  src = ./source;
 
  nativeBuildInputs = kernel.moduleBuildDependencies;
  hardeningDisable = [
    "pic"
    "format"
  ];
 
  # Patch the hardcoded host paths to point into the Nix store
  postPatch = ''
    substituteInPlace Makefile \
      --replace '/lib/modules/$(KERNEL)/build' '${kernel.dev}/lib/modules/${kernel.modDirVersion}/build' \
      --replace '$(shell uname -r)' '${kernel.modDirVersion}'
  '';
 
  # modules_install signs the module with kmodigest (produces the .ko.cer nixpkgs expects)
  makeFlags = kernelModuleMakeFlags ++ [
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=extra"
    "DEPMOD=true"
  ];
  installTargets = [ "modules_install" ];
  installFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
  ];
 
  meta.platforms = [ "x86_64-linux" ];
}
