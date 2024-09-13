;; -*- mode: scheme; -*-
(use-modules (gnu)
             (gnu system)
             (gnu system nss)
             (gnu system install)
             (gnu services avahi)
             (gnu services ssh)
             (gnu services desktop)
             (gnu services xorg)
             (gnu services cups)
             (gnu services vpn)
             (gnu services networking)
             (gnu services syncthing)
             (gnu services linux)
             (gnu services sysctl)
             (gnu services pm)
             (myguix services desktop)
             (myguix system install)
             (myguix packages base)
             (myguix packages linux)
             (myguix system linux-initrd)
             (srfi srfi-1))

(operating-system
  (host-name "lagertha")
  (timezone "Asia/Kolkata")
  (locale "en_US.utf8")

  (kernel linux)
  (kernel-arguments '("modprobe.blacklist=b43,b43legacy,ssb,bcm43xx,brcm80211,brcmfmac,brcmsmac,bcma"))
  (kernel-loadable-modules (list broadcom-sta))
  (firmware (list linux-firmware broadcom-bt-firmware))
  (initrd microcode-initrd)

  (keyboard-layout (keyboard-layout "us" "altgr-intl"
                                    #:options '("ctrl:nocaps"
                                                "altwin:swap_alt_win")))

  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets (list "/dev/sda"))
                (keyboard-layout keyboard-layout)))

  (swap-devices (list (swap-space
                       (target (uuid "ac2f440b-33d9-40ef-b751-bvd7b7fb4bb8")))))

  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "57D1-D16E"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device (uuid "a2660229-e393-49c9-9113-a04d689a0e0d" 'ext4))
                         (type "ext4")) %base-file-systems))

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "b")
                  (comment "Ayan")
                  (group "users")
                  (home-directory "/home/b")
                  (shell (file-append (specification->package "zsh")
                                      "/bin/zsh"))
                  (supplementary-groups '("adbusers" "wheel" "netdev" "lp"
                                          "audio" "video")))
                %base-user-accounts))

  ;; System-wide packages
  (packages (append (list (specification->package "font-dejavu")
                          (specification->package "font-iosevka-comfy")
                          (specification->package "font-google-noto")
                          (specification->package "font-google-noto-serif-cjk")
                          (specification->package "font-google-noto-sans-cjk")
                          (specification->package "fontconfig"))
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list
            ;; Desktop Environment
            (service gnome-desktop-service-type)
            (set-xorg-configuration
             (xorg-configuration (keyboard-layout keyboard-layout)))
            (service gnome-keyring-service-type)

            ;; Printing Services
            (service cups-service-type
                     (cups-configuration (web-interface? #t)
                                         (extensions (list (specification->package
                                                            "cups-filters")
                                                           (specification->package
                                                            "brlaser")
                                                           (specification->package
                                                            "foomatic-filters")))))
            ;; Networking Setup
            (service network-manager-service-type
                     (network-manager-configuration (vpn-plugins (list (specification->package
                                                                        "network-manager-openvpn")))))
            (service wpa-supplicant-service-type)
            (simple-service 'network-manager-applet profile-service-type
                            (list (specification->package
                                   "network-manager-applet")))
            (service modem-manager-service-type)
            (service usb-modeswitch-service-type)

            ;; OpenSSH for remote access
            (service openssh-service-type)

            ;; Networking Services
            (service avahi-service-type)
            (service nftables-service-type)
            (service ntp-service-type)

            ;; VPN Services
            (service bitmask-service-type)

            ;; Power Management Services
            (service tlp-service-type
                     (tlp-configuration (cpu-boost-on-ac? #t)
                                        (wifi-pwr-on-bat? #t)))
            (service thermald-service-type)

            ;; Linux Services
            (service earlyoom-service-type)
            (service zram-device-service-type)

            ;; Miscellaneous Services
            (service sysctl-service-type
                     (sysctl-configuration (settings (append '(("net.ipv4.ip_forward" . "1")
                                                               ("vm.max_map_count" . "262144"))
                                                      %default-sysctl-settings)))))
           ;; This is the default list of services we
           ;; are appending to.
           %my-desktop-services))
  (name-service-switch %mdns-host-lookup-nss))
