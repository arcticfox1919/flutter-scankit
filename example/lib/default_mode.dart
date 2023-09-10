
import 'package:flutter/material.dart';
import 'package:flutter_easy_permission/flutter_easy_permission.dart';
import 'package:flutter_scankit/flutter_scankit.dart';

import 'constants.dart';

class DefaultMode extends StatefulWidget {
  const DefaultMode({Key? key}) : super(key: key);

  @override
  State<DefaultMode> createState() => _DefaultModeState();
}

class _DefaultModeState extends State<DefaultMode> {
  ScanKit? scanKit;
  String code = "";

  @override
  void initState() {
    super.initState();
    scanKit = ScanKit(errorCheck: true,photoMode: true);
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

  @override
  void dispose() {
    scanKit?.dispose();
    super.dispose();
  }

  Future<void> startScan() async {
    try {
      await scanKit?.startScan();
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(code,maxLines: 2,),
            const SizedBox(height: 16,),
            ElevatedButton(
              child: Text("Scan Code"),
              onPressed: () async {
                if (!await FlutterEasyPermission.has(perms: permissions,permsGroup: permissionGroup)) {
                  FlutterEasyPermission.request(perms: permissions,permsGroup: permissionGroup);
                } else {
                  startScan();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
