import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_app/pages/view_course.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  TextEditingController _addCourseName = TextEditingController();
  TextEditingController _addCourseFee = TextEditingController();

  XFile? _chooseImage;
  String? _imageUrl;

  chooseImageFromCG() async {
    ImagePicker _picker = ImagePicker();
    _chooseImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  sendData() async {
    File _ImageFile = File(_chooseImage!.path);

    FirebaseStorage _storage = FirebaseStorage.instance;
    UploadTask _uploadTask =
        _storage.ref("images").child(_chooseImage!.path).putFile(_ImageFile);

    TaskSnapshot _snapshot = await _uploadTask;
    _imageUrl = await _snapshot.ref.getDownloadURL();

    CollectionReference _course =
        await FirebaseFirestore.instance.collection("courses");

    _course.add(({
      "courseName": _addCourseName.text,
      "courseFee": _addCourseFee.text,
      "image": _imageUrl
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550.h,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.h),
        child: Column(
          children: [
            Divider(
              indent: 130.w,
              endIndent: 130.w,
              thickness: 5.h,
              color: Colors.grey,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "Add New Course",
              style: myStyle(20.sp, Colors.black, FontWeight.w700),
            ),
            SizedBox(
              height: 10.h,
            ),
            TextField(
              controller: _addCourseName,
              decoration: InputDecoration(
                hintText: "Add New Course Name",
                contentPadding: EdgeInsets.only(left: 15.w),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.2),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            TextField(
              controller: _addCourseFee,
              decoration: InputDecoration(
                hintText: "Add Course Fee",
                contentPadding: EdgeInsets.only(left: 15.w),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.2),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              height: 200.h,
              width: 250.w,
              //color: Colors.grey.withOpacity(0.2),
              child: _chooseImage == null
                  ? IconButton(
                      onPressed: () {
                        chooseImageFromCG();
                      },
                      icon: Icon(Icons.photo))
                  : Image.file(
                      File(_chooseImage!.path),
                      height: double.infinity,
                      width: double.infinity,
                      //fit: BoxFit.cover,
                    ),
            ),
            SizedBox(
              height: 20.h,
            ),
            ElevatedButton(
                onPressed: () {
                  sendData();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ViewCourse()));
                },
                child: Text(
                  "Add Course",
                  style: myStyle(18, Colors.white, FontWeight.w600),
                ))
          ],
        ),
      ),
    );
  }
}

myStyle(double fs, Color clr, [FontWeight? fw]) {
  return TextStyle(fontSize: fs, color: clr, fontWeight: fw);
}
