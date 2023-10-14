- [flutter\_scankit](#flutter_scankit)
  - [扫码](#扫码)
  - [简单用法](#简单用法)
    - [配置权限](#配置权限)
      - [iOS](#ios)
    - [权限请求](#权限请求)
    - [调用API](#调用api)
  - [自定义视图](#自定义视图)
    - [完全自定义](#完全自定义)
  - [生成码图](#生成码图)
  - [FAQ](#faq)
    - [Android](#android)
      - [统一扫码服务SDK是否支持第三方设备？](#统一扫码服务sdk是否支持第三方设备)
      - [统一扫码服务SDK能够实现哪些条码的解析？](#统一扫码服务sdk能够实现哪些条码的解析)
      - [不同的API间算法是否相同？](#不同的api间算法是否相同)
      - [是否涉及云端的功能？](#是否涉及云端的功能)
      - [无法实现条码解析怎么办？](#无法实现条码解析怎么办)
      - [与交易相关的应用调用扫码功能时，会对准银行卡号等私密信息，卡号存储是否安全？](#与交易相关的应用调用扫码功能时会对准银行卡号等私密信息卡号存储是否安全)
      - [Scan Kit为什么会用到网络模块？](#scan-kit为什么会用到网络模块)
    - [iOS](#ios-1)
      - [统一扫码服务SDK从哪个版本开始支持iOS？](#统一扫码服务sdk从哪个版本开始支持ios)
      - [统一扫码服务SDK能够实现哪些条码的解析？](#统一扫码服务sdk能够实现哪些条码的解析-1)
      - [如何解决iOS打包上架问题？](#如何解决ios打包上架问题)
      - [如何解决iOS提示“Undefined symbols for architecture armv7”报错信息问题？](#如何解决ios提示undefined-symbols-for-architecture-armv7报错信息问题)
      - [iOS证书打包时，如何开启Automatically manage signing？](#ios证书打包时如何开启automatically-manage-signing)
  - [附录](#附录)
    - [生成码参数建议](#生成码参数建议)
  - [博客](#博客)
  - [例子](#例子)


------

# flutter_scankit

中文文档 | [English](README.md)

这是一个扫码的Flutter插件，它是[HUAWEI ScanKit](https://developer.huawei.com/consumer/cn/doc/development/HMSCore-Guides/service-introduction-0000001050041994) SDK的Flutter包。HUAWEI ScanKit 是一个强大的库，使用简单，对于模糊污损码识别率高，识码速度超快。

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


## 简单用法

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
  pod 'EasyPermissionX/Camera'
  pod 'EasyPermissionX/Photo'
end
```

然后执行命令进行安装。

### 调用API

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
    // 如果没有权限则请求
    if (!await FlutterEasyPermission.has(perms: _permissions,permsGroup: _permissionGroup)) {
          FlutterEasyPermission.request(perms: _permissions,permsGroup: _permissionGroup);
    } else {
          // 有权限则调用
          startScan();
    }
    
Future<void> startScan() async {
    try {
      await scanKit?.startScan();
    } on PlatformException {}
}
```

关于 `FlutterEasyPermission`的用法，请查看[这里](https://github.com/arcticfox1919/flutter_easy_permission) 。

如果我们不确定码图的类型，可以不指定`scanTypes`参数，当然 ，你也可以指定一种或多种类型，像这样：

```dart
await scanKit?.startScan(scanTypes: ScanTypes.qRCode.bit);

await scanKit?.startScan(
    scanTypes: ScanTypes.qRCode.bit |
    ScanTypes.code39.bit |
    ScanTypes.code128.bit);
```

## 自定义视图

使用`ScanKitWidget`作为扫码控件，`ScanKitController`用于闪光灯切换、图片识码等功能，以下只是一个简单的演示，你需要根据自己的需求来自定义UI：

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

###  完全自定义

我们可以使用`ScanKitDecoder`实现更加灵活的自定义扫码需求。这里是一个结合[camera](https://github.com/flutter/packages/tree/main/packages/camera/camera)插件的简单演示：
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

完整代码查看`bitmap_mode.dart`

当然，我们也可以直接读取图片文件，交给ScanKit来识别图中的码。此需求更适合自定义加载图库中的码图：

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



## 生成码图

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

完整示例，见`build_bitmap.dart`。此处`margin`参数为码边框，取值为[1, 10]，更多信息请参考附录。



## FAQ

### Android

#### 统一扫码服务SDK是否支持第三方设备？

支持。统一扫码服务SDK从1.1.0.300版本开始支持非华为Android手机。

#### 统一扫码服务SDK能够实现哪些条码的解析？

Scan SDK能实现一维码、二维码和自定义码类型的解析，目前支持EAN-8、EAN-13、UPC-A、UPC-E、Codabar、Code 39、Code 93、Code 128、ITF14、QR、DataMatrix、PDF417、Aztec、多功能码格式条码的解析。


#### 不同的API间算法是否相同？
不同API的识别和解码算法相同。

#### 是否涉及云端的功能？
不涉及云端功能，不保存任何个人数据。

#### 无法实现条码解析怎么办？

1. 您需要安装3.0.3及以上版本的HMS Core（APK）。
2. 查看相机是否自动聚焦，对于模糊的图像，会因为无法自动聚焦而导致无法识别、解析结果。
3. 检查一下所扫的码是否在支持的一维码或二维码范围内。
4. 如还未解决，请通过[在线提单](https://developer.huawei.com/consumer/cn/support/feedback/#/)提交问题，华为支持人员会及时处理。

#### 与交易相关的应用调用扫码功能时，会对准银行卡号等私密信息，卡号存储是否安全？
华为Scan Kit数据纯端侧处理，不会保存任何个人数据，保障私密信息的安全性。

#### Scan Kit为什么会用到网络模块？
我们已经在SDK数据安全中进行了说明，详细可参见[SDK隐私声明](https://developer.huawei.com/consumer/cn/doc/development/HMSCore-Guides/sdk-data-security-0000001050043971)。



### iOS

#### 统一扫码服务SDK从哪个版本开始支持iOS？

1.2.0.300版本开始支持iOS 9.0版本以上的手机。

#### 统一扫码服务SDK能够实现哪些条码的解析？

Scan SDK能实现多种一维码和二维码类型的解析，目前支持EAN-8、EAN-13、UPC-A、UPC-E、Codabar、Code 39、Code 93、Code 128、ITF14、QR、DataMatrix、PDF417、Aztec格式条码的解析。

#### 如何解决iOS打包上架问题？

SDK直接运行无问题，但发布时报错“Unsupported Architecture. Your executable contains unsupported architecture '[x86_64]...”。

为了方便您调试，ScanKitFrameWork.framework合并了模拟器和真机架构，上线前，使用lipo工具移除相关架构即可，参考：

```
cd ScanKitFrameWork.framework
# 使用lipo -info 可以查看包含的架构
lipo -info ScanKitFrameWork  # Architectures in the fat file: ScanKitFrameWork are: x86_64 arm64
# 移除x86_64
lipo -remove x86_64 ScanKitFrameWork -o ScanKitFrameWork
# 再次查看
lipo -info  ScanKitFrameWork # Architectures in the fat file: ScanKitFrameWork are: arm64
```

#### 如何解决iOS提示“Undefined symbols for architecture armv7”报错信息问题？

iOS系统集成统一扫码服务SDK不支持armv7架构，需要在开发工程中去掉armv7。

##  附录
### 生成码参数建议
- 码图颜色和背景建议
  建议使用默认背景：白色背景，黑色码图。如果使用反色会影响识别率。

- 码图边框建议
  建议使用默认边框，单位为像素，取值范围为[1, 10]。

- 码图大小建议
  1. 生成QR、DataMatrix、Aztec制式的码，建议输入的width和height相同，并且大于200，否则生成的码过小会影响识别。
  2. 生成EAN-8、EAN-13、UPC-A、UPC-E、Codabar、Code 39、Code 93、Code 128、ITF14、PDF417制式的码，建议输入的width和height比例在2:1，并且width要大于400，否则生成的码过小影响识别。

- 长度和内容限制参考如下表格：


| 码类型     | 长度                                   | 内容                                                         |
| ---------- | -------------------------------------- | ------------------------------------------------------------ |
| QR         | 最长支持2953个UTF-8编码字节            | 支持中文，1个中文字占用3个字节，如果内容过长会导致码复杂，影响识别。 |
| Aztec      | 最长支持2953个UTF-8编码字节            | 支持中文，1个中文字占用3个字节，如果内容过长会导致码复杂，影响识别。 |
| PDF417     | 最长支持1777个UTF-8编码字节            | 支持中文，1个中文字占用3个字节，如果内容过长会导致码复杂，影响识别。 |
| DataMatrix | 最长支持2335个UTF-8编码字节            | iOS支持中英文，1个中文字占用3个字节，Android只支持英文，如果内容过长会导致码复杂，影响识别。 |
| UPC-A      | 支持11位数字输入                       | 只支持数字，生成包含12位数字的码图，包含最后一位校验数字。   |
| UPC-E      | 支持7位数字输入                        | 只支持数字，首位需要是0或1，生成包含8位数字的码图，包含最后一位校验数字。 |
| ITF14      | 支持80位以内数字输入，并且需要是偶数位 | 只支持数字，生成包含偶数位数字的码图，如果内容过长会导致码复杂，影响识别。 |
| EAN-8      | 支持7位数字输入                        | 只支持数字，生成包含8位数字的码图，包含最后一位校验数字。    |
| EAN-13     | 支持12位数字输入                       | 只支持数字，首位不可以是0，生成包含13位数字的码图，包含最后一位校验数字。Android端首位如果不是0则生成UPC-A码。 |
| Code 39    | 最长支持80字节长度                     | 字符集可以是数字、大写字母和- . $ / + % SPACE英文格式符号。  |
| Code 93    | 最长支持80字节长度                     | 字符集可以是数字、大写字母和- . $ / + % * SPACE英文格式符号。 |
| Code 128   | 最长支持80字节长度                     | 字符集是编码表中的字符集。                                   |
| Codabar    | 最长支持2953个UTF-8编码字节            | 开头如果是ABCDTN*E字符，结尾也要是相应字符，如果不是上述字符，则默认添加A到码值的开头和结尾。其他字符可以是数字和- . $ / : +英文格式符号。 |




## 博客

关于插件使用，可以参考我的两篇博客：


[《Flutter 最佳扫码插件》](https://arcticfox.blog.csdn.net/article/details/116238958)


[《Flutter 最佳扫码插件——自定义视图》](https://arcticfox.blog.csdn.net/article/details/120261000)


## 例子

**一个完整的例子，请看 [这里](https://github.com/arcticfox1919/flutter-scankit/blob/main/example/lib/main.dart)。**

