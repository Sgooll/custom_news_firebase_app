import 'package:cloud_firestore/cloud_firestore.dart';

class News{
  String id;
  String image;
  String title;
  var comments;
  String body;
  var favourite;
  Timestamp date;
  String author;

  News({
    required this.id,
    required this.image,
    required this.title,
    required this.comments,
    required this.body,
    required this.favourite,
    required this.date,
    required this.author,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      comments: json['comments'],
      body: json['body'],
      favourite: json['favourite'],
      date: json["date"],
      author: json["author"],
    );
  }
}