import 'dart:io';

import 'package:udaan_app/views/PreviewWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomCode = TextEditingController(text: "zhr-seow-tuj");
    final nameTextController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(''),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Use Navigator.pop to navigate back to the previous screen
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300.0,
                child: TextField(
                  controller: roomCode,
                  autofocus: true,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                      hintText: 'Enter Room URL',
                      suffixIcon: IconButton(
                        onPressed: roomCode.clear,
                        icon: const Icon(Icons.clear),
                      ),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)))),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                width: 300.0,
                child: TextField(
                  controller: nameTextController,
                  autofocus: true,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                      hintText: 'Enter Name',
                      suffixIcon: IconButton(
                        onPressed: nameTextController.clear,
                        icon: const Icon(Icons.clear),
                      ),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)))),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                width: 300.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ))),
                  onPressed: () async {
                    if (!(GetUtils.isBlank(roomCode.text) ?? true) &&
                        !(GetUtils.isBlank(nameTextController.text) ?? true)) {
                      if (kDebugMode) {
                        print(
                            "ElevatedButton ${roomCode.text} ${nameTextController.text}");
                      }
                      bool res = await getPermissions();
                      if (res) {
                        Get.to(() => PreviewWidget(
                            roomCode.text, nameTextController.text));
                      }
                    }
                  },
                  child: const Text('Join Meeting'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> getPermissions() async {
    if (Platform.isIOS) return true;
    await Permission.camera.request();
    await Permission.microphone.request();

    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }
    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }

    while ((await Permission.bluetoothConnect.isDenied)) {
      await Permission.bluetoothConnect.request();
    }
    return true;
  }
}
