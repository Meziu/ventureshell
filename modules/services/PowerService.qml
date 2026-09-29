pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

import "../../libraries/utils.js" as UtilsJS

Singleton {
    id: root

    property string pluggedIcon: ""
    property list<string> batteryChargeIcons: ["", "", "", "", ""]
    property var powerProfilesIcons: {
        "Performance": "",
        "Balanced": "",
        "PowerSaver": ""
    }

    readonly property string currentBatteryIcon: {
        if (root.battery) {
            const percentage = Math.min(root.battery.percentage, 0.99);
            return root.batteryChargeIcons[Math.floor(percentage * root.batteryChargeIcons.length)];
        }

        return root.batteryChargeIcons[0];
    }

    readonly property string powerProfileIcon: {
        return root.powerProfilesIcons[root.powerProfileName]
    }

    readonly property UPowerDevice battery: {
        for (let i = 0; i < UPower.devices.values.length; i++) {
            let device = UPower.devices.values[i];

            if (device.isLaptopBattery)
                return device;
        }

        return null;
    }

    readonly property int powerProfile: PowerProfiles.profile
    readonly property string powerProfileName: {
        return PowerProfile.toString(powerProfile);
    }
    readonly property bool hasPerformanceProfile: PowerProfiles.hasPerformanceProfile

    function setProfile(profile: int) {
        PowerProfiles.profile = profile
    }

    function setProfilePowerSaver() {
        setProfile(PowerProfile.PowerSaver)
    }

    function setProfileBalanced() {
        setProfile(PowerProfile.Balanced)
    }

    function setProfilePerformance() {
        setProfile(PowerProfile.Performance)
    }

    function cyclePowerProfile() {
        if (PowerProfiles.profile === PowerProfile.PowerSaver) {
            PowerProfiles.profile = PowerProfile.Balanced;
        } else if (PowerProfiles.profile === PowerProfile.Balanced && PowerProfiles.hasPerformanceProfile) {
            PowerProfiles.profile = PowerProfile.Performance;
        } else if ((PowerProfiles.profile === PowerProfile.Balanced && !PowerProfiles.hasPerformanceProfile) || powerProfile === PowerProfile.Performance) {
            PowerProfiles.profile = PowerProfile.PowerSaver;
        }
    }

    property real secondsToEmpty: battery?.timeToEmpty || 0
    property string timeToEmptyString: UtilsJS.formatSeconds(secondsToEmpty, true)
    property bool isCharging: secondsToEmpty === 0
    property real powerRate: battery?.changeRate || 0
}
