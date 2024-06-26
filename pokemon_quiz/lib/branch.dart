import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

class branch extends StatefulWidget {
  const branch({Key? key}) : super(key: key);

  @override
  State<branch> createState() => _branch();
}

class _branch extends State<branch> {
  void uploadPicture() async {
    try {
      Uint8List? uint8list = await ImagePickerWeb.getImageAsBytes();
      if (uint8list != null) {
        var metadata = SettableMetadata(
          contentType: "image/jpeg",
        );
        FirebaseStorage.instance.ref("sample").putData(uint8list, metadata);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('4択クイズ'),
      ),
      body: Center(),
    );
  }
}
