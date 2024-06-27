import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImagePickerExample extends StatefulWidget {
  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  File? _image;
  String name = '';

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    // ギャラリーから画像を選択
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    // 選択された画像がない場合は処理を終了
    // if (pickedFile == null) {
    //   return;
    // }

    // 画像名を取得
    final fileName = path.basename(pickedFile!.path);

    // 画像名を出力
    print('画像名: $fileName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child:
            _image == null ? Text('No image selected.') : Image.network(name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
