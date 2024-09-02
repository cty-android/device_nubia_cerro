
#
# Copyright (C) 2024 LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/nubia/cerro

# A/B
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS := \
    boot \
    dtbo \
    init_boot \
    odm \
    product \
    recovery \
    system \
    system_dlkm \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor \
    vendor_boot \
    vendor_dlkm

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a-branchprot
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := kryo

# Build
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Bootloader
TARGET_NO_BOOTLOADER := true

# Display
TARGET_SCREEN_DENSITY := 540

# HIDL
DEVICE_FRAMEWORK_MANIFEST_FILE += $(DEVICE_PATH)/framework_manifest.xml

# Kernel
TARGET_NO_KERNEL_OVERRIDE := true

BOARD_KERNEL_BASE        := 0x00000000
BOARD_KERNEL_PAGESIZE    := 4096

BOARD_KERNEL_CMDLINE := disable_dma32=on swinfo.fingerprint=$(LINEAGE_VERSION) mtdoops.fingerprint=$(LINEAGE_VERSION)

BOARD_BOOTCONFIG := androidboot.hardware=qcom androidboot.memcg=1 androidboot.usbcontroller=a600000.dwc3 androidboot.console=ttyMSM0
BOARD_BOOTCONFIG += androidboot.init_fatal_reboot_target=recovery androidboot.selinux=permissive

BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_RAMDISK_USE_LZ4 := true

BOARD_BOOT_HEADER_VERSION := 4
BOARD_MKBOOTIMG_ARGS := --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_INIT_ARGS := --header_version $(BOARD_BOOT_HEADER_VERSION)

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 100663296
BOARD_DTBOIMG_PARTITION_SIZE := 8388608
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 8388608
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 100663296
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 104857600
BOARD_SUPER_PARTITION_SIZE := 12884901888

BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)

BOARD_USES_METADATA_PARTITION := true

BOARD_NUBIA_DYNAMIC_PARTITIONS_PARTITION_LIST := odm product system system_dlkm system_ext vendor vendor_dlkm
BOARD_NUBIA_DYNAMIC_PARTITIONS_SIZE := 12880707584 # (BOARD_SUPER_PARTITION_SIZE - 4 MiB)
BOARD_SUPER_PARTITION_GROUPS := nubia_dynamic_partitions

$(foreach p, $(call to-upper, $(BOARD_NUBIA_DYNAMIC_PARTITIONS_PARTITION_LIST)), \
    $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := ext4) \
    $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))

# Prebuilts
include device/nubia/cerro-prebuilt/BoardConfigPrebuilt.mk

# Platform
TARGET_BOARD_PLATFORM := pineapple
TARGET_BOOTLOADER_BOARD_NAME := pineapple

# Properties
TARGET_PRODUCT_PROP += $(DEVICE_PATH)/product.prop
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

# Recovery
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/init/fstab.qcom
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

SOONG_CONFIG_NAMESPACES += ufsbsg
SOONG_CONFIG_ufsbsg += ufsframework
SOONG_CONFIG_ufsbsg_ufsframework := bsg

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

BOARD_AVB_VBMETA_SYSTEM := product system system_ext
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := 1
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 1

include vendor/nubia/cerro/BoardConfigVendor.mk