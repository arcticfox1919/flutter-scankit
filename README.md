## Update
* 修复iOS X 闪退问题

## Note
ScanKit iOS SDK does not support armv7, only arm64, so you need to configure it in Xcode, see [here](https://github.com/arcticfox1919/flutter-scankit/issues/13).

------

# flutter_scankit

[中文文档](README-zh.md) | English

A scan code Flutter plugin, which is a Flutter package for [HUAWEI ScanKit](https://developer.huawei.com/consumer/en/doc/development/HMSCore-Guides-V5/service-introduction-0000001050041994-V5) SDK.The HUAWEI ScanKit is a powerful library that is easy to use and fast to read.

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
  void initState() {
    super.initState();
    scanKit = FlutterScankit()
	 ..addResultListen((val) {
	  // Back to the results
      debugPrint("scanning result:$val");
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
      await scanKit.startScan(scanTypes: [ScanTypes.ALL]);
    } on PlatformException {}
}
```

For the usage of `FlutterEasyPermission` please check  [here](https://github.com/arcticfox1919/flutter_easy_permission) .

## Custom view

Use `ScanKitWidget` as a scan widget, `ScanKitController` for flash switching, picture code recognition and other functions

```dart
class _CustomizedViewState extends State<CustomizedView> {
  late ScanKitController _controller;

  final screenWidth = window.physicalSize.width;
  final screenHeight = window.physicalSize.height;
  
  @override
  void dispose(){
    _controller.dispose();
   super.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
    var pixelSize = boxSize * window.devicePixelRatio;
    var left = screenWidth/2 - pixelSize/2;
    var top = screenHeight/2 - pixelSize/2;
    var right = screenWidth/2 + pixelSize/2;
    var bottom = screenHeight/2 + pixelSize/2;
    var rect = Rect.fromLTRB(left, top, right, bottom);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ScanKitWidget(
                callback: (controller) {
                  _controller = controller;

                  controller.onResult.listen((result) {
                    debugPrint("scanning result:$result");

                    Navigator.of(context).pop(result);
                  });
                },
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

## Example

**For a complete example, please see [here](https://github.com/arcticfox1919/flutter-scankit/blob/main/example/lib/main.dart).**

