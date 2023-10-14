
- [flutter\_scankit](#flutter_scankit)
  - [Scanning Barcodes](#scanning-barcodes)
  - [Usage](#usage)
    - [Configure Permissions](#configure-permissions)
      - [iOS](#ios)
    - [Permission Request](#permission-request)
    - [Calling APIs](#calling-apis)
  - [Custom view](#custom-view)
    - [Full Customization](#full-customization)
  - [Creating Code Image](#creating-code-image)
  - [FAQs](#faqs)
    - [Android](#android)
      - [Does the Scan SDK support third-party devices?](#does-the-scan-sdk-support-third-party-devices)
      - [What barcodes can be parsed by the Scan SDK?](#what-barcodes-can-be-parsed-by-the-scan-sdk)
      - [Are the algorithms of different APIs the same?](#are-the-algorithms-of-different-apis-the-same)
      - [Are cloud functions involved?](#are-cloud-functions-involved)
      - [What can I do if a barcode cannot be parsed?](#what-can-i-do-if-a-barcode-cannot-be-parsed)
      - [When a transaction-related app calls the barcode scanning function, private information such as bank card numbers will be targeted. Is the card number storage secure?](#when-a-transaction-related-app-calls-the-barcode-scanning-function-private-information-such-as-bank-card-numbers-will-be-targeted-is-the-card-number-storage-secure)
      - [Why does Scan Kit use the network module?](#why-does-scan-kit-use-the-network-module)
    - [iOS](#ios-1)
      - [From which version does the Scan SDK support iOS?](#from-which-version-does-the-scan-sdk-support-ios)
      - [What barcodes can be parsed by the Scan SDK?](#what-barcodes-can-be-parsed-by-the-scan-sdk-1)
      - [How can I resolve the problem that occurs when I archive and release an iOS app?](#how-can-i-resolve-the-problem-that-occurs-when-i-archive-and-release-an-ios-app)
      - [How can I resolve the problem when error message "Undefined symbols for architecture armv7" is displayed?](#how-can-i-resolve-the-problem-when-error-message-undefined-symbols-for-architecture-armv7-is-displayed)
      - [How can I resolve the problem that the simulator still needs to be used for debugging after the simulator architecture is deleted for the iOS system?](#how-can-i-resolve-the-problem-that-the-simulator-still-needs-to-be-used-for-debugging-after-the-simulator-architecture-is-deleted-for-the-ios-system)
      - [How can I enable the function of automatically managing signing during iOS certificate packaging?](#how-can-i-enable-the-function-of-automatically-managing-signing-during-ios-certificate-packaging)
  - [Appendix](#appendix)
    - [Recommended Settings for Barcode Generation](#recommended-settings-for-barcode-generation)
  - [Example](#example)


------


# flutter_scankit

[中文文档](README-zh.md) | English

A scan code Flutter plugin, which is a Flutter package for [HUAWEI ScanKit](https://developer.huawei.com/consumer/en/doc/development/HMSCore-Guides/service-introduction-0000001050041994) SDK.The HUAWEI ScanKit is a powerful library that is easy to use and fast to read.

> Scan Kit automatically detects, magnifies, and recognizes barcodes from a distance, and is also able to scan a very small barcode in the same way. It works even in suboptimal situations, such as under dim lighting or when the barcode is reflective, dirty, blurry, or printed on a cylindrical surface. This leads to a high scanning success rate, and an improved user experience.

- [x]  Android
- [x]  iOS

## Scanning Barcodes

> ScanKit supports 13 major barcode formats (listed as follows). If your app requires only some of the 13 formats, specify the desired formats to speed up barcode scanning.
>
>- 1D barcode formats: EAN-8, EAN-13, UPC-A, UPC-E, Codabar, Code 39, Code 93, Code 128, and ITF-14
>- 2D barcode formats: QR Code, Data Matrix, PDF417, and Aztec

Support camera scan code and local picture recognition.


![](https://github.com/arcticfox1919/ImageHosting/blob/master/ScanScreenshot20210428.gif?raw=true)


## Usage

1. Configure Permissions
2. Handling permission requests
3. Calling APIs

### Configure Permissions
#### iOS
Add the following to `ios/Runner/Info.plist`

```xml
    <key>NSCameraUsageDescription</key>
    <string>Explain to the user here why you need the permission</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Explain to the user here why you need the permission</string>
```

Note that replacing the content of the <string></string> tag gives the user a reason for needing the permission.

No configuration required for Android platform!

### Permission Request

In Flutter, you need a plugin library for permission handling, here I recommend using another plugin library of mine: [flutter_easy_permission](https://pub.dev/packages/flutter_easy_permission), go [here](https://github.com/arcticfox1919/flutter_easy_permission) for detailed configuration.

Open the ios/Podfile file and add the following code:

```
target 'Runner' do
  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  # Add the library of permissions you need here
  pod 'EasyPermissionX/Camera'
  pod 'EasyPermissionX/Photo'
end
```
Then execute the command to install.

### Calling APIs

```dart
import 'package:flutter_scankit/flutter_scankit.dart';


void initState() {
    super.initState();
    scanKit = ScanKit();
    scanKit!.onResult.listen((val) {
      debugPrint("scanning result:${val.originalValue}  scanType:${val.scanType}");
      setState(() {
        code = val.originalValue;
      });
    });

    FlutterEasyPermission().addPermissionCallback(
        onGranted: (requestCode, perms,perm) {
          startScan();
        },
        onDenied: (requestCode, perms,perm, isPermanent) {});
  }
```

Scan the code:

```dart
    // Request if no permission
    if (!await FlutterEasyPermission.has(perms: _permissions,permsGroup: _permissionGroup)) {
          FlutterEasyPermission.request(perms: _permissions,permsGroup: _permissionGroup);
    } else {
          // Call if you have permission
          startScan();
    }
    
    
Future<void> startScan() async {
    try {
      await scanKit?.startScan();
    } on PlatformException {}
}
```

For instructions on how to use `FlutterEasyPermission`, please refer to [this link](https://github.com/arcticfox1919/flutter_easy_permission).

If we are unsure of the type of  code, we can leave the `scanTypes` parameter unspecified. Of course, you can also choose to specify one or more types, like so:

```dart
await scanKit?.startScan(scanTypes: ScanTypes.qRCode.bit);

await scanKit?.startScan(
    scanTypes: ScanTypes.qRCode.bit |
    ScanTypes.code39.bit |
    ScanTypes.code128.bit);
```

## Custom view

Use `ScanKitWidget` as the scanning widget, and `ScanKitController` for functions such as switching the flashlight and decoding images. The following is just a simple demonstration, you need to customize the UI according to your own needs:

```dart
const boxSize = 200.0;

class CustomView extends StatefulWidget {
  const CustomView({Key? key}) : super(key: key);
  @override
  State<CustomView> createState() => _CustomViewState();
}

class _CustomViewState extends State<CustomView> {
  ScanKitController _controller = ScanKitController();

  @override
  void initState() {
    _controller.onResult.listen((result) {
      debugPrint(
              "scanning result:value=${result.originalValue} scanType=${result.scanType}");

      /// Note: Here the pop operation must be delayed.
      Future(() {
        Navigator.of(context).pop(result.originalValue);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var left = screenWidth / 2 - boxSize / 2;
    var top = screenHeight / 2 - boxSize / 2;
    var rect = Rect.fromLTWH(left, top, boxSize, boxSize);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ScanKitWidget(
                    controller: _controller,
                    continuouslyScan: false,
                    boundingBox: rect),
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          )),
                  IconButton(
                          onPressed: () {
                            _controller.switchLight();
                          },
                          icon: Icon(
                            Icons.lightbulb_outline_rounded,
                            color: Colors.white,
                            size: 28,
                          )),
                  IconButton(
                          onPressed: () {
                            _controller.pickPhoto();
                          },
                          icon: Icon(
                            Icons.picture_in_picture_rounded,
                            color: Colors.white,
                            size: 28,
                          ))
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: boxSize,
                height: boxSize,
                decoration: BoxDecoration(
                  border: Border(
                          left: BorderSide(color: Colors.orangeAccent, width: 2),
                          right: BorderSide(color: Colors.orangeAccent, width: 2),
                          top: BorderSide(color: Colors.orangeAccent, width: 2),
                          bottom: BorderSide(color: Colors.orangeAccent, width: 2)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
```

### Full Customization

We can use `ScanKitDecoder` to achieve more flexible customization of scanning requirements. Here is a simple demonstration combined with the [camera](https://github.com/flutter/packages/tree/main/packages/camera/camera) plugin:

```dart
class _BitmapModeState extends State<BitmapMode> {
  CameraController? controller;
  StreamSubscription? subscription;
  String code = '';
  ScanKitDecoder decoder = ScanKitDecoder(photoMode: false, parseResult: false);

  @override
  void initState() {
    availableCameras().then((val) {
      List<CameraDescription> _cameras = val;
      if (_cameras.isNotEmpty) {
        controller = CameraController(_cameras[0], ResolutionPreset.max);
        controller!.initialize().then((_) {
          if (!mounted) {
            return;
          }
          controller!.startImageStream(onLatestImageAvailable);
          setState(() {});
        });
      }
    });

    subscription = decoder.onResult.listen((event) async{
      if (event is ResultEvent && event.value.isNotEmpty()) {
        subscription!.pause();
        await stopScan();
        if (mounted) {
          setState(() {
            code = event.value.originalValue;
          });
        }
      } else if (event is ZoomEvent) {
        /// set zoom value
      }
    });
    super.initState();
  }

  void onLatestImageAvailable(CameraImage image) async {
    if(image.planes.length == 1 && image.format.group == ImageFormatGroup.bgra8888){
      await decoder.decode(image.planes[0].bytes, image.width, image.height);
    }else if(image.planes.length == 3){
      Uint8List y = image.planes[0].bytes;
      Uint8List u = image.planes[1].bytes;
      Uint8List v = image.planes[2].bytes;

      Uint8List combined = Uint8List(y.length + u.length + v.length);
      combined.setRange(0, y.length, y);
      combined.setRange(y.length, y.length + u.length, u);
      combined.setRange(y.length + u.length, y.length + u.length + v.length, v);
      await decoder.decodeYUV(combined, image.width, image.height);
    }
  }
}
```

You can view the full code in `bitmap_mode.dart`.

Of course, we can also directly read image files and let ScanKit recognize the codes in the images. This requirement is more suitable for custom loading of code maps from the image library:

```dart
class _LoadImageState extends State<LoadImage> {
  ScanKitDecoder decoder = ScanKitDecoder(scanTypes: ScanTypes.qRCode.bit);
  String code = '';

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(code,maxLines: 2,),
      ),
    );
  }

  void load()async{
    var myData = await rootBundle.load('assets/qrcode.png');
    var result = await decoder.decodeImage(myData.buffer.asUint8List());
    if(result.isNotEmpty){
      setState(() {
        code = result.originalValue;
      });
    }
  }
}
```

## Creating Code Image

```dart
  ScanKitEncoder encoder = ScanKitEncoder(200, 200, ScanTypes.qRCode,
      backgroundColor: Colors.blue, color: Colors.red,margin: 2);
  
  ImageProvider? _image;

  void generate() async {
    if(controller.text.isNotEmpty){
      var bytes = await encoder.encode(controller.text);
      final provider = MemoryImage(bytes);
      setState(() {
        _image = provider;
      });
    }
  }
```

For the complete example, see `build_bitmap.dart`. Here, the `margin` parameter defines the border of the code, with a range of [1, 10]. For more information, please refer to the appendix.

## FAQs

### Android
#### Does the Scan SDK support third-party devices?
Yes. Non-Huawei Android phones are supported by Scan SDK 1.1.0.300 and later.

#### What barcodes can be parsed by the Scan SDK?
Currently, the HMS Core Scan SDK can parse most types of 1D and 2D barcodes, including EAN-8, EAN-13, UPC-A, UPC-E, Codabar, Code 39, Code 93, Code 128, ITF-14, QR code, DataMatrix, PDF417, Aztec Code, and the multi-functional code.

#### Are the algorithms of different APIs the same?
The recognition and parsing algorithms of different APIs are the same.

#### Are cloud functions involved?
No cloud function is involved, and no personal data is stored.

#### What can I do if a barcode cannot be parsed?

1. Install HMS Core (APK) 3.0.3 or later.
2. Check whether the camera automatically focuses. If not, blurred images cannot be recognized and parsed.
3. Check whether the format of the scanned 1D or 2D barcode is supported.
4. If the fault persists, [submit a ticket online](https://developer.huawei.com/consumer/en/support/feedback/#/). Huawei will get back to you as soon as possible.

#### When a transaction-related app calls the barcode scanning function, private information such as bank card numbers will be targeted. Is the card number storage secure?
Scan Kit processes data only on devices and does not store any personal data, ensuring the security of private data.

#### Why does Scan Kit use the network module?
The reason can be found in [SDK Privacy Statement](https://developer.huawei.com/consumer/en/doc/development/HMSCore-Guides/sdk-data-security-0000001050043971).



### iOS
#### From which version does the Scan SDK support iOS?
HMS Core Scan SDK 1.2.0.300 and later support phones running iOS 9.0 and later.

#### What barcodes can be parsed by the Scan SDK?
Currently, the HMS Core Scan SDK can parse most of 1D and 2D barcodes, including EAN-8, EAN-13, UPC-A, UPC-E, Codabar, Code 39, Code 93, Code 128, ITF-14, QR code, DataMatrix, PDF417, and Aztec Code.

#### How can I resolve the problem that occurs when I archive and release an iOS app?
The SDK can run properly, but the error message "Unsupported Architecture. Your executable contains unsupported architecture '[x86_64]..." is displayed when an iOS app is released.

To facilitate debugging, **ScanKitFrameWork.framework** combines simulator and real device architectures. Before the release, use the lipo tool to remove the related architectures. For details, please refer to the following code:

```
cd ScanKitFrameWork.framework
# Run the lipo -info command to check the included architectures.
lipo -info ScanKitFrameWork  # Architectures in the fat file: ScanKitFrameWork are: x86_64 arm64
# Remove x86_64.
lipo -remove x86_64 ScanKitFrameWork -o ScanKitFrameWork
# Check again.
lipo -info  ScanKitFrameWork # Architectures in the fat file: ScanKitFrameWork are: arm64
```

#### How can I resolve the problem when error message "Undefined symbols for architecture armv7" is displayed?

The Scan SDK integrated in the iOS system does not support the ARMv7 architecture. Therefore, the ARMv7 architecture needs to be removed from the development project.

#### How can I resolve the problem that the simulator still needs to be used for debugging after the simulator architecture is deleted for the iOS system?
Integrate the SDK that contains the simulator architecture again. For details, please refer to [Integrating the HMS Core SDK](https://developer.huawei.com/consumer/en/doc/development/HMSCore-Guides/ios-integrating-sdk-0000001050172400).

## Appendix

### Recommended Settings for Barcode Generation

- Recommended barcode color and background

  It is recommended that the default setting (black barcode against white background) be used. If white barcode against black background is used, the recognition success rate will decrease.

- Recommended border

  It is recommended that the default border be used. The value ranges from 1 to 10, in pixels.

- Recommended barcode size

  1. For the QR code, DataMatrix, and Aztec, it is recommended that the width and height be the same and greater than 200. Otherwise, the barcodes generated will be too small to be recognized.
  2. For EAN-8, EAN-13, UPC-A, UPC-E, Codabar, Code 39, Code 93, Code 128, ITF-14, and PDF417, it is recommended that the ratio of width to height be 2:1 and the width be greater than 400. Otherwise, the barcodes generated will be too small to be recognized.

- Barcode length and content restrictions

| **Barcode Format** | **Length Restriction**                                       | Content Restriction                                          |
| ------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| QR                 | A maximum of 2953 UTF-8 encoded bytes are supported.         | Chinese characters are supported. One Chinese character occupies three bytes. If the content is too long, the barcode will be complex and cannot be easily recognized. |
| Aztec              | A maximum of 2953 UTF-8 encoded bytes are supported.         | Chinese characters are supported. One Chinese character occupies three bytes. If the content is too long, the barcode will be complex and cannot be easily recognized. |
| PDF417             | A maximum of 1777 UTF-8 encoded bytes are supported.         | Chinese characters are supported. One Chinese character occupies three bytes. If the content is too long, the barcode will be complex and cannot be easily recognized. |
| DataMatrix         | A maximum of 2335 UTF-8 encoded bytes are supported.         | iOS supports Chinese and English, in which one Chinese character occupies three bytes. Android supports only English. If the content is too long, the barcode will be complex and cannot be easily recognized. |
| UPC-A              | An 11-digit number must be entered.                          | Only numbers are supported. A barcode in this format is a 12-digit number (with the last digit used for verification). |
| UPC-E              | A 7-digit number must be entered.                            | Only numbers are supported. A barcode in this format is an 8-digit number (with the last digit used for verification), and the first digit must be 0 or 1. |
| ITF14              | A number with up to 80 digits is allowed and must contain an even number of digits. | Only numbers are supported. A barcode containing an even number of digits is generated. If the content is too long, the barcode will be complex and cannot be easily recognized. |
| EAN-8              | A 7-digit number must be entered.                            | Only numbers are supported. A barcode in this format is an 8-digit number (with the last digit used for verification). |
| EAN-13             | A 12-digit number must be entered.                           | Only numbers are supported. A barcode in this format is a 13-digit number (with the last digit used for verification), and the first digit cannot be 0. If the first digit is not 0 for Android, a UPC-A code is generated. |
| Code 39            | A maximum of 80 bytes are supported.                         | The charset supported contains numbers, uppercase letters, hyphens (-), dots (.), dollar signs ($), slashes (/), plus signs (+), percent signs (%), and spaces. |
| Code 93            | A maximum of 80 bytes are supported.                         | The charset supported contains numbers, uppercase letters, hyphens (-), dots (.), dollar signs ($), slashes (/), plus signs (+), percent signs (%), asterisks (*), and spaces. |
| Code 128           | A maximum of 80 bytes are supported.                         | The charset supported is the same as that in the encoding table. |
| Codabar            | A maximum of 2953 UTF-8 encoded bytes are supported.         | If a barcode in this format starts with letter A, B, C, D, T, N, or E, or with an asterisk (*), the barcode must end with the same character. If the barcode does not start with any of the characters, add letter A to the beginning and end of the barcode. Other characters in the barcode can be numbers, hyphens (-), dots (.), dollar signs ($), slashes (/), colons (:), and plus signs (+). |



## Example

**For a complete example, please see [here](https://github.com/arcticfox1919/flutter-scankit/blob/main/example/lib/main.dart).**

