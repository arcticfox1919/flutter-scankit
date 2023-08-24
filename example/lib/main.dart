import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_easy_permission/easy_permissions.dart';
import 'package:flutter_scankit/flutter_scankit.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'customized_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('ScanKit Example'),
          ),
          body: Home()),
    );
  }
}

const _permissions = const [
  Permissions.READ_EXTERNAL_STORAGE,
  Permissions.CAMERA
];

const _permissionGroup = const [PermissionGroup.Camera, PermissionGroup.Photos];

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late bool isCustom;
  late FlutterScankit scanKit;

  String code = "";

  @override
  void initState() {
    super.initState();
    scanKit = FlutterScankit();
    scanKit.addResultListen((val) {
      debugPrint("scanning result:$val");
      setState(() {
        code = val;
      });
    });

    FlutterEasyPermission().addPermissionCallback(
        onGranted: (requestCode, perms, perm) {
          isCustom ? newPage(context) : startScan();
        },
        onDenied: (requestCode, perms, perm, isPermanent) {});
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

  Future<void> newPage(BuildContext context) async {
    var code = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return CustomizedView();
    }));

    setState(() {
      this.code = code ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(code),
          SizedBox(
            height: 32,
          ),
          ElevatedButton(
            child: Text("Scan code"),
            onPressed: () async {
              isCustom = false;
              if (!await FlutterEasyPermission.has(
                  perms: _permissions, permsGroup: _permissionGroup)) {
                FlutterEasyPermission.request(
                    perms: _permissions, permsGroup: _permissionGroup);
              } else {
                startScan();
              }
            },
          ),
          ElevatedButton(
            child: Text("Customized"),
            onPressed: () async {
              isCustom = true;
              if (!await FlutterEasyPermission.has(
                  perms: _permissions, permsGroup: _permissionGroup)) {
                FlutterEasyPermission.request(
                    perms: _permissions, permsGroup: _permissionGroup);
              } else {
                newPage(context);
              }
            },
          ),
          ElevatedButton(
            child: Text("ScanImage from flutter"),
            onPressed: () async {
              isCustom = false;
              if (!await FlutterEasyPermission.has(
                  perms: _permissions, permsGroup: _permissionGroup)) {
                FlutterEasyPermission.request(
                    perms: _permissions, permsGroup: _permissionGroup);
              } else {
                pickAssetsAndScan();
              }
            },
          )
        ],
      ),
    );
  }

  void pickAssetsAndScan() async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        maxAssets: 1,
      ),
    );
    if (result != null) {
      final file = await result.first.file;
      if (file == null) {
        throw StateError(
            'Unable to obtain file of the entity ${result.first.id}.');
      }
      FlutterScankit().scanImage(path: file.path, scanTypes: [
        ScanTypes.ALL
      ]).then((String? value) => {
            setState(() {
              code = value ?? "未识别到";
            })
          });
    }
  }
}
