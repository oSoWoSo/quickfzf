#!/usr/bin/env bash
# shellcheck disable=SC2034

RESOURCE_DIR="$(dirname "${0}")"

# Instructions: 
# 1. Set mandatory variables below, and set recommended variables if possible
# 2. Modify fetch_info function to include all of the necessary information (or way to fetch it)
# 3. Modify list_urls function to provide ISO(s) for the operating system
# 4. Check out the optional variables below the list_urls function to see if you have a use for any of them
# 5. If necessary, modify config_additions and/or prepare_image functions if you need it for your OS.

# MANDATORY VARIABLES: You must set these to appropriate values for your OS.

# Homepage of the operating system (URL)
readonly HOMEPAGE=""
# Set this to 1 if your fetch_info function fetches data from the internet, 0 if it's hardcoded
readonly CACHE_DATA=1
# Set this variable depending on whether or not the operating system requires an edition to be specified
readonly REQUIRES_EDITION=0
# Add all valid architectures for your operating system here. The first one in the array will be the default (if host system does not match)
# Use the most standard name for each architecture. Example: amd64, arm64, riscv64, i386. NOT: x86_64, aarch64, x86, riscv.
readonly ARCHITECTURES=(amd64)

# (OPTIONAL, HIGHLY RECOMMENDED) Brief description of the operating system
readonly DESCRIPTION=""
# (OPTIONAL, HIGHLY RECOMMENDED) Set this to the friendly name of the operating system, if applicable. 
readonly PRETTY_NAME="EndeavourOS"


function fetch_info() {
    case "${ARCH}" in
        amd64)
            local ENDEAVOUR_RELEASES="$(curl -s https://mirror.alpix.eu/endeavouros/iso/ | LC_ALL="en_US.UTF-8" sort -Mr | grep -o -P '(?<=<a href=").*(?=.iso">)' | grep -v 'x86_64' | cut -c 13-)"
            # Add editions and releases here. Or, replace this with your code to fetch releases and editions.
            RELEASES+=(${ENDEAVOUR_RELEASES,,})
            # You may leave EDITIONS blank if there is only one edition.
            EDITIONS+=()

            # If unique editions are required per release, use this template.
            # You may still put static editions (those which are present for ALL releases) in the EDITIONS array 
            # associativeEDITIONS['RELEASE1']="EDITION1;EDITION2;EDITION3"
            # associativeEDITIONS['RELEASE2']="EDITION1;EDITION2;EDITION3";;
            ;;

        # Add other architectures here if necessary, like this.
        # arm64)
            # RELEASES+=()
            # EDITIONS+=();;
    esac
}

function list_urls() {
    fetch_from_cache
    local ISO=""
    local ENDEAVOUR_RELEASES=""
    local URL="https://mirror.alpix.eu/endeavouros/iso"
    ENDEAVOUR_RELEASES="$(curl -s "${URL}"/ | grep -o -P '(?<=<a href=").*(?=.iso">)' | grep -v 'x86_64')"
    # Here, you can insert the URL, ISO, and HASH, similarly to the original quickget.
    # Alternatively, you may replace it with anything else, or call another function you create if necessary.
    ISO="$(echo "${ENDEAVOUR_RELEASES}" | grep -i ${RELEASE}).iso"
    local HASH=""

    HASH=$(wget -q -O- "${URL}/${ISO}.sha512sum" | cut  -d' ' -f1)
    

    # You can also use switch cases to handle the variables differently depending on architecture or anything else

    # These are default options. You may change them if necessary. If multiple files need to be downloaded,
    # they may be separated by a space, with hashes (if applicable) following the applicable files (once again, separated by a space).
    # Of course, each HASH or URL should be enclosed in double quotes.
    # If you need to handle ALL downloading within this function, call whatever method you'd like, and then uncomment 'exit 2' so quickget knows to skip download.
    case "${2}" in
        # Friendly is the show_iso_url option. It should print the URL(s) in a way that's easily readable, and not hashes
        --friendly)
            echo "${URL}/${ISO}";;
        # The first file (if multiple are present) will be listed as the ISO in the VM config. 
        --download)
            echo "${URL}/${ISO}" "${HASH}";;
    esac
    # exit 2
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
readonly GUEST_TYPE="linux"
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
    exit 0
}

function prepare_image() {
    # If you need to do anything to the image before it's used (for example, uncompressing), do it here.
    # Echo the filename(s) of the old image followed by that of the new image.
    # Example: echo ""
    exit 0
}



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
        validate_re "${@}";;
    --list-urls)
        list_urls "${@}";;
    --csv-urls)
        csv_urls;;
esac

# vim:tabstop=4:shiftwidth=4:expandtab