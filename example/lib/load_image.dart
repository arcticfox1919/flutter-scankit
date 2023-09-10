
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scankit/flutter_scankit.dart';

class LoadImage extends StatefulWidget {
  const LoadImage({Key? key}) : super(key: key);

  @override
  State<LoadImage> createState() => _LoadImageState();
}

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
