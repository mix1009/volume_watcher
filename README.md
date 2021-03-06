# volume_watcher
```
支持ios 与 android 以下功能：
  1.实时监听返回系统音量值的改变，并返回音量值。 
  2.返回系统支持的最大音量，防止android不同机型最大值不同。 
  3.返回系统改变音量前的初始值。
  4.支持设置媒体音量
  
对外提供如下方法：
getMaxVolume
getCurrentVolume
setVolume(0.0)

对外提供监听：
onVolumeChangeListener

使用示例：
import 'package:flutter/material.dart';
import 'package:volume_watcher/volume_watcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  num currentVolume = 0;
  num initVolume = 0;
  num maxVolume = 0;

  @override
  void initState(){
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
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
                onPressed: (){
                  VolumeWatcher.setVolume(maxVolume*0.5);
                },
                child: Text("设置音量为${maxVolume*0.5}"),
              ),
              RaisedButton(
                onPressed: (){
                  VolumeWatcher.setVolume(maxVolume*0.0);
                },
                child: Text("设置音量为${maxVolume*0.0}"),
              )
            ]),
      ),
    );
  }
}

```

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
