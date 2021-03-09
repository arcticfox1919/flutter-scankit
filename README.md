# flutter_scankit

A scan code Flutter plugin, which is a Flutter package for [HUAWEI Scan Kit](https://developer.huawei.com/consumer/en/doc/development/HMSCore-Guides-V5/service-introduction-0000001050041994-V5) SDK.

- [x]  Android
- [ ]  iOS





## Example

```dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_easy_permission/easy_permissions.dart';
import 'package:flutter_scankit/flutter_scankit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

const needPermissions = const [
  Permissions.READ_EXTERNAL_STORAGE,
  Permissions.CAMERA
];

class _MyAppState extends State<MyApp> {
  FlutterScankit scanKit;

  String code = "";

  @override
  void initState() {
    super.initState();
    scanKit = FlutterScankit();
    scanKit.addResultListen((val) {
      debugPrint("scanning result:$val");
      setState(() {
        code = val??"";
      });
    });

    FlutterEasyPermission().addPermissionCallback(
        onGranted: (requestCode, perms) {
          startScan();
        },
        onDenied: (requestCode, perms, isPermanentlyDenied) {});
  }

  @override
  void dispose() {
    scanKit.dispose();
    super.dispose();
  }

  Future<void> startScan() async {
    try {
      await scanKit.startScan(scanTypes: [ScanTypes.ALL]);
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(code),
              SizedBox(height: 32,),
              ElevatedButton(
                child: Text("扫一扫"),
                onPressed: () async {
                  if (!await FlutterEasyPermission.has(needPermissions)) {
                    FlutterEasyPermission.request(needPermissions);
                  } else {
                    startScan();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
```

