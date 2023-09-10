import 'package:flutter/material.dart';
import 'package:flutter_scankit_example/bitmap_mode.dart';
import 'package:flutter_scankit_example/build_bitmap.dart';
import 'package:flutter_scankit_example/default_mode.dart';

import 'customized_mode.dart';

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
          body: Home()
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            child: Text("Default Mode"),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return DefaultMode();
                  }
              ));
            },
          ),
          ElevatedButton(
            child: Text("Customized Mode"),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return CustomizedMode();
                  }
              ));
            },
          ),
          ElevatedButton(
            child: Text("Bitmap Mode"),
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return BitmapMode();
                  }
              ));
            },
          ),
          ElevatedButton(
            child: Text("Generate Bitmap"),
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return BuildBitmap();
                  }
              ));
            },
          ),
        ],
      ),
    );
  }
}

