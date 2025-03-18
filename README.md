# MQTT Sink Agent
The repository contains application on flutter, demonstrates the capabilities of the previously implemented MQTT client ((https://github.com/mk590901/MQTT-Client-Dart-Flutter repository)) for sending files to the other client via cloud MQTT broker.

## Introduction
The application extends the capabilities of the prototype (https://github.com/mk590901/MQTT-Agent-Dart-Flutter), allowing you to send a file or a group of files to a desktop or mobile device, having previously split them into pieces. This allows you to bypass the fundamental limitation of MQTT on the size of the data packet being sent.

## Implementation
I'll not repeat the story about HSM and its implementation, which are the basis of the application. Those who wish can refer to the repositories indicated by the links. In essence, this application repeats the https://github.com/mk590901/MQTT-Agent-Dart-Flutter application, but with one significant addition: it allows you to select and send a group of files to an side client, and not a test data string.

Conventionally, the application consists of two parts, which will be described below, but first some significant, but unpleasant moment will be highlighted:

### MQTT Limitations
A feature of __MQTT__ is the limited size of the transmitted data packet. Theoretically, it is equal to __256M__, but a real broker can provide the user from __64K to 1M__. Therefore, files need to be divided into pieces when sending, and assembly and restoration should be performed on the desktop. More details below.

### Infrastructure
File division is performed in the __Slicer__ class before sending to the cloud. Data chunks of a given size are sent (in this case, it is __2048__ bytes - the size can be changed), converted into __json__ format strings with a header indicating the size and number of the packet and the actual data converted into __base64__ strings.

### GUI
I've implement a __GUI__, which should then be included in the HSM editor with minimal changes. This is a compact __FileTreeWidget__ _stateless wigget_ with two __BLoC__ elements: __FileTreeBloc__ - selecting files to send and __TaskBloc__ - for initiating, executing and completing the operation for sending files.

### Permissions
The files that I want to send are in the public Documents folder. Accordingly, the application must have permission to access files in public folders, and secondly, it must request permission for this access and grant it in app. All these mechanics are implemented in the https://github.com/mk590901/external_storage_permission project, as well as in the __HSM__ editor. In this project, I decided not to bother myself with extra work and just allow access to files manually through app settings. I will only note that this solution will work on Android mobile devices up to and including version __14__, and in __Android 15__ enthusiasts will be disappointed and will have to add permission requests to the application. Below is a separate section dedicated to this issue (pay attention on appendix).

## Movie I. Demo Client on a mobile device

https://github.com/user-attachments/assets/8f5f1fc1-1ab3-47a4-80e9-998a6eedac47

## Movie II. Client on a desktop

[mqtt_node.webm](https://github.com/user-attachments/assets/e44a8ec1-bbd1-46c0-a12e-f9c455127566)

## Movie III. Client page in the editor.

https://github.com/user-attachments/assets/27740ba4-7d2c-48bd-bf7f-dc91084b8185

## Appendix. Access to public folders

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
