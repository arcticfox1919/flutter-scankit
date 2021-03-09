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

const needPermissions = const [Permissions.READ_EXTERNAL_STORAGE,Permissions.CAMERA];

class _MyAppState extends State<MyApp> {

  FlutterScankit scankit;

  @override
  void initState() {
    super.initState();
    scankit = FlutterScankit();
    scankit.addResultListen((val) {
      debugPrint("scanning result:$val");
    });
    FlutterEasyPermission.addPermissionCallback(
        onGranted: (requestCode,perms){
          startScan();
        },
        onDenied: (requestCode,perms,isPermanentlyDenied){

        });
  }

  @override
  void dispose(){
    scankit.dispose();
    super.dispose();
  }

  Future<void> startScan() async {
    try {
      await scankit.startScan(scanTypes: [ScanTypes.ALL]);
    } on PlatformException {
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text("扫一扫"),
            onPressed: () async{
              if(!await FlutterEasyPermission.has(needPermissions)){
                FlutterEasyPermission.request(needPermissions);
              }else{
                startScan();
              }
            },
          ),
        ),
      ),
    );
  }
}
