import 'package:flutter/material.dart';
import 'package:volume_watcher/volume_watcher.dart';

void main() => runApp(MainApp());

class MainApp extends StatefulWidget {
  MainApp({Key key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  int tabIdx = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          bottom: TabBar(
            controller: controller,
            tabs: <Widget>[
              Tab(
                text: "Volume",
              ),
              Tab(
                text: "Empty",
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            VolumePage(),
            Scaffold(body: Text("emptyPage")),
          ],
        ),
      ),
    );
  }
}

class VolumePage extends StatefulWidget {
  @override
  _VolumePageState createState() => _VolumePageState();
}

class _VolumePageState extends State<VolumePage> {
  num currentVolume = 0;
  num initVolume = 0;
  num maxVolume = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    num initVolume = await VolumeWatcher.getCurrentVolume;
    num maxVolume = await VolumeWatcher.getMaxVolume;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      this.initVolume = initVolume;
      this.maxVolume = maxVolume;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        VolumeWatcher(
          onVolumeChangeListener: (num volume) {
            setState(() {
              currentVolume = volume;
            });
          },
        ),
        Text("最大音量=${maxVolume}"),
        Text("初始音量=${initVolume}"),
        Text("当前音量=${currentVolume}"),
        RaisedButton(
          onPressed: () {
            VolumeWatcher.setVolume(maxVolume * 0.5);
          },
          child: Text("设置音量为${maxVolume * 0.5}"),
        ),
        RaisedButton(
          onPressed: () {
            VolumeWatcher.setVolume(maxVolume * 0.0);
          },
          child: Text("设置音量为${maxVolume * 0.0}"),
        )
      ],
    );
  }
}
