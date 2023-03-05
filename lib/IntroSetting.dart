import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart';

class IntroSetting extends StatefulWidget {
  IntroSetting({Key? key}) : super(key:key);

  @override
  IntroSettingState createState() => IntroSettingState();
}

class IntroSettingState extends State<IntroSetting> {

  FilePickerResult? result;
  String? fileNm;
  PlatformFile? pickedFile;
  bool isLoading = false;
  File? fileToDisplay;

  void pickFile() async {

    try {
      setState(() {
        isLoading = true;
      });

      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        allowMultiple: false
      );

      if (result != null) {
        fileNm = result!.files.first.name;
        pickedFile = result!.files.first;
        fileToDisplay = File(pickedFile!.path.toString());

        var file = pickedFile!.path.toString();
        var bytes = File(file).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        for (var table in excel.tables.keys) {
          print(table); //sheet Name
          print(excel.tables[table]!.maxCols);
          print(excel.tables[table]!.maxRows);
          for (var row in excel.tables[table]!.rows) {
            print("$row");
            print("----------------------");
          }
        }
      }

      print('File name $fileNm !!');

      setState(() {
        isLoading = false;
      });
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : TextButton(onPressed: () { pickFile(); }, child: Text("Pick File!")),
            ),
            if (pickedFile != null)
              SizedBox(
                height: 300, width: 400, child: Image.file(fileToDisplay!),
              )
          ],
        )
    );
  }
}