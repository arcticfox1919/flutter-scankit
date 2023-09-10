import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easy_permission/flutter_easy_permission.dart';
import 'package:flutter_scankit/flutter_scankit.dart';

import 'constants.dart';

class CustomizedMode extends StatefulWidget {
  @override
  _CustomizedModeState createState() => _CustomizedModeState();
}

class _CustomizedModeState extends State<CustomizedMode> {
  String code = "";

  @override
  void initState() {
    super.initState();
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
            Text(
              code,
              maxLines: 2,
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
                child: Text("Scan Code"),
                onPressed: () async {
                  if (!await FlutterEasyPermission.has(
                      perms: permissions, permsGroup: permissionGroup)) {
                    FlutterEasyPermission.request(
                        perms: permissions, permsGroup: permissionGroup);
                  } else {
                    var result = await Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return CustomView();
                    }));

                    setState(() {
                      code = result ?? '';
                    });
                  }
                }),
          ],
        ),
      ),
    );
  }
}

const boxSize = 200.0;

class CustomView extends StatefulWidget {
  const CustomView({Key? key}) : super(key: key);

  @override
  State<CustomView> createState() => _CustomViewState();
}

class _CustomViewState extends State<CustomView> {
  ScanKitController _controller = ScanKitController();

  final screenWidth = window.physicalSize.width;
  final screenHeight = window.physicalSize.height;

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
    var pixelSize = boxSize * window.devicePixelRatio;
    var left = screenWidth / 2 - pixelSize / 2;
    var top = screenHeight / 2 - pixelSize / 2;
    var right = screenWidth / 2 + pixelSize / 2;
    var bottom = screenHeight / 2 + pixelSize / 2;
    var rect = Rect.fromLTRB(left, top, right, bottom);

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
