import 'dart:io';

import 'package:SplashApp/constants/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePage extends StatefulWidget {
  String imgId;
  String imgPath;
  ImagePage(this.imgPath, this.imgId);
  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  FlutterLocalNotificationsPlugin notification;
  Permission permission;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    var androidInitialize = AndroidInitializationSettings("app_icon");
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitialize,
    );
    notification = FlutterLocalNotificationsPlugin();
    notification.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {}

  downloadFile() async {
    Directory directory;
    try {
      if (await Permission.storage.request().isGranted) {
        directory = await getExternalStorageDirectory();
        String newPath = "";
        List<String> folders = directory.path.split("/");
        for (int x = 1; x < folders.length; x++) {
          String folder = folders[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath += "/SplashApp";
        directory = Directory(newPath);
        print(directory.path);
        String fileName = widget.imgId + ".jpg";
        File saveFile = File(directory.path + "/$fileName");
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        if (await directory.exists()) {
          dio.download(widget.imgPath, saveFile.path).whenComplete(() async {
            await showNotification();
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "SplashApp", "Download", "Notification",
        importance: Importance.max);
    NotificationDetails generalNotificationDetails =
        NotificationDetails(android: androidDetails);

    await notification.show(
        0, "SplashApp", "File Donwloaded", generalNotificationDetails,
        payload: "Download");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              downloadFile();
            },
          )
        ],
      ),
      body: SizedBox.expand(
        child: Container(
          color: mainColor,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Hero(
                    tag: widget.imgPath, child: Image.network(widget.imgPath)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
