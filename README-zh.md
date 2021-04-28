# flutter_scankit

中文文档 | [English](README.md)

这是一个扫码的Flutter插件，它是[HUAWEI ScanKit](https://developer.huawei.com/consumer/cn/doc/development/HMSCore-Guides-V5/service-introduction-0000001050041994-V5) SDK的Flutter包。HUAWEI ScanKit 是一个强大的库，使用简单，对于模糊污损码识别率高，识码速度超快。

> 得益于华为在计算机视觉领域能力的积累，Scan Kit可以实现远距离码或小型码的检测和自动放大，同时针对常见复杂扫码场景（如反光、暗光、污损、模糊、柱面）做了针对性识别优化，提升扫码成功率与用户体验。

- [x] Android
- [x] iOS

## 扫码

>   Scan Kit支持扫描13种全球主流的码制式。如果您的应用只处理部分特定的码制式，您也可以在接口中指定制式以便加快扫码速度。已支持的码制式：
>
>   - 一维码：EAN-8、EAN-13、UPC-A、UPC-E、Codabar、Code 39、Code 93、Code 128、ITF-14
>   - 二维码：QR Code、Data Matrix、PDF417、Aztec

支持相机扫码和本地图片码识别。


![](https://gitee.com/arcticfox1919/ImageHosting/raw/master/img/ScanScreenshot20210428.gif)


## 用法

1. 配置权限
2. 处理权限请求
3. 调用API

### 配置权限

#### iOS

将以下内容添加到`ios/Runner/Info.plist`中

```xml
    <key>NSCameraUsageDescription</key>
    <string>在此向用户解释你为什么需要这个权限</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>在此向用户解释你为什么需要这个权限</string>
```

注意，替换`<string></string>`标签的内容，给用户一个需要该权限的理由。

安卓平台不需要配置！

### 权限请求

在Flutter中，你需要一个插件库来处理权限，这里推荐我的另一个插件库：[flutter_easy_permission](https://pub.dev/packages/flutter_easy_permission)，详细配置请看 [这里](https://github.com/arcticfox1919/flutter_easy_permission)。

打开`ios/Podfile`文件，添加如下配置：

```
target 'Runner' do
  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  # Add the library of permissions you need here
  pod 'LBXPermission/Camera'
  pod 'LBXPermission/Photo'
end
```

然后执行命令进行安装。

### 调用API

```dart
  void initState() {
    super.initState();
    scanKit = FlutterScankit()
	 ..addResultListen((val) {
	  // 返回识别结果
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
    // 如果没有权限则请求
    if (!await FlutterEasyPermission.has(perms: _permissions,permsGroup: _permissionGroup)) {
          FlutterEasyPermission.request(perms: _permissions,permsGroup: _permissionGroup);
    } else {
          // 有权限则调用
          startScan();
    }
    
    
Future<void> startScan() async {
    try {
      await scanKit.startScan(scanTypes: [ScanTypes.ALL]);
    } on PlatformException {}
}
```

关于 `FlutterEasyPermission`的用法，请查看[这里](https://github.com/arcticfox1919/flutter_easy_permission) 。

## 例子

**一个完整的例子，请看 [这里](https://github.com/arcticfox1919/flutter-scankit/blob/main/example/lib/main.dart)。**

