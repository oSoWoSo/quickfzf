---
author: Martin Wimpress
date: 26. listopadu 2023
footer: quickemu_conf
header: Quickemu konfigurační manuál
section: '1'
title: QUICKEMU_CONF
---

# NÁZEV

quickemu_conf - Možnosti a parametry v souboru quickemu &lt;vm&gt;.conf

# POPIS

**quickemu** vytvoří a spustí vysoce optimalizované virtuální stroje pro stolní počítače pro Linux, macOS a Windows. Používá rozumné výchozí hodnoty, ale mnoho konfiguračních možností lze přepsat v požadovaném konfiguračním souboru, který bude minimálně specifikovat cestu k instalačnímu disku ISO a QEMU pro nainstalovaný virtuální počítač.

# MOŽNOSTI

Toto jsou možnosti a výchozí hodnoty pro soubor &lt;vm&gt;.conf

```bash
# Lowercase variables are used in the VM config file only
boot="efi"
cpu_cores=""
disk_img=""
disk_size=""
display=""
extra_args=""
fixed_iso=""
floppy=""
guest_os="linux"
img=""
iso=""
macaddr=""
macos_release=""
network=""
port_forwards=()
preallocation="off"
ram=""
secureboot="off"
tpm="off"
usb_devices=()
viewer="spicy"
ssh_port=""
spice_port=""
public_dir=""
monitor="socket"
monitor_telnet_port="4440"
monitor_telnet_host="localhost"
monitor_cmd=""
serial="socket"
serial_telnet_port="6660"
serial_telnet_host="localhost"
# options: ehci(USB2.0), xhci(USB3.0)
usb_controller="ehci"
# options: ps2, usb, virtio
keyboard="usb"
keyboard_layout="en-us"
# options: ps2, usb, tablet, virtio
mouse="tablet"
```

# PŘÍKLADY

```bash
guest_os="linux"
disk_img="debian-bullseye/disk.qcow2"
iso="debian-bullseye/firmware-11.0.0-amd64-DVD-1.iso"
```

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

Výchozí konfigurace Windows 11 vypadá takto:

```bash
guest_os="windows"
disk_img="windows-11/disk.qcow2"
iso="windows-11/Win11_EnglishInternational_x64.iso"
fixed_iso="windows-11/virtio-win.iso"
tpm="on"
secureboot="on"
```

- `guest_os="windows"` instruuje `quickemu` k optimalizaci pro Windows.
- `fixed_iso=` určuje obraz ISO, který poskytuje ovladače VirtIO.
- `tpm="on"` dává pokyn `quickemu` k vytvoření softwarově emulovaného zařízení TPM pomocí `swtpm` .

# BIOS a EFI

Protože Quickemu 2.1.0 je `efi` výchozí možností spouštění. Pokud chcete toto chování přepsat, přidejte do konfigurace virtuálního počítače následující řádek, abyste povolili starší verzi systému BIOS.

- `boot="legacy"` - Povolí spouštění staršího systému BIOS

# Ladění procesorových jader, RAM a disků

Ve výchozím nastavení Quickemu vypočítá počet jader CPU a RAM pro přidělení virtuálnímu počítači na základě specifikací vašeho hostitelského počítače. Toto výchozí chování můžete přepsat a vyladit konfiguraci virtuálního počítače podle svých představ.

Přidejte další řádky do konfigurace virtuálního počítače:

- `cpu_cores="4"` - Zadejte počet jader CPU přidělených virtuálnímu počítači
- `ram="4G"` – Určete množství paměti RAM, které se má přidělit virtuálnímu počítači
- `disk_size="16G"` - Zadejte velikost virtuálního disku přiděleného virtuálnímu počítači

## Předběžné přidělení disku

Režim předběžného přidělení (povolené hodnoty: `off` (výchozí), `metadata` , `falloc` , `full` ). Obrázek s předem přidělenými metadaty je zpočátku větší, ale může zlepšit výkon, když obrázek potřebuje růst.

Určete, jaké předběžné přidělení disku se má použít, pokud existuje, při vytváření bitové kopie systémového disku přidáním takového řádku do konfigurace virtuálního počítače.

- `preallocation="metadata"`

## CD-ROM disky

Pokud chcete zpřístupnit obraz ISO z hostitele hostovi, přidejte do konfigurace virtuálního počítače následující řádek:

- `fixed_iso="/path/to/image.iso"`

## Diskety

Pokud jste jako [Alan Pope,](https://popey.com) pravděpodobně budete chtít připojit obraz diskety do hosta. Chcete-li tak učinit, přidejte do konfigurace virtuálního počítače následující řádek:

- `floppy="/path/to/floppy.img"`

# Sdílení souborů

Všechny možnosti sdílení souborů zpřístupní hostujícím virtuálním počítačům pouze `~/Public` (nebo lokalizované varianty) pro aktuálního uživatele.

## Samba 🐧 🍏 🪟

Pokud je na hostiteli k dispozici `smbd` , Quickemu automaticky povolí vestavěnou podporu QEMU pro vystavení sdílení Samba z hostitele hostovi.

Minimální komponenty Samba můžete nainstalovat na Ubuntu pomocí:

```bash
sudo apt install --no-install-recommends samba
```

Pokud je vše správně nastaveno, `smbd` adresa se vytiskne při spuštění virtuálního stroje. Například:

```
 - smbd:     On guest: smb://10.0.2.4/qemu
```

Pokud používáte hosta Windows, klikněte pravým tlačítkem na "Tento počítač", klikněte na "Přidat síťové umístění" a vložte tuto adresu, odstraňte `smb:` a nahraďte dopředná lomítka zpětnými lomítky (v tomto příkladu `\10.0.2.4\qemu` ).

## SPICE WebDAV 🐧 🪟

- TBD

## VirtIO-9P 🐧 🍏

- TBD

# Přesměrování síťového portu

Přidejte další řádek do konfigurace virtuálního počítače. Například:

- `port_forwards=("8123:8123" "8888:80")`

V příkladu výše:

- Port 8123 na hostiteli je přesměrován na port 8123 na hostovi.
- Port 8888 na hostiteli je přesměrován na port 80 na hostiteli.

# Zakázat práci v síti

Chcete-li úplně zakázat všechna síťová rozhraní v hostovaném virtuálním počítači, přidejte do konfigurace virtuálního počítače tento další řádek:

- `network="none"`

# Omezené vytváření sítí

Hosta můžete izolovat od hostitele (a širší sítě) pomocí možnosti omezení, která omezí práci v síti pouze na hosta a jakákoli virtuální zařízení.

Toho lze využít k tomu, aby software běžící uvnitř hosta nemohl telefonovat domů a přitom stále poskytoval síť uvnitř hosta. Přidejte tento další řádek do konfigurace virtuálního počítače:

- `network="restrict"`

# Přemostěné sítě

Připojte svůj virtuální počítač k předem nakonfigurovanému síťovému mostu. Přidejte další řádek do konfigurace virtuálního počítače:

- `network="br0"`

Pokud chcete mít trvalou MAC adresu pro vaše přemostěné síťové rozhraní v hostujícím virtuálním počítači, můžete do konfigurace virtuálního počítače přidat `macaddr` . QEMU vyžaduje, aby adresa MAC byla v rozsahu: **52:54:00:AB:00:00 - 52:54:00:AB:FF:FF**

Takže si můžete generovat své vlastní MAC adresy pomocí:

- `macaddr="52:54:00:AB:51:AE"`

# přesměrování USB

Quickemu podporuje přesměrování USB přes SPICE pass-through a host pass-through.

## Přesměrování SPICE (doporučeno)

Použití SPICE pro USB pass-through je nejjednodušší, protože nevyžaduje žádná zvýšená oprávnění, spusťte Quickemu s `--display spice` a poté z nabídky vyberte `Input` -&gt; `Select USB Device for redirection` a vyberte, která zařízení chcete připojit k hostovi.

## Přesměrování hostitele **NENÍ doporučeno**

**Přesměrování USB hostitele se nedoporučuje** , je poskytováno čistě pro zpětnou kompatibilitu se staršími verzemi Quickemu. Preferuje se použití SPICE, viz výše.

Přidejte další řádek do konfigurace virtuálního počítače. Například:

- `usb_devices=("046d:082d" "046d:085e")`

V příkladu výše:

- Zařízení USB s vendor_id 046d a product_id 082d bude vystaveno hostovi.
- Zařízení USB s vendor_id 046d a product_id 085e bude vystaveno hostovi.

Pokud na zařízení USB nelze zapisovat, `quickemu` zobrazí příslušné příkazy pro úpravu přístupových oprávnění zařízení USB, například takto:

```
 - USB:      Host pass-through requested:
              - Sennheiser Communications EPOS GTW 270 on bus 001 device 005 needs permission changes:
                sudo chown -v root:user /dev/bus/usb/001/005
                ERROR! USB permission changes are required 👆
```

# TPM

Od Quickemu 2.2.0 lze k hostujícím virtuálním počítačům přidat softwarově emulované zařízení TPM. Stačí přidat `tpm="on"` do konfigurace virtuálního počítače. `quickget` automaticky přidá tento řádek do virtuálních počítačů Windows 11.

# AUTOŘI

Napsal Martin Wimpress.

# HMYZ

Odešlete hlášení o chybách online na: [https://github.com/quickemu-project/quickemu/issues](https://github.com/quickemu-project/quickemu/issues)

# VIZ TAKÉ

Úplné zdroje na: [https://github.com/quickemu-project/quickemu](https://github.com/quickemu-project/quickemu)

quickget(1), quickemu(1), quickgui(1)
