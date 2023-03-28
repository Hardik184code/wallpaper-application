// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:new_wallpaper_001/models/image_model.dart';
import 'package:new_wallpaper_001/utils/pref_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageView extends StatefulWidget {
  const ImageView({super.key, required this.images});

  final ImageModel images;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool isLiked = false;

  @override
  void initState() {
    check();
    FlutterDownloader.registerCallback(DownloadCallback.callback);
    super.initState();
  }

  PrefManager prefs = PrefManager();

  check() async {
    bool checkLike = await prefs.isFavourite(widget.images.urls.regular);
    setState(() {
      isLiked = checkLike;
    });
  }

  downloadImage() async {
    final status = await Permission.storage.request();
    var dir = Directory("/sdcard/download/unsplash");
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    if (status.isGranted) {
      await FlutterDownloader.enqueue(
        url: widget.images.urls.full,
        savedDir: dir.path,
        fileName: 'image_${widget.images.id}.jpg',
        showNotification: true,
        openFileFromNotification: true,
      );
    } else {
      await Permission.storage.request();
    }
  }

  void setWallpaperDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Set Wallpaper',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Home Screen',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                leading: const Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                onTap: () {
                  setWallpaper(1);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Setting Wallpaper")));
                },
              ),
              ListTile(
                title: const Text(
                  'Lock Screen',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                leading: const Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                onTap: () {
                  setWallpaper(2);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Setting Wallpaper")));
                },
              ),
              ListTile(
                title: const Text(
                  'Both',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                leading: const Icon(
                  Icons.phone_android,
                  color: Colors.black,
                ),
                onTap: () {
                  setWallpaper(3);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Setting Wallpaper")));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static const platform =
      MethodChannel('com.example.new_wallpaper_001/wallpaper');

  Future<void> setWallpaper(int type) async {
    var file =
        await DefaultCacheManager().getSingleFile(widget.images.urls.full);
    try {
      await platform.invokeMethod('setWallpaper', [file.path, type]);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wallpaper set successfully')));
  }

  double angle = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Hero(
        tag: widget.images.id,
        transitionOnUserGestures: true,
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              child: InteractiveViewer(
                onInteractionUpdate: (ScaleUpdateDetails details) {
                  setState(() {
                    angle = details.rotation;
                  });
                },
                onInteractionEnd: (ScaleEndDetails details) {
                  setState(() {
                    angle = 0.0;
                  });
                },
                child: Transform.rotate(
                  angle: angle,
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: widget.images.urls.regular,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SizedBox(
                height: 56,
                width: 56,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  child: IconButton(
                    tooltip: "Back",
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: SizedBox(
                  height: 60,
                  width: 200,
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(35),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            tooltip: "Download",
                            onPressed: downloadImage,
                            icon: const Icon(Icons.download_sharp)),
                        IconButton(
                            tooltip: "Set as Wallpaper",
                            onPressed: setWallpaperDialog,
                            icon: const Icon(Icons.wallpaper)),
                        IconButton(
                            tooltip: "Favourite",
                            onPressed: () {
                              prefs.toggleFavourite(widget.images.urls.regular);
                              check();
                            },
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : null,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DownloadCallback {
  static void callback(String id, DownloadTaskStatus status, int progress) {
    if (kDebugMode) {
      print(progress);
    }
  }
}
