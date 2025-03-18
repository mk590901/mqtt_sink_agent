# MQTT Sink Agent

The repository contains application on flutter, demonstrates the capabilities of the previously implemented MQTT client ((https://github.com/mk590901/MQTT-Client-Dart-Flutter repository)) for sending files to the other client via cloud MQTT broker.

## Introduction

The application extends the capabilities of the prototype (https://github.com/mk590901/MQTT-Agent-Dart-Flutter), allowing you to send a file or a group of files to a desktop or mobile device, having previously split them into pieces. This allows you to bypass the fundamental limitation of MQTT on the size of the data packet being sent.

## Notes

### Access to public folders

Starting with Android 15, apps installed from third-party sources (called "sideloaded apps") are restricted from automatically granting some "sensitive" permissions. These permissions are listed under "Restricted Settings" and are blocked by default by the system for such apps. Instead of allowing the user to manually enable these permissions through the settings, Android 15 requires each such permission to be enabled individually through a special approval process. This is done to reduce the risk of accidentally granting dangerous permissions to questionable apps.

The main reasons for these changes are:

Security and privacy: Google aims to minimize the possibility of exploiting permissions such as access to Notification Listener, Accessibility Services, or other features that could be used by malware to track or control the device.

Strengthening control over third-party installations: Unlike apps from the Play Store, which are verified, sideloaded apps do not have the same level of trust. Therefore, the system complicates the process of granting permissions by requiring conscious confirmation from the user.

Enhanced Confirmation Mode: Android 15 introduced the "Enhanced Confirmation Mode" feature, which checks apps against a system allowlist. If the app is not on this list, some permissions remain unavailable for activation through the standard settings.

How it works in practice:

When installing an APK file, the system determines that the app is sideloaded and automatically restricts access to certain permissions.
If an app requests such permissions, the user will see a message like: "For your security, this setting is currently unavailable."

To enable such permissions, you either need to use the official app stores, or in some cases, the device manufacturer (OEM) or developer may provide a workaround through the system settings, but this is not universal.

So in Android 15, you can't just go to "Settings -> Permissions" and enable all the necessary permissions for a sideloaded app, because Google has intentionally made this process difficult to protect users. This may be inconvenient for those who use third-party apps for legitimate purposes (like beta testing or customization), but it is a tradeoff for security.
