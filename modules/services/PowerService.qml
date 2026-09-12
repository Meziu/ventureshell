pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    readonly property UPowerDevice battery: {
        for (let i = 0; i < UPower.devices.values.length; i++) {
            let device = UPower.devices.values[i]

            if (device.isLaptopBattery) return device
        }

        return null
    }

    readonly property int powerProfile: PowerProfiles.profile
    readonly property string powerProfileName: {
        return PowerProfile.toString(powerProfile)
    }

    function cyclePowerProfile() {
        if (PowerProfiles.profile === PowerProfile.PowerSaver) {
            PowerProfiles.profile = PowerProfile.Balanced
        } else if (PowerProfiles.profile === PowerProfile.Balanced && PowerProfiles.hasPerformanceProfile) {
            PowerProfiles.profile = PowerProfile.Performance
        } else if ((PowerProfiles.profile === PowerProfile.Balanced && !PowerProfiles.hasPerformanceProfile) || powerProfile === PowerProfile.Performance) {
            PowerProfiles.profile = PowerProfile.PowerSaver
        }
    }
}
