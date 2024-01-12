---
author: Martin Wimpress
date: 26. listopadu 2023
footer: rychlovka
header: Quickget uživatelská příručka
section: '1'
title: RYCHLE
---

# NÁZEV

quickget - stáhněte si a připravte materiály pro stavbu quickemu VM

# SYNOPSE

**quickget** [ *os* ] [ *vydání* ] [ *vydání* ] | [ *MOŽNOST* ]*

# POPIS

**quickget** stáhne potřebné materiály a připraví konfiguraci pro `quickemu` , kterou lze použít ke sestavení a spuštění

# MOŽNOSTI

**verze | -verze | --version** : zobrazit verzi (z Quickemu)

**seznam | seznam_csv | list_json** : poskytuje csv seznam všech podporovaných hostujících OS, verzí a variant.

**`--show-iso-url` | -s** { **os** } { **vydání** } [ **vydání** ] : zobrazí URL pro stažení ISO

**`--test-iso-url` | -t** { **os** } { **vydání** } [ **vydání** ] : otestujte, zda je k dispozici ISO

**`--open-distro-homepage` | -o** { **os** } : otevření domovské stránky OS v prohlížeči

**[OS] [Release] [Edition]** : specifikujte OS a verzi (a volitelné vydání), pokud není zadána dostatečná vstupní informace, bude nahlášen seznam chybějících možností a skript bude ukončen. Edice nemusí platit a pokud nebudou poskytnuty, budou výchozí.

# POZNÁMKY

## Host Ubuntu

`quickget` automaticky stáhne vydání Ubuntu a vytvoří konfiguraci virtuálního počítače.

```bash
quickget ubuntu 22.04
quickemu --vm ubuntu-22.04.conf
```

- Dokončete instalaci jako obvykle.
- Po instalaci:
    - Nainstalujte do hosta agenta SPICE ( `spice-vdagent` ), abyste povolili kopírování/vkládání a přesměrování USB
        - `sudo apt install spice-vdagent`
    - Chcete-li povolit sdílení souborů, nainstalujte do hosta agenta SPICE WebDAV ( `spice-webdavd` ).
        - `sudo apt install spice-webdavd`

### Ubuntu devel (denní) obrázky

`quickget` může také stahovat/obnovovat devel obrázky přes `zsync` pro vývojáře a testery Ubuntu.

```bash
quickget ubuntu devel
quickemu --vm ubuntu-devel.conf
```

`quickget ubuntu devel` můžete spouštět a obnovovat svůj každodenní vývojový obraz tak často, jak chcete, dokonce se automaticky přepne na novou sérii.

### Příchutě Ubuntu

Všechny oficiální příchutě Ubuntu jsou podporovány, stačí nahradit `ubuntu` vámi preferovanou příchutí.

- `edubuntu` (Edubuntu)
- `kubuntu` (Kubuntu)
- `lubuntu` (Lubuntu)
- `ubuntu-budgie` (Ubuntu andulka)
- `ubuntucinnamon` (Ubuntu skořice)
- `ubuntukylin` (Ubuntu Kylin)
- `ubuntu-mate` (Ubuntu MATE)
- `ubuntu-server` (Ubuntu Server)
- `ubuntustudio` (Ubuntu Studio)
- `ubuntu` (Ubuntu)
- `ubuntu-unity` (Ubuntu Unity)
- `xubuntu` (Xubuntu)

Můžete také použít `quickget` s možnostmi:

```shell
    # show an OS ISO download URL for {os} {release} [edition]
    quickget --show-iso-url fedora 38 Silverblue
    # test if and OS ISO is available for {os} {release} [edition]
    quickget --test-iso-url nixos 23.05 plasma5
    # open an OS distribution homepage in a browser
    quickget --open-distro-homepage  ubuntu-mate
```

Možnosti `--show-iso-url` a `--test-iso-url` **nefungují** pro `Windows` ( `quickget` začne stahovat požadované vydání a vydání systému Windows)

## Jiné operační systémy

`quickget` také podporuje:

- `alma` (Alma Linux)
- `alpine` (Alpine Linux)
- `android` (Android x86)
- `antix` (Antix)
- `archcraft` (Archcraft)
- `archlinux` (Arch Linux)
- `arcolinux` (Arco Linux)
- `batocera` (Batocera)
- `blendos` (BlendOS)
- `bodhi` (bodhi)
- `bunsenlabs` (Bunsenlabs)
- `cachyos` (CachyOS)
- `centos-stream` (CentOS Stream)
- `debian` (Debian)
- `deepin` (Deepin)
- `devuan` (devuan)
- `dragonflybsd` (DragonFlyBSD)
- `elementary` (základní OS)
- `endeavouros` (EndeavourOS)
- `endless` (nekonečný OS)
- `fedora` (Fedora)
- `freebsd` (FreeBSD)
- `freedos` (FreeDOS)
- `garuda` (Garuda Linux)
- `gentoo` (Gentoo)
- `ghostbsd` (GhostBSD)
- `haiku` (haiku)
- `holoiso` (SteamOS HoloISO)
- `kali` (kali)
- `kdeneon` (KDE Neon)
- `kolibrios` (KolibriOS)
- `linuxlite` (Linux Lite)
- `linuxmint` (Linux Mint)
- `lmde` (Linux Mint Debian Edition)
- `mageia` (Mageia)
- `manjaro` (mandžáro)
- `mxlinux` (MX Linux)
- `netboot` (netboot.xyz)
- `netbsd` (NetBSD)
- `nixos` (NixOS)
- `openbsd` (OpenBSD)
- `openindiana` (OpenIndiana)
- `opensuse` (openSUSE)
- `oraclelinux` (Oracle Linux)
- `peppermint` (PeppermintOS)
- `popos` (Pop!_OS)
- `porteus` (Porteus)
- `reactos` (ReactOS)
- `rebornos` (RebornOS)
- `rockylinux` (Rocky Linux)
- `siduction` (Siduction)
- `slackware` (slackware)
- `solus` (Solus)
- `spiral` (spirála)
- `tails` (ocásky)
- `tinycore` (Tiny Core Linux)
- `trisquel` (trisquel)
- `truenas-core` (TrueNAS Core)
- `truenas-scale` (TrueNAS Scale)
- `vanillaos` (Vanilla OS)
- `void` (Void Linux)
- `vxlinux` (VX Linux)
- `xerolinux` (XeroLinux)
- `zorin` (OS Zorin)

Nebo si můžete stáhnout image Linuxu a ručně vytvořit konfiguraci virtuálního počítače.

- Stáhněte si obraz .iso distribuce Linuxu
- Vytvořte konfigurační soubor virtuálního počítače; například `debian-bullseye.conf`

```bash
guest_os="linux"
disk_img="debian-bullseye/disk.qcow2"
iso="debian-bullseye/firmware-11.0.0-amd64-DVD-1.iso"
```

- Ke spuštění virtuálního počítače použijte `quickemu` :

```bash
quickemu --vm debian-bullseye.conf
```

- Dokončete instalaci jako obvykle.
- Po instalaci:
    - Nainstalujte do hosta agenta SPICE ( `spice-vdagent` ), abyste umožnili kopírování/vkládání a přesměrování USB.
    - Chcete-li povolit sdílení souborů, nainstalujte do hosta agenta SPICE WebDAV ( `spice-webdavd` ).

## host macOS

`quickget` automaticky stáhne obraz pro obnovení macOS a vytvoří konfiguraci virtuálního počítače.

```bash
quickget macos catalina
quickemu --vm macos-catalina.conf
```

Podporovány jsou macOS `high-sierra` , `mojave` , `catalina` , `big-sur` , `monterey` a `ventura` .

- Pomocí kurzorových kláves a klávesy Enter vyberte **základní systém macOS**
- Z **nástrojů macOS**
    - Klepněte na **Disk Utility** a **Pokračovat**
        - Ze seznamu vyberte `QEMU HARDDISK Media` (~103,08 GB) (na Big Sur a výše použijte `Apple Inc. VirtIO Block Device` ) a klikněte na **Vymazat** .
        - Zadejte `Name:` pro disk
        - Pokud instalujete macOS Mojave nebo novější (Catalina, Big Sur, Monterey a Ventura), vyberte jako souborový systém kteroukoli z možností APFS. MacOS Extended nemusí fungovat.
    - Klikněte na **Vymazat** .
    - Klikněte **na Hotovo** .
    - Zavřete Disk Utility
- Z **nástrojů macOS**
    - Klikněte **na Přeinstalovat macOS** a **pokračovat**
- Dokončete instalaci obvyklým způsobem.
    - Při prvním restartu pomocí kurzorových kláves a klávesy Enter vyberte **instalační program macOS**
    - Při dalších restartech použijte kurzorové klávesy a klávesu Enter pro výběr disku, který jste pojmenovali
- Jakmile dokončíte instalaci macOS, zobrazí se vám připravený průvodce prvním spuštěním pro konfiguraci různých možností a nastavení uživatelského jména a hesla.
- VOLITELNÉ: Po dokončení přednastaveného průvodce možná budete chtít povolit funkci TRIM, kterou počítačový průmysl vytvořil pro disky SSD. Tato funkce v naší instalaci macOS umožní QuickEmu zkomprimovat (zmenšit) váš obraz disku macOS, kdykoli odstraníte soubory ve virtuálním počítači. Bez tohoto kroku se obraz disku macOS pouze zvětší a nezmenší se, ani když v macOS smažete spoustu dat.
    - Chcete-li povolit TRIM, otevřete aplikaci Terminál a zadejte následující příkaz a poté stiskněte `<kbd>` {=html}enter `</kbd>` {=html}, abyste systému Macos řekli, aby použil příkaz TRIM na pevném disku, když jsou soubory smazány:

```bash
sudo trimforce enable
```

Budete vyzváni k zadání hesla k účtu, abyste získali potřebná oprávnění. Jakmile zadáte heslo a stisknete `<kbd>` {=html}enter `</kbd>` {=html}, příkaz si vyžádá potvrzení ve formě dvou otázek, které vyžadují zadání `<kbd>` {=html}y `</kbd>` {=html} (pro odpověď "ano") následované `<kbd>` {=html}zadejte `</kbd>` {=html} pro potvrzení. Pokud stisknete `<kbd>` {=html}zadejte `</kbd>` {=html}, aniž byste předtím zadali `<kbd>` {=html}y `</kbd>` {=html}, systém to bude považovat za negativní odpověď, jako byste řekli "Ne":

```plain
IMPORTANT NOTICE: This tool force-enables TRIM for all relevant attached devices, even though such devices may not have been validated for data integrity while using TRIM. Use of this tool to enable TRIM may result in unintended data loss or data corruption. It should not be used in a commercial operating environment or with important data. Before using this tool, you should back up all of your data and regularly back up data while TRIM is enabled. This tool is provided on an "as is" basis. APPLE MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THIS TOOL OR ITS USE ALONE OR IN COMBINATION WITH YOUR DEVICES, SYSTEMS, OR SERVICES. BY USING THIS TOOL TO ENABLE TRIM, YOU AGREE THAT, TO THE EXTENT PERMITTED BY APPLICABLE LAW, USE OF THE TOOL IS AT YOUR SOLE RISK AND THAT THE ENTIRE RISK AS TO SATISFACTORY QUALITY, PERFORMANCE, ACCURACY AND EFFORT IS WITH YOU.
Are you sure you with to proceed (y/N)?
```

A druhé potvrzení, jakmile potvrdíte předchozí:

```plain
Your system will immediately reboot when this is complete.
Is this OK (y/N)?
```

Jak uvádí poslední zpráva, váš systém se automaticky restartuje, jakmile bude příkaz dokončen.

Výchozí konfigurace macOS vypadá takto:

```bash
guest_os="macos"
img="macos-catalina/RecoveryImage.img"
disk_img="macos-catalina/disk.qcow2"
macos_release="catalina"
```

- `guest_os="macos"` instruuje Quickemu k optimalizaci pro macOS.
- `macos_release="catalina"` dává Quickemu pokyn k optimalizaci pro konkrétní vydání macOS.
    - Například VirtIO Network a Memory Ballooning jsou dostupné v Big Sur a novějších, ale ne v předchozích verzích.
    - A VirtIO Block Media (disky) jsou podporovány/stabilní v Catalina a novějších.

### kompatibilita s macOS

Při spouštění systému macOS přes Quickemu je třeba zvážit.

- Podporovaná vydání macOS:
    - Vysoká Sierra
    - Mojave
    - Catalina **(doporučeno)**
    - Velký Sur
    - Monterey
    - Ventura
- `quickemu` automaticky stáhne požadovaný zavaděč [OpenCore](https://github.com/acidanthera/OpenCorePkg) a firmware OVMF z [OSX-KVM](https://github.com/kholia/OSX-KVM) .
- Ve výchozím nastavení optimalizováno, ale není k dispozici žádná akcelerace GPU.
    - Je zjištěn dodavatel hostitelského CPU a hostovaný CPU je podle toho optimalizován.
    - [VirtIO Block Media](https://www.kraxel.org/blog/2019/06/macos-qemu-guest/) se používá pro systémový disk tam, kde je podporováno.
    - Pro myš je použit [`usb-tablet` VirtIO](http://philjordan.eu/osx-virt/) .
    - Síť VirtIO ( `virtio-net` ) je podporována a povolena na macOS Big Sur a novějších, ale předchozí verze používají `vmxnet3` .
    - VirtIO Memory Ballooning je podporováno a povoleno v macOS Big Sur a novějších, ale pro ostatní verze podpory macOS je zakázáno.
- Hostitel USB a průchod SPICE je:
    - UHCI (USB 2.0) na macOS Catalina a dřívějších verzích.
    - XHCI (USB 3.0) na macOS Big Sur a novějších.
- Rozlišení displeje lze změnit pouze prostřednictvím předvoleb systému macOS.
- **Plně duplexní zvuk vyžaduje [VoodooHDA OC](https://github.com/chris1111/VoodooHDA-OC) nebo přenos přes USB audio zařízení do hostujícího virtuálního počítače macOS** .
- POZNÁMKA! Chcete-li nainstalovat VoodooHDA OC, je třeba vypnout [Gatekeeper](https://disable-gatekeeper.github.io/) a [System Integrity Protection (SIP).](https://developer.apple.com/documentation/security/disabling_and_enabling_system_integrity_protection)
- Sdílení souborů mezi hostem a hostitelem je dostupné přes [virtio-9p](https://wiki.qemu.org/Documentation/9psetup) a [SPICE webdavd](https://gitlab.gnome.org/GNOME/phodav/-/merge_requests/24) .
- Kopírování/vkládání prostřednictvím agenta SPICE **není v systému macOS k dispozici** .

### macOS App Store

Pokud se při pokusu o přihlášení do App Store zobrazí zpráva *„Vaše zařízení nebo počítač nelze ověřit“* , ujistěte se, že je vaše zařízení s kabelovou ethernetovou sítí `en0` . K ověření použijte `ifconfig` v terminálu.

Pokud kabelové ethernetové zařízení není `en0` , přejděte do *Předvolby systému* -&gt; *Síť* , odstraňte všechna síťová zařízení a použijte změny. Dále otevřete terminál a spusťte následující:

```bash
sudo rm /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist
```

Nyní restartujte a App Store by měl fungovat.

## Windows 8, 10 a 11 pro hosty

`quickget` dokáže automaticky stáhnout [Windows10](https://www.microsoft.com/software-download/windows10) a [Windows 11](https://www.microsoft.com/software-download/windows11) a vytvořit optimalizovanou konfiguraci virtuálního stroje. Tato konfigurace také zahrnuje [ovladače VirtIO pro Windows](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/) .

Windows 8.1 je také podporován, ale neobsahuje žádnou automatickou instalaci ani optimalizaci ovladačů.

```bash
quickget windows 11
quickemu --vm windows-11.conf
```

- Dokončete instalaci obvyklým způsobem.
- Všechny příslušné ovladače a služby by se měly nainstalovat automaticky.
- Automaticky se vytvoří uživatelský účet místního správce s těmito přihlašovacími údaji:
    - Uživatelské jméno: `Quickemu`
    - Heslo: `quickemu`

Výchozí konfigurace Windows 11 vypadá takto:

```bash
guest_os="windows"
disk_img="windows-11/disk.qcow2"
iso="windows-11/windows-11.iso"
fixed_iso="windows-11/virtio-win.iso"
tpm="on"
secureboot="off"
```

- `guest_os="windows"` instruuje `quickemu` k optimalizaci pro Windows.
- `fixed_iso=` určuje obraz ISO, který poskytuje ovladače VirtIO.
- `tpm="on"` dává pokyn `quickemu` k vytvoření softwarově emulovaného zařízení TPM pomocí `swtpm` .

# AUTOŘI

Napsal Martin Wimpress.

# HMYZ

Odešlete hlášení o chybách online na: [https://github.com/quickemu-project/quickemu/issues](https://github.com/quickemu-project/quickemu/issues)

# VIZ TAKÉ

Úplné zdroje na: [https://github.com/quickemu-project/quickemu](https://github.com/quickemu-project/quickemu)

quickemu(1), quickemu_conf(1), quickgui(1)
