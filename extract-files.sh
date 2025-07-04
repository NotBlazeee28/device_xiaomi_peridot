#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=peridot
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        odm/etc/camera/enhance_motiontuning.xml|odm/etc/camera/motiontuning.xml|odm/etc/camera/night_motiontuning.xml)
            sed -i 's/xml=version/xml version/g' "${2}"
            ;;
        system_ext/etc/vintf/manifest/vendor.qti.qesdsys.service.xml)
            sed -i '1,6d' "${2}"
            ;;
        system_ext/lib64/libwfdmmsrc_system.so)
            [ "$2" = "" ] && return 0
            grep -q "libgui_shim.so" "${2}" || "${PATCHELF}" --add-needed "libgui_shim.so" "${2}"
            ;;
        system_ext/lib64/libwfdnative.so)
            ${PATCHELF} --remove-needed "android.hidl.base@1.0.so" "${2}"
            grep -q "libinput_shim.so" "${2}" || "${PATCHELF}" --add-needed "libinput_shim.so" "${2}"
            ;;
        vendor/bin/init.qcom.usb.sh)
            sed -i 's/ro.product.marketname/ro.product.odm.marketname/g' "${2}"
            ;;
        vendor/lib64/libqcodec2_core.so)
	    [ "$2" = "" ] && return 0
            "${PATCHELF}" --add-needed "libcodec2_shim.so" "${2}"
            ;;
        vendor/lib64/vendor.libdpmframework.so)
	    [ "$2" = "" ] && return 0
            "${PATCHELF}" --add-needed "libhidlbase_shim.so" "${2}"
            ;;
        system_ext/lib64/libwfdservice.so)
            [ "$2" = "" ] && return 0
            sed -i "s/android.media.audio.common.types-V2-cpp.so/android.media.audio.common.types-V3-cpp.so/" "${2}"
            ;;
        vendor/etc/media_codecs.xml|vendor/etc/media_codecs_cliffs_v0.xml|vendor/etc/media_codecs_performance_cliffs_v0.xml)
            [ "$2" = "" ] && return 0
            sed -i -E '/media_codecs_(google_audio|google_c2|google_telephony|vendor_audio)/d' "${2}"
            ;;
        vendor/etc/seccomp_policy/atfwd@2.0.policy|vendor/etc/seccomp_policy/wfdhdcphalservice.policy|vendor/etc/seccomp_policy/gnss@2.0-qsap-location.policy|vendor/etc/seccomp_policy/qsap_sensors.policy|vendor/etc/seccomp_policy/qesdksec.policy)
            [ "$2" = "" ] && return 0
            grep -q "gettid: 1" "${2}" || echo -e "\ngettid: 1" >> "${2}"
            ;;
        vendor/etc/init/vendor.xiaomi.hardware.vibratorfeature.service.rc)
            [ "$2" = "" ] && return 0
            sed -i "s/\/odm\/bin\//\/vendor\/bin\//g" "${2}"
            ;;
        vendor/lib64/libqcodec2_core.so)
	    [ "$2" = "" ] && return 0
            "${PATCHELF}" --add-needed "libcodec2_shim.so" "${2}"
            ;;
        vendor/lib64/vendor.libdpmframework.so)
	    [ "$2" = "" ] && return 0
            "${PATCHELF_0_17_2}" --add-needed "libhidlbase_shim.so" "${2}"
            ;;
        vendor/etc/seccomp_policy/c2audio.vendor.ext-arm64.policy)
            [ "$2" = "" ] && return 0
            grep -q "setsockopt: 1" "${2}" || echo "setsockopt: 1" >> "${2}"
            ;;
    esac
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
