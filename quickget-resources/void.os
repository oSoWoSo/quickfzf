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
readonly HOMEPAGE="https://voidlinux.org/"
# Set this to 1 if your fetch_info function fetches data from the internet, 0 if it's hardcoded
readonly CACHE_DATA=0
# Set this variable depending on whether or not the operating system requires an edition to be specified
readonly REQUIRES_EDITION=1
# Add all valid architectures for your operating system here. The first one in the array will be the default (if host system does not match)
# Use the most standard name for each architecture. Example: amd64, arm64, riscv64, i386. NOT: x86_64, aarch64, x86, riscv.
readonly ARCHITECTURES=(amd64 i686 arm64 arm32)
# (OPTIONAL, HIGHLY RECOMMENDED) Is Operating System based of something or Independent? Example: arch, debian
readonly BASEDOF="Independent"
# (OPTIONAL, HIGHLY RECOMMENDED) Login information for Live image. Example: anon:void, root:voidlinux
readonly CREDENTIALS="anon:voidlinux, root:voidlinux"
# (OPTIONAL, HIGHLY RECOMMENDED) Brief description of the operating system
readonly DESCRIPTION="General purpose operating system. Its package system allows you to quickly install, update and remove software; software is provided in binary packages or can be built directly from sources."
# (OPTIONAL, HIGHLY RECOMMENDED) Set this to the friendly name of the operating system, if applicable.
readonly PRETTY_NAME="Void Linux"

function fetch_info() {
    case "${ARCH}" in
        amd64)
            # Add editions and releases here. Or, replace this with your code to fetch releases and editions.
            RELEASES+=(glibc musl)
            # You may leave EDITIONS blank if there is only one edition.
            EDITIONS+=(base xfce)
            ;;
        i686)
            # Add editions and releases here. Or, replace this with your code to fetch releases and editions.
            RELEASES+=(glibc)
            # You may leave EDITIONS blank if there is only one edition.
            EDITIONS+=(base xfce)
            ;;
        arm64)
            # Add editions and releases here. Or, replace this with your code to fetch releases and editions.
            RELEASES+=(glibc musl)
            # You may leave EDITIONS blank if there is only one edition.
            EDITIONS+=()
            ;;
        arm32)
            # Add editions and releases here. Or, replace this with your code to fetch releases and editions.
            RELEASES+=(glibc musl)
            # You may leave EDITIONS blank if there is only one edition.
            EDITIONS+=(armv6l armv7l)
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
    local URL="https://repo-default.voidlinux.org/live/current"
    local ISO=""
    local DATE=""
    local HASH=""

    DATE=$(wget -q -O- "${URL}/sha256sum.txt" | head -n1 | cut -d'.' -f1 | cut -d'-' -f4)

    case "${RELEASE}" in
        musl)
            case "${ARCH}" in
                amd64) ISO="void-live-x86_64-musl-${DATE}-${EDITION}.iso";;
                arm64) ISO="void-aarch64-musl-ROOTFS-${DATE}.tar.xz";;
                arm32) ISO="void-armv7l-musl-ROOTFS-${DATE}.tar.xz"
            esac
            ;;
        glibc)
            case "${ARCH}" in
                amd64) ISO="void-live-x86_64-${DATE}-${EDITION}.iso";;
                i686) ISO="void-live-i686-${DATE}-${EDITION}.iso";;
                arm64) ISO="void-aarch64-ROOTFS-${DATE}.tar.xz";;
                arm32) ISO="void-armv7l-ROOTFS-${DATE}.tar.xz";;
            esac
            ;;
    esac

    HASH=$(wget -q -O- "${URL}/sha256sum.txt" | grep "${ISO}" | cut -d' ' -f4)

    # You can also use switch cases to handle the variables differently depending on architecture or anything else

    # These are default options. You may change them if necessary. If multiple files need to be downloaded,
    # they may be separated by a space, with hashes (if applicable) following the applicable files (once again, separated by a space).
    # Of course, each HASH or URL should be enclosed in double quotes.
    case "${2}" in
        # Friendly is the show_iso_url option. It should print the URL(s) in a way that's easily readable, and not hashes
        --friendly)
            echo "${URL}/${ISO}";;
        # The first file (if multiple are present) will be listed as the ISO in the VM config.
        --download)
            echo "${URL}/${ISO}" "${HASH}";;
    esac
    # If you need to handle ALL downloading within this function, call whatever method you'd like, and then uncomment 'exit 2' so quickget knows to skip download.
    # Echo out the name of the ISO/IMG file in that case.
    # exit 2
    # If the command fails, use exit 1
}

# OPTIONAL VARIABLES. Use these to customize the behavior if necessary

# Set this to 1 if the operating system has unique editions (which you will set) for each release, 0 otherwise
readonly UNIQUE_EDITIONS=1
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
    # Echo the filename(s) of the old image followed by that of the new image. Separate them with :NEWPATH: as in this example
    # Example: echo -e "${OLD_FILE}:NEWPATH:${NEW_FILE}"
    exit 0
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
    --based-of)
        echo "${BASEDOF}";;
    --credentials)
        echo "${CREDENTIALS}";;
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