#!/usr/bin/env bash
# shellcheck disable=SC2034

# Instructions: 
# 1. Set mandatory variables below, and set recommended variables if possible
# 2. Modify fetch_info function to include all of the necessary information (or way to fetch it)
# 3. Modify list_urls function to provide ISO(s) for the operating system
# 4. Check out the optional variables below the list_urls function to see if you have a use for any of them
# 5. If necessary, modify config_additions and/or prepare_image functions if you need it for your OS.

# MANDATORY VARIABLES: You must set these to appropriate values for your OS.

# Homepage of the operating system (URL)
readonly HOMEPAGE="https://www.microsoft.com/en-us/windows/"
# Set this to 1 if your fetch_info function fetches data from the internet, 0 if it's hardcoded
readonly CACHE_DATA=0
# Set this variable depending on whether or not the operating system requires an edition to be specified
readonly REQUIRES_EDITION=0
# Add all valid architectures for your operating system here. The first one in the array will be the default (if host system does not match)
# Use the most standard name for each architecture. Example: amd64, arm64, riscv64, i386. NOT: x86_64, aarch64, x86, riscv.
readonly ARCHITECTURES=(amd64)

# (OPTIONAL, HIGHLY RECOMMENDED) Brief description of the operating system
readonly DESCRIPTION=""
# (OPTIONAL, HIGHLY RECOMMENDED) Set this to the friendly name of the operating system, if applicable. 
readonly PRETTY_NAME="Windows"


function fetch_info() {
    case "${ARCH}" in
        amd64)
            # Add editions and releases here. Or, replace this with your code to fetch releases and editions.
            RELEASES+=(8 10 10-ltsc 11)
            # You may leave EDITIONS blank if there is only one edition.
            EDITIONS+=()

            # If unique editions are required per release, use this template.
            # You may still put static editions (those which are present for ALL releases) in the EDITIONS array 
            associativeEDITIONS['8']="Arabic;Brazilian Portuguese;Bulgarian;Chinese (Simplified);Chinese (Traditional);Chinese (Traditional Hong Kong);\
Croatian;Czech;Danish;Dutch;English (United States);English International;Estonian;Finnish;French;German;Greek;Hebrew;Hungarian;Italian;Japanese;\
Latvian;Lithuanian;Norwegian;Polish;Portuguese;Romanian;Russian;Serbian Latin;Slovak;Slovenian;Spanish;Swedish;Thai;Turkish;Ukrainian"
            
            associativeEDITIONS['10-ltsc']="English (United States);English (Great Britain);Chinese (Simplified);Chinese (Traditional);French;German;Italian;\
Japanese;Korean;Portugese (Brazil);Spanish"

            associativeEDITIONS['10']="Arabic;Brazilian Portuguese;Bulgarian;Chinese (Simplified);Chinese (Traditional);Croatian;Czech;Danish;Dutch;\
English (United States);English International;Estonian;Finnish;French;French Canadian;German;Greek;Hebrew;Hungarian;Italian;Japanese;Korean;\
Latvian;Lithuanian;Norwegian;Polish;Portuguese;Romanian;Russian;Serbian Latin;Slovak;Slovenian;Spanish;Spanish (Mexico);Swedish;Thai;Turkish;Ukrainian"
            
            associativeEDITIONS['11']="Arabic;Brazilian Portuguese;Bulgarian;Chinese (Simplified);Chinese (Traditional);Croatian;Czech;Danish;Dutch;\
English (United States);English International;Estonian;Finnish;French;French Canadian;German;Greek;Hebrew;Hungarian;Italian;Japanese;Korean;\
Latvian;Lithuanian;Norwegian;Polish;Portuguese;Romanian;Russian;Serbian Latin;Slovak;Slovenian;Spanish;Spanish (Mexico);Swedish;Thai;Turkish;Ukrainian"
            ;;

        # Add other architectures here if necessary, like this.
        # arm64)
            # RELEASES+=()
            # EDITIONS+=();;
    esac
}

function list_urls() {
    fetch_from_cache

    # Here, you can insert the URL, ISO, and HASH, similarly to the original quickget.
    # Alternatively, you may replace it with anything else, or call another function you create if necessary.

    if [ "${RELEASE}" == "10-ltsc" ]; then
        download_windows-server windows-10-enterprise ltsc
    else
        download_windows "${RELEASE}"
    fi

    local spice_webdavd="https://www.spice-space.org/download/windows/spice-webdavd/spice-webdavd-x64-latest.msi"
    local spice_vdagent="https://www.spice-space.org/download/windows/vdagent/vdagent-win-0.10.0/spice-vdagent-x64-0.10.0.msi"
    local usbdk="https://www.spice-space.org/download/windows/usbdk/UsbDk_1.0.22_x64.msi"
    local virtio_win="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"

    # You can also use switch cases to handle the variables differently depending on architecture or anything else

    # These are default options. You may change them if necessary. If multiple files need to be downloaded,
    # they may be separated by a space, with hashes (if applicable) following the applicable files (once again, separated by a space).
    # Of course, each HASH or URL should be enclosed in double quotes.
    # If you need to add a custom filename, put it BEFORE the URL, separated by a space.
    # If you need to handle ALL downloading within this function, call whatever method you'd like, and then uncomment 'exit 2' so quickget knows to skip download.
    case "${2}" in
        # Friendly is the show_iso_url option. It should print the URL(s) in a way that's easily readable, and not hashes
        --friendly)
            echo "${iso_download_link}";;
        # The first file (if multiple are present) will be listed as the ISO in the VM config. 
        --download)
            echo "${FILE_NAME}" "${iso_download_link}" "${HASH}" "${virtio_win}"
            case "${RELEASE}" in
                10|11)
                    echo "${spice_webdavd}" "${spice_vdagent}" "${usbdk}"
            esac;;
    esac



    # exit 2
}

# OPTIONAL VARIABLES. Use these to customize the behavior if necessary

# Set this to 1 if the operating system has unique editions (which you will set) for each release, 0 otherwise
readonly UNIQUE_EDITIONS=1
# If an edition is NOT required but multiple editions ARE available, put the default edition's name here.
readonly DEFAULT_EDITION="English (United States)"
# If the operating system has a unique name for its editions (i.e. Windows: Languages), set it here
readonly EDITION_NAME="Languages"
# Set this to the OS type. These allow quickemu to optimize for your OS.
# Do not modify unless you know what is supported in this option or if you're adding it to quickemu
readonly GUEST_TYPE="windows"
# Set this to the image type (iso/img)
readonly IMAGE_TYPE="iso"
# Set this to the amount of days before the cache is considered outdated and refreshed (if fetching from internet)
readonly CACHE_DAYS=7


# OPTIONAL. Only use these functions if you need to do something special with the VM config or image file
function config_additions() {
    # Here, you can add any additional configuation options that should be included in the VM config.
    # Just echo them out (in quotation marks) if you want to append them to the other options.
    # Add "OVERRIDE" before the string to instead replace the value of a default option.
    # Example: echo OVERRIDE "disk_size=\"40G\"" to replace the default disk_size with 40G.
    # You can REMOVE options by adding REMOVE before the option name. 
    # Example: echo REMOVE "disk_size" to remove the disk_size option, such as for macOS VMs which have disk_size handled in quickemu
    echo "fixed_iso=\"${VM_PATH}/virtio-win.iso\""
    exit 0
}

function prepare_image() {
    # If you need to do anything to the image before it's used (for example, uncompressing), do it here.
    # Echo the filename(s) of the old image followed by that of the new image. Separate them with :NEWPATH: as in this example
    # Example: echo -e "${OLD_FILE}:NEWPATH:${NEW_FILE}"
    rm -f "${VM_PATH}/unattended.iso"
    case "${RELEASE}" in
        10|11)
            mkdir -p "${VM_PATH}/unattended" 2>/dev/null
            mv "${VM_PATH}/spice-webdavd-x64-latest.msi" "${VM_PATH}/unattended/spice-webdavd-x64-latest.msi"
            mv "${VM_PATH}/spice-vdagent-x64-0.10.0.msi" "${VM_PATH}/unattended/spice-vdagent-x64-0.10.0.msi"
            mv "${VM_PATH}/UsbDk_1.0.22_x64.msi" "${VM_PATH}/unattended/UsbDk_1.0.22_x64.msi"
            unattended_windows "${VM_PATH}/unattended/autounattend.xml"
            mkisofs -quiet -l -o "${VM_PATH}/unattended.iso" "${VM_PATH}/unattended/";;
    esac

    exit 0
}


source "$(dirname "${0}")/WINDOWS_DOWNLOADERS"

# Nothing below this line should be modified.

source "$(dirname "${0}")/DEFAULT_FUNCTIONS"

case "${1}" in
    --homepage)
        echo "${HOMEPAGE}";;
    --edition-name)
        echo "${EDITION_NAME}";;
    --pretty-name)
        echo "${PRETTY_NAME}";;
    --return-arch)
        echo "${ARCH}";;
    --description)
        echo "${DESCRIPTION}";;
    --guest)
        echo "${GUEST_TYPE}";;
    --image-type)
        echo "${IMAGE_TYPE}";;
    --refresh)
        if [ "${CACHE_DATA}" -eq 1 ]; then
            fetch_info
            populate_cache
        fi;;
    --validate-re)
        validate_re;;
    --list-urls)
        list_urls "${@}";;
    --prepare-image)
        prepare_image;;
    --config-additions)
        config_additions;;
    --csv-urls)
        csv_urls;;
esac

# vim:tabstop=4:shiftwidth=4:expandtab