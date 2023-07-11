import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'adb_controller.dart';

void main() async {
  await adb.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Uint8List? _screenshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          const SizedBox(width: 48),
          if (_screenshot != null)
            Image.memory(_screenshot!)
          else
            const Placeholder(),
          const SizedBox(width: 48),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: const Text('Tap at (400, 400)'),
                onPressed: () async {
                  await adb.tap(400, 400);
                  _refresh();
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                child: const Text('Long press at (400, 400)'),
                onPressed: () async {
                  await adb.longPress(400, 400);
                  _refresh();
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                child: const Text('Swipe up 500'),
                onPressed: () async {
                  await adb.swipe(0, -500);
                  _refresh();
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                child: const Text('"back" button'),
                onPressed: () async {
                  await adb.back();
                  _refresh();
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                child: const Text('Print window size'),
                onPressed: () {
                  print(adb.screenSize);
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                child: const Text('Screenshot'),
                onPressed: () async {
                  final pic = await adb.screenshot();
                  setState(() {
                    _screenshot = pic;
                  });
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }

  Future _refresh() async {
    final pic = await adb.screenshot();
    setState(() => _screenshot = pic);
  }
}
