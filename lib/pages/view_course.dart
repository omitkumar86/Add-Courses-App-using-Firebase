import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_app/pages/add_course.dart';
import 'package:course_app/pages/update_course.dart';
import 'package:course_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewCourse extends StatefulWidget {
  const ViewCourse({super.key});

  @override
  State<ViewCourse> createState() => _ViewCourseState();
}

class _ViewCourseState extends State<ViewCourse> {
  addNewCourse() {
    return showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => AddCoursePage());
  }

  updateCourse(documentID, courseName, courseFee, courseImage) {
    return showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) =>
            UpdateCourse(documentID, courseName, courseFee, courseImage));
  }

  Future<void> deleteCourse(selecetedDocumentID) {
    return FirebaseFirestore.instance
        .collection("courses")
        .doc(selecetedDocumentID)
        .delete()
        .then((value) => print("Successfully Deleted Course"));
  }

  Stream<QuerySnapshot> _courseStream =
      FirebaseFirestore.instance.collection("courses").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View All Course"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: _courseStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something is Error!");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: viewCircleIndicator());
            }
            return ListView(
              children:
                  snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                Map<String, dynamic> data =
                    documentSnapshot.data() as Map<String, dynamic>;
                return Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.h),
                  child: Card(
                    elevation: 8,
                    child: ListTile(
                      leading: Container(
                        height: double.infinity,
                        width: 80.w,
                        child: Image.network(
                          data["image"],
                          height: double.infinity,
                          width: 80.w,
                        ),
                      ),
                      title: Text(
                        "${data["courseName"]}",
                        style: myStyle(16, Colors.black, FontWeight.w600),
                      ),
                      subtitle: Text(
                        "Fee: ${data["courseFee"]} TK",
                        style: myStyle(14, Colors.black54, FontWeight.w500),
                      ),
                      trailing: Container(
                        width: 55.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                updateCourse(
                                    documentSnapshot.id,
                                    data["courseName"],
                                    data["courseFee"],
                                    data["image"]);
                              },
                              child: Icon(
                                Icons.edit,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                deleteCourse(documentSnapshot.id);
                              },
                              child: Icon(
                                Icons.delete,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewCourse();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
