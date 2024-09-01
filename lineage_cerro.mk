#
# Copyright (C) 2024 LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit common AOSP configurations
$(call inherit-product, build/make/target/product/full_base_telephony.mk)
$(call inherit-product, build/make/target/product/core_64_bit_only.mk)

# Inherit device-specific configurations
$(call inherit-product, device/nubia/cerro/device.mk)

# Inherit LineageOS configurations
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_NAME := lineage_cerro
PRODUCT_DEVICE := cerro
PRODUCT_MODEL := NX721J
PRODUCT_BRAND := Nubia
PRODUCT_MANUFACTURER := Nubia

PRODUCT_CHARACTERISTICS := nosdcard

PRODUCT_GMS_CLIENTID_BASE := android-nubia

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME="PQ83A01" \
    PRIVATE_BUILD_DESC="PQ83A01-user 14 UKQ1.230917.001 20240718.123407 release-keys"

BUILD_FINGERPRINT := nubia/CN_PQ83A01/PQ83A01:14/UKQ1.230917.001/20240718.123407:user/release-keys