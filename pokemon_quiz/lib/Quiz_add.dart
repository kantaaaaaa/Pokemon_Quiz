import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

import 'package:image_picker_web/image_picker_web.dart';

class Quiz_add extends StatefulWidget {
  const Quiz_add({Key? key}) : super(key: key);

  @override
  _Quiz_add createState() => _Quiz_add();
}

class _Quiz_add extends State<Quiz_add> {
  String answer = '';
  String first = '';
  String second = '';
  String third = '';
  String fourth = '';

  XFile? _image;
  final imagePicker = ImagePicker();

  Future getImageFromGarally() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
      }
    });
  }

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
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: '正解名'),
              onChanged: (text) {
                answer = text;
              },
            ),
            TextField(
              decoration: InputDecoration(hintText: '選択肢1'),
              onChanged: (text) {
                first = text;
              },
            ),
            TextField(
              decoration: InputDecoration(hintText: '選択肢2'),
              onChanged: (text) {
                second = text;
              },
            ),
            TextField(
              decoration: InputDecoration(hintText: '選択肢3'),
              onChanged: (text) {
                third = text;
              },
            ),
            TextField(
              decoration: InputDecoration(hintText: '選択肢4'),
              onChanged: (text) {
                fourth = text;
              },
            ),
            _image == null
                ? Text(
                    '写真を選択してください',
                    style: Theme.of(context).textTheme.headline4,
                  )
                : Image.file(File(_image!.path)),
            ElevatedButton(
              onPressed: () {
                _addfirebase();
              },
              child: Text('追加'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: getImageFromGarally, child: const Icon(Icons.photo_album)),
    );
  }

  void _addfirebase() async {
    final db = FirebaseFirestore.instance;
    final Quizdata = <String, dynamic>{
      "quiz_id": 3,
      "answer": answer,
      "first": first,
      "second": second,
      "third": third,
      "fourth": fourth,
    };

    await db.collection("Quizdata").add(Quizdata);
  }
}
