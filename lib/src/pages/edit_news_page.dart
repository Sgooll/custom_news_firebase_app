import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class EditNewsPage extends StatefulWidget {
  final id;

  EditNewsPage({Key? key, this.id}) : super(key: key);

  @override
  State<EditNewsPage> createState() => _EditNewsPageState();
}

class _EditNewsPageState extends State<EditNewsPage> {
  File? image;

  Future<String> countId() async {
    CollectionReference news = FirebaseFirestore.instance.collection("News");
    var snapshot = await news.get();
    return "${snapshot.size + 1}";
  }

  Future<void> pickImage(ImageSource source) async {
   final image = await ImagePicker().pickImage(source: source);
   if (image == null) return;
   final path = 'files/${await countId()}.png';
   final imageTemporary = File(image.path);
   final ref = FirebaseStorage.instance.ref().child(path);
   ref.putFile(imageTemporary);
   setState(() {
     this.image = imageTemporary;
   });

  }
  Future<void> EditNews(title, body, [id]) async {
    id ??= await countId();
    final url = await FirebaseStorage.instance.ref().child("files/$id.png").getDownloadURL();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    DateTime currentDate = DateTime.now(); //DateTime
    Timestamp timeStampDate = Timestamp.fromDate(currentDate);
    Map<String, dynamic> data = {
      "id": id,
      "title": title,
      "body": body,
      "image": url,
      "comments": [],
      "favourite": [],
      "date": timeStampDate,
      "author": uid,
    };
    CollectionReference news = FirebaseFirestore.instance.collection("News");
    final docId = await id;
    final docNews = news.doc(docId);
    docNews.set(data);
    Navigator.pop(context, EditNewsPage);
}

  @override
  Widget build(BuildContext context) {
    //TODO редактирование новости для создателя (передавать на страницу необязательный аргумент айди)
    //TODO Удаление записи
    final TextEditingController titleController = TextEditingController();
    final TextEditingController bodyController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit news"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Row(
              children: [
                Container(
                margin: const EdgeInsets.all(8),
                width: 200,
                height: 200,
                alignment: Alignment.centerLeft,
                  child: image != null ? Image.file(image!) : const FlutterLogo(size: 150),
        ),
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () => pickImage(ImageSource.gallery),
                        child: const Text("From gallery")),
                    ElevatedButton(
                        onPressed: () => pickImage(ImageSource.camera),
                        child: const Text("From camera"))
                  ],
                ),

              ],
            ),

                Container(
                  margin: EdgeInsets.all(10),
                  width: 150,
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      labelText: "Title",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 150,
                  child: TextField(
                    controller: bodyController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      labelText: "Body",
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () => EditNews(titleController.text, bodyController.text, widget.id),
                    child: widget.id == null ? const Text("Add news") : const Text("Edit news")),
              ],
            ),
          ),
        )
    );
  }
}