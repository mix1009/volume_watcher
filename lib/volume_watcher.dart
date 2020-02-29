import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class VolumeWatcher extends StatefulWidget {
  final ValueChanged<num> onVolumeChangeListener;
  VolumeWatcher({Key key, this.onVolumeChangeListener}) : super(key: key);

  static const MethodChannel methodChannel =
      const MethodChannel('volume_watcher_method');
  static const EventChannel eventChannel =
      const EventChannel('volume_watcher_event');

  static StreamSubscription _subscription;
  static final _volumeChangedSubject = BehaviorSubject<int>();
  static Stream<int> get volumeChangedStream => _volumeChangedSubject.stream;

  @override
  State<StatefulWidget> createState() {
    if (_subscription == null) {
      _subscription =
          VolumeWatcher.eventChannel.receiveBroadcastStream().listen((vol) {
        _volumeChangedSubject.add(vol);
      }, onError: _onError);
    }

    return VolumeState();
  }

  void _onError(Object error) {
    print('Volume status: unknown.' + error.toString());
  }

  /*
   * 获取当前系统最大音量
   */
  static Future<num> get getMaxVolume async {
    final num maxVolume = await methodChannel.invokeMethod('getMaxVolume', {});
    return maxVolume;
  }

  /*
   * 获取当前系统音量
   */
  static Future<num> get getCurrentVolume async {
    final num currentVolume =
        await methodChannel.invokeMethod('getCurrentVolume', {});
    return currentVolume;
  }

  /*
   * 设置系统音量
   */
  static Future<bool> setVolume(double volume) async {
    final bool success =
        await methodChannel.invokeMethod('setVolume', {'volume': volume});
    return success;
  }
}

class VolumeState extends State<VolumeWatcher> {
  StreamSubscription _subscription;
  num currentVolume = 0;

  @override
  void initState() {
    super.initState();

    _subscription = VolumeWatcher.volumeChangedStream.listen((val) {
      if (mounted) {
        if (widget.onVolumeChangeListener != null) {
          widget.onVolumeChangeListener(val);
        }
        setState(() {
          currentVolume = val;
        });
      }
    });
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
