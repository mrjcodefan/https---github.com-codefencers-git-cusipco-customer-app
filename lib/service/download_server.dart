import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:heal_u/service/permission_alert_dialog.dart';
import 'package:heal_u/themedata.dart';
import 'package:heal_u/widgets/general_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadAlertDialogWidget extends StatefulWidget {
  DownloadAlertDialogWidget({Key? key, required this.urlList})
      : super(key: key);
  List<String> urlList;

  @override
  State<DownloadAlertDialogWidget> createState() =>
      _DownloadAlertDialogWidgetState();
}

class _DownloadAlertDialogWidgetState extends State<DownloadAlertDialogWidget> {
  int _numberOfIndex = 0;

  late String _localPath;
  int progress = 0;
  int _prevProgress = 0;

  final ReceivePort _receivePort = ReceivePort();
  late final int totalNumberOfFiles = widget.urlList.length;

  bool isLastFile = false;

  @override
  void initState() {
    print("--------download init state widget--------${_numberOfIndex}");
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    initalize();
    super.initState();
  }

  initalize() async {
    await _prepareSaveDir();

    _requestDownload();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');

    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }

    _receivePort.listen((dynamic data) {
      String? id = data[0];

      _prevProgress = data[2];

      if (_prevProgress != progress) {
        setState(() {
          progress = _prevProgress;
        });

        print("--->  $progress");

        if (_numberOfIndex == widget.urlList.length - 1) {
          if (progress == 100) {
            print("length--> ${widget.urlList.length - 1}");
            print("current item--> ${_numberOfIndex}");
            Future.delayed(const Duration(milliseconds: 200), () {
              _openDownloadedFile(id);
              Navigator.of(context).pop();
            });

            print("----last Item for download----");
          }
        } else {
          if (progress == 100) {
            setState(() {
              _numberOfIndex++;
            });
            _requestDownload();
            print("----there is more item for download----");
          }
        }
      }
    });
  }

  void _requestDownload() async {
    print("----file name-----${widget.urlList[_numberOfIndex].toString()}");
    var timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    print("----file name1----- ${DateTime.now()}");
    var task = await FlutterDownloader.enqueue(
      url: widget.urlList[_numberOfIndex],
      headers: {"auth": "downloading"},
      savedDir: _localPath,
      showNotification: true,
      fileName:
          timestamp + widget.urlList[_numberOfIndex].toString().split("/").last,
      openFileFromNotification: true,
      saveInPublicStorage: true,
    ).whenComplete(() {}).then((value) {
      print("value -->$value");
    });

    print("task ---------$task");
  }

  Future<String?> _findLocalPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  Future<bool> _openDownloadedFile(task) {
    print("---open file $task");

    try {
      if (task != null) {
        return FlutterDownloader.open(taskId: task);
      } else {
        return Future.value(false);
      }
    } catch (e) {
      print("-------error $e");
      showToast(e.toString());
      return Future.value(false);
    }
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @override
  Widget build(BuildContext context2) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 5.0,
              percent:
                  progress > 0 ? double.parse((progress / 100).toString()) : 0,
              center: Text(progress > 0 ? "$progress%" : "0%"),
              progressColor: ThemeClass.orangeColor,
            ),
            const SizedBox(
              height: 20,
            ),
            Center(child: Text(" Item ${_numberOfIndex + 1} is downloading"))
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              "Hide",
              style: TextStyle(color: ThemeClass.orangeColor),
            ),
            onPressed: () {
              showToast("Download Running in Background");
              Navigator.pop(context, true);
            },
          ),
          TextButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: ThemeClass.orangeColor),
            ),
            onPressed: () {
              Navigator.pop(context2, true);
            },
          )
        ],
      ),
    );
  }
}

Future requestPermission(Permission permission, context) async {
  if (await permission.isGranted) {
    return true;
  } else if (await Permission.storage.request().isDenied) {
    var res = await Permission.storage.request();

    if (res == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  } else if (await Permission.storage.request().isPermanentlyDenied) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context1) {
        return PermissionAlertDialogWidget();
      },
    );

    return false;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    }
  }
  return false;
}
