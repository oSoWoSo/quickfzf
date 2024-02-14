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
readonly HOMEPAGE="https://www.apple.com/macos/"
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
readonly PRETTY_NAME="${OS}"


function fetch_info() {
    case "${ARCH}" in
        amd64)
            # Add editions and releases here. Or, replace this with your code to fetch releases and editions.
            RELEASES+=(high-sierra mojave catalina big-sur monterey ventura sonoma)
            # You may leave EDITIONS blank if there is only one edition.
            EDITIONS+=()

            # If unique editions are required per release, use this template.
            # You may still put static editions (those which are present for ALL releases) in the EDITIONS array 
            # associativeEDITIONS['RELEASE1']="EDITION1;EDITION2;EDITION3"
            # associativeEDITIONS['RELEASE2']="EDITION1;EDITION2;EDITION3"
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
    local URL=""
    local ISO=""
    local HASH=""

    # You can also use switch cases to handle the variables differently depending on architecture or anything else

    local OpenCore_qcow2="https://github.com/kholia/OSX-KVM/raw/master/OpenCore/OpenCore.qcow2"
    local OVMF_CODE="https://github.com/kholia/OSX-KVM/raw/master/OVMF_CODE.fd"
    local OVMF_VARS="https://github.com/kholia/OSX-KVM/raw/master/OVMF_VARS-1920x1080.fd"

    # These are default options. You may change them if necessary. If multiple files need to be downloaded,
    # they may be separated by a space, with hashes (if applicable) following the applicable files (once again, separated by a space).
    # Of course, each HASH or URL should be enclosed in double quotes.
    case "${2}" in
        # Friendly is the show_iso_url option. It should print the URL(s) in a way that's easily readable, and not hashes
        --friendly)
            echo -e "Recovery URL (inaccessible through normal browser):\n${downloadLink}\nChunklist (used for verifying the Recovery Image):\n${chunkListLink}\n\
            Firmware URLs:\n${OpenCore_qcow2}\n${OVMF_CODE}\n${OVMF_VARS}";;
        # The first file (if multiple are present) will be listed as the ISO in the VM config. 
        --download)
            echo "${OVMF_CODE}" "${OVMF_VARS}" "${OpenCore_qcow2}"
    esac
    # If you need to handle ALL downloading within this function, call whatever method you'd like, and then uncomment 'exit 2' so quickget knows to skip download.
    # Echo out the name of the ISO/IMG file in that case
    # exit 2
    # If the command fails, use exit 1
}

# OPTIONAL VARIABLES. Use these to customize the behavior if necessary

# Set this to 1 if the operating system has unique editions (which you will set) for each release, 0 otherwise
readonly UNIQUE_EDITIONS=0
# If an edition is NOT required but multiple editions ARE available, put the default edition's name here.
readonly DEFAULT_EDITION=""
# If the operating system has a unique name for its editions (i.e. Windows: Languages), set it here
readonly EDITION_NAME="Editions"
# Set this to the OS type. These allow quickemu to optimize for your OS.
# Do not modify unless you know what is supported in this option or if you're adding it to quickemu
readonly GUEST_TYPE="macos"
# Set this to the image type (iso/img)
readonly IMAGE_TYPE="img"
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
    exit 0
}

function prepare_image() {
    # If you need to do anything to the image before it's used (for example, uncompressing), do it here.
    # If the file is your ISO/img file, echo "NEW_IMAGE_FILE" before the name of your file.
    # echo "NEW_IMAGE_FILE" "${VM_PATH}/${IMAGE_FILE}"

    exit 0
}

function get_macos() {
    local BOARD_ID=""
    local CWD=""
    local CHUNKCHECK=""
    local MLB="00000000000000000"
    local OS_TYPE="default"
    local downloadSession=""
    local chunkListSession=""
    local info=""
    local appleSession=""

    case ${RELEASE} in
        lion)           #10.7
            BOARD_ID="Mac-2E6FAB96566FE58C"
            MLB="00000000000F25Y00";;
        mountainlion)   #10.8
            BOARD_ID="Mac-7DF2A3B5E5D671ED"
            MLB="00000000000F65100";;
        mavericks)      #10.9
            BOARD_ID="Mac-F60DEB81FF30ACF6"
            MLB="00000000000FNN100";;
        yosemite)       #10.10
            BOARD_ID="Mac-E43C1C25D4880AD6"
            MLB="00000000000GDVW00";;
        elcapitan)      #10.11
            BOARD_ID="Mac-FFE5EF870D7BA81A"
            MLB="00000000000GQRX00";;
        sierra)         #10.12
            BOARD_ID="Mac-77F17D7DA9285301"
            MLB="00000000000J0DX00";;
        high-sierra)    #10.13
            BOARD_ID="Mac-BE088AF8C5EB4FA2"
            MLB="00000000000J80300";;
        mojave)         #10.14
            BOARD_ID="Mac-7BA5B2DFE22DDD8C"
            MLB="00000000000KXPG00";;
        catalina)       #10.15
            BOARD_ID="Mac-00BE6ED71E35EB86";;
        big-sur)        #11
            BOARD_ID="Mac-42FD25EABCABB274";;
        monterey)       #12
            BOARD_ID="Mac-E43C1C25D4880AD6";;
        ventura)        #13
            BOARD_ID="Mac-BE088AF8C5EB4FA2";;
        sonoma)
            BOARD_ID="Mac-53FDB3D8DB8CA971";;
        *) echo "ERROR! Unknown release: ${RELEASE}"
           releases_macos
           exit 1;;
    esac

    CWD="$(dirname "${0}")"
    if [ -x "${CWD}/verifyRecoveryImage" ]; then
        CHUNKCHECK="${CWD}/verifyRecoveryImage"
    elif [ -x /usr/share/quickemu/quickget-resources/verifyRecoveryImage ]; then
        CHUNKCHECK="/usr/share/quickemu/quickget-resources/verifyRecoveryImage"
    else
        web_get "https://raw.githubusercontent.com/wimpysworld/quickemu/master/quickget-resources/verifyRecoveryImage" "${HOME}/.quickemu"
        CHUNKCHECK="${HOME}/.quickemu/verifyRecoveryImage"
    fi

    if [ -z "${CHUNKCHECK}" ]; then
        echo "ERROR! Could not find chunkcheck. Exiting."
    fi

    appleSession=$(curl -v -H "Host: osrecovery.apple.com" -H "Connection: close" -A "InternetRecovery/1.0" http://osrecovery.apple.com/ 2>&1 | tr ';' '\n' | awk -F'session=|;' '{print $2}' | grep 1)
    info=$(curl -s -X POST -H "Host: osrecovery.apple.com" -H "Connection: close" -A "InternetRecovery/1.0" -b "session=\"${appleSession}\"" -H "Content-Type: text/plain"\
    -d $'cid='"$(generate_id 16)"$'\nsn='${MLB}$'\nbid='${BOARD_ID}$'\nk='"$(generate_id 64)"$'\nfg='"$(generate_id 64)"$'\nos='${OS_TYPE} \
    http://osrecovery.apple.com/InstallationPayload/RecoveryImage | tr ' ' '\n')
    downloadLink=$(echo "$info" | grep 'oscdn' | grep 'dmg')
    downloadSession=$(echo "$info" | grep 'expires' | grep 'dmg')
    chunkListLink=$(echo "$info" | grep 'oscdn' | grep 'chunklist')
    chunkListSession=$(echo "$info" | grep 'expires' | grep 'chunklist')

    if ! python3 "${CHUNKCHECK}" "${VM_PATH}" 2> /dev/null; then
        echo "Verification failed."
        exit 1
    fi
    echo "Verified macOS ${RELEASE} image using chunklist."

    if [ -e "${VM_PATH}/RecoveryImage.dmg" ] && [ ! -e "${VM_PATH}/RecoveryImage.img" ]; then
        echo "Converting RecoveryImage..."
        qemu-img convert "${VM_PATH}/RecoveryImage.dmg" -O raw "${VM_PATH}/RecoveryImage.img" 2>/dev/null
    fi

    rm "${VM_PATH}/RecoveryImage.dmg" "${VM_PATH}/RecoveryImage.chunklist"
    make_vm_config RecoveryImage.img
}



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