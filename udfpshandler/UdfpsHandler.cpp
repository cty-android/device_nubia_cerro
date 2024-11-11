/*
 * Copyright (C) 2022 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#define LOG_TAG "UdfpsHandler.nubia_cerro"

#include <android-base/logging.h>
#include <android-base/unique_fd.h>

#include <fstream>

#include "UdfpsHandler.h"

#define COMMAND_NIT 10
#define PARAM_NIT_FOD 1
#define PARAM_NIT_NONE 0

#define COMMAND_FOD_PRESS_STATUS 1
#define PARAM_FOD_PRESSED 1
#define PARAM_FOD_RELEASED 0

#define FOD_STATUS_PATH "/sys/devices/platform/goodix_ts.0/gesture/fod_en"
#define FOD_STATUS_OFF 0
#define FOD_STATUS_ON 1

#define HBM_STATUS_PATH "/proc/driver/lcd_hbm"
#define HBM_STATUS_OFF 0
#define HBM_STATUS_ON 1

#define FINGERPRINT_ACQUIRED_VENDOR 7

namespace {

template <typename T>
static void set(const std::string& path, const T& value) {
    std::ofstream file(path);
    file << value;
}

static bool readBool(int fd) {
    char c;
    int rc;

    rc = lseek(fd, 0, SEEK_SET);
    if (rc) {
        LOG(ERROR) << "failed to seek fd, err: " << rc;
        return false;
    }

    rc = read(fd, &c, sizeof(char));
    if (rc != 1) {
        LOG(ERROR) << "failed to read bool from fd, err: " << rc;
        return false;
    }

    return c != '0';
}

}  // anonymous namespace

class NubiaCerroUdfpsHander : public UdfpsHandler {
  public:
    void init(fingerprint_device_t* device) {
        mDevice = device;
    }

    void onFingerDown(uint32_t /*x*/, uint32_t /*y*/, float /*minor*/, float /*major*/) {
        LOG(INFO) << __func__;
        setFingerStatus(true);
    }

    void onFingerUp() {
        LOG(INFO) << __func__;
        setFingerStatus(false);
    }

    void onUiReady() {
        LOG(INFO) << __func__;
        setUiReadyStatus(true);
    }

    void onAcquired(int32_t result, int32_t vendorCode) {
        LOG(INFO) << __func__ << " result: " << result << " vendorCode: " << vendorCode;
        if (result != FINGERPRINT_ACQUIRED_VENDOR) {
            setFingerStatus(false);
            if (result == FINGERPRINT_ACQUIRED_GOOD) setFodStatus(FOD_STATUS_OFF);
        } else if (vendorCode == 21 || vendorCode == 23) {
            /*
             * vendorCode = 21 waiting for fingerprint authentication
             * vendorCode = 23 waiting for fingerprint enroll
             */
            setFodStatus(FOD_STATUS_ON);
        } else if (vendorCode == 44) {
            /*
             * vendorCode = 44 fingerprint scan failed
             */
            setFingerStatus(false);
        }
    }

    void cancel() {
        LOG(INFO) << __func__;
        setFingerStatus(false);
        //setFodStatus(FOD_STATUS_OFF);
    }

  private:
    fingerprint_device_t* mDevice;

    void setFodStatus(int value) {
        set(FOD_STATUS_PATH, value);
    }

    void setHbmStatus(int value) {
        set(HBM_STATUS_PATH, value);
    }

    void setUiReadyStatus(int value) {
        mDevice->sendCustomizedCommand(mDevice, 30, value);
    }

    void setFingerStatus(bool pressed) {
        setHbmStatus(pressed);
        mDevice->sendCustomizedCommand(mDevice, 10, pressed);
    }
};

static UdfpsHandler* create() {
    return new NubiaCerroUdfpsHander();
}

static void destroy(UdfpsHandler* handler) {
    delete handler;
}

extern "C" UdfpsHandlerFactory UDFPS_HANDLER_FACTORY = {
        .create = create,
        .destroy = destroy,
};