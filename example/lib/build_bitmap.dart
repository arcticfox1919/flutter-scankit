import 'package:flutter/material.dart';
import 'package:flutter_scankit/flutter_scankit.dart';

class BuildBitmap extends StatefulWidget {
  const BuildBitmap({Key? key}) : super(key: key);

  @override
  State<BuildBitmap> createState() => _BuildBitmapState();
}

class _BuildBitmapState extends State<BuildBitmap> {
  final TextEditingController controller = TextEditingController();

  ScanKitEncoder encoder = ScanKitEncoder(200, 200, ScanTypes.qRCode,
      backgroundColor: Colors.blue, color: Colors.red,margin: 2);

  ImageProvider? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _image == null
                  ? const SizedBox(
                      width: 200,
                      height: 200,
                      child: Placeholder(
                        strokeWidth: 1,
                      ))
                  : Image(image: _image!),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: controller,
              ),
              const SizedBox(
                height: 16,
              ),
              OutlinedButton(
                child: Text("Generate"),
                onPressed: () async {
                  generate();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void generate() async {
    if(controller.text.isNotEmpty){
      var bytes = await encoder.encode(controller.text);
      final provider = MemoryImage(bytes);
      setState(() {
        _image = provider;
      });
    }
  }
}
