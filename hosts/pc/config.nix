# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware.nix
  ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.persistence."/persist" = {
    enable = true;  # NB: Defaults to true, not needed
    hideMounts = true;
    directories = [
      "/var/log/"
      "/var/lib/"
      "/etc/NetworkManager/system-connections/"
      "/etc/ssh/"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  environment.plasma6.excludePackages = [ pkgs.kdePackages.plasma-browser-integration ];
  programs.chromium.enablePlasmaBrowserIntegration = false;

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
    };

    desktopManager.plasma6.enable = true;

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      wayland.compositor = "kwin";
      theme = "${pkgs.where-is-my-sddm-theme}/share/sddm/themes/where_is_my_sddm_theme";
    };

    libinput = {
      enable = true;
    };
    openssh = {
      enable = true;
      ports = [ 19198 ];
      settings = {
        PasswordAuthentication = false;
#         kbdInteractiveAuthentication = false;
      };
      allowSFTP = false; # Don't set this if you need sftp
      extraConfig = ''
        AllowTcpForwarding yes
        X11Forwarding no
        AllowAgentForwarding no
        AllowStreamLocalForwarding no
        AuthenticationMethods publickey
      '';
    };

    nscd = {
      enable = true;
      enableNsncd = true;
    };

    power-profiles-daemon.enable = true;

    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };

    tlp.settings = {
      CPU_ENERGY_PERF_POLICY_ON_AC = "power";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 1;

      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "performance";

      INTEL_GPU_MIN_FREQ_ON_AC = 500;
      INTEL_GPU_MIN_FREQ_ON_BAT = 500;
      # INTEL_GPU_MAX_FREQ_ON_AC=0;
      # INTEL_GPU_MAX_FREQ_ON_BAT=0;
      # INTEL_GPU_BOOST_FREQ_ON_AC=0;
      # INTEL_GPU_BOOST_FREQ_ON_BAT=0;

      # PCIE_ASPM_ON_AC = "default";
      # PCIE_ASPM_ON_BAT = "powersupersave";
    };
  };

  powerManagement.cpuFreqGovernor = "performance";

  boot = {
    initrd.availableKernelModules = [ "acpi_call" "xhci_pci" "thunderbolt" "vmd" "nvme" "uas" "sd_mod" ];
    kernelModules = [ "kvm-intel" "acpi_call" ];
    kernelPackages = pkgs.linuxPackages_latest;
    loader.grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      default = "0";
      extraEntries = ''
        menuentry "Windows" {
          search --no-floppy --fs-uuid --set=root 1A77-10A4
          chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
        }
        menuentry "UEFI Shell" {
          insmod fat
          insmod chain
          search --no-floppy --set=root --file /shellx64.efi
          chainloader /shellx64.efi
        }
        if [ ''${grub_platform} == "efi" ]; then
          menuentry 'UEFI Firmware Settings' --id 'uefi-firmware' {
            fwsetup
          }
        fi
      '';
    };
    loader.efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };
#       systemd-boot.configurationLimit = 10;
#       systemd-boot.enable = true;
    supportedFilesystems = [ "btrfs" ];
    extraModulePackages =
      with config.boot.kernelPackages;
      [
        acpi_call
        cpupower
      ]
      ++ [ pkgs.cpupower-gui ];
  };

  i18n = {
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.waylandFrontend = true;
      fcitx5.addons = with pkgs; [
        (fcitx5-rime.override {
          rimeDataPkgs = [
            pkgs.rime-ice
          ];
        })
#         fcitx5-rime
        rime-data
        fcitx5-gtk
        fcitx5-lua
        fcitx5-fluent
      ];
    };
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LANGUAGE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
    };
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
  };

  security = {
    audit = {
      enable = true;
      rules = let
        home = config.homePath;
      in [
        "-a always,exit -F arch=b64 -F dir=${home}/.nv -F perm=wa -k home"
        "-a always,exit -F arch=b32 -F dir=${home}/.nv -F perm=wa -k home"
        "-a always,exit -F arch=b64 -F dir=${home}/.pki -F perm=wa -k home"
        "-a always,exit -F arch=b32 -F dir=${home}/.pki -F perm=wa -k home"
        "-a always,exit -F arch=b64 -F path=${home}/.gtkrc-2.0 -F perm=wa -k home"
        "-a always,exit -F arch=b32 -F path=${home}/.gtkrc-2.0 -F perm=wa -k home"
        "-a always,exit -F arch=b64 -S fork,vfork,clone,clone3 -k process"
        "-a always,exit -F arch=b32 -S fork,vfork,clone -k process"
        "-a always,exit -F arch=b64 -S execve,execveat -k process"
        "-a always,exit -F arch=b32 -S execve,execveat -k process"
      ];
    };
    auditd = {
      enable = true;
      settings.log_format = "ENRICHED";
    };
    rtkit.enable = true;
    sudo.enable = true;
    sudo.extraConfig = ''
      # rollback results in sudo lectures after each reboot
      Defaults lecture = never
    '';

#     pam.services = {
#       swaylock = { };
#       hyprlock = { };
#     };
  };

  networking = {
    hostName = "qwq";
    networkmanager.enable = true;
    nftables.enable = true;
  };
  time.timeZone = "Asia/Shanghai";

  environment.systemPackages = with pkgs; [
    zip unzipNLS libnatspec  p7zip gzip gnutar
    gnupg pinentry-all git openssh
    neovim fish nh fastfetch btop
    wineWow64Packages.stable wineWow64Packages.fonts winetricks
    qq onlyoffice-desktopeditors
    gcc llvm clang-tools
    cudaPackages.cudatoolkit cudaPackages.cudnn cudatoolkit
    kdePackages.kate
    kdePackages.ark
    kdePackages.kleopatra
    clash-verge-rev
    acpi brightnessctl cpupower-gui powertop wl-clipboard
    firefox google-chrome waydroid-helper android-tools
  ];

  programs = {
    fish.enable = true;
    nix-ld.enable = true;
    hyprland.enable = true;
    clash-verge = {
      enable = true;
      autoStart = true;
      serviceMode = true;
      tunMode = true;
      group = "wheel";
    };
    gnupg.agent = {
      enable = true;
      settings = {
        max-cache-ttl = 604800000;
        default-cache-ttl = 604800000;
        allow-preset-passphrase = "";
        no-allow-external-cache = "";
      };
    };
  };

  virtualisation.waydroid.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [
        "gtk"
        "hyprland"
      ];
    };

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  qt = {
    enable = true;
    style = "breeze";
  };

  users = {
    mutableUsers = false;
    users.${config.username} = {
      shell = pkgs.fish;
      isNormalUser = true;
      hashedPassword = "$6$3WplChayFoYc58g9$VmHO5dH7k7ABqnEMiaW8H.OyQ3QJRa/LThPKeLktvuNz/8lSR/0pBFXNmCnm8sZgAsRGdY/UE/EcfvtoDn6X31";
      extraGroups = [
        "networkmanager"
        "docker"
        "wheel"
      ];
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupCommand = "${pkgs.trash-cli}/bin/trash";
    users.${config.username} = {
      imports = [
        ./home.nix
        config.userConfModule
        inputs.self.homeModules
      ];
    };
  };

  fonts.packages = with pkgs; [
    ibm-plex
    noto-fonts
    lxgw-wenkai
    noto-fonts-cjk-serif
    noto-fonts-cjk-sans
    source-han-serif
    source-han-sans
    nerd-fonts.jetbrains-mono
    corefonts
    vista-fonts-chs
  ];

#   my.sysapp.onlyoffice.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}

