import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/news.dart';


Future<List<News>> getNews() async {
  List<News> newsList = List.empty(growable: true);
  CollectionReference news = FirebaseFirestore.instance.collection("News");
  for (int i = 1; i <= await countId(); i++) {
    final docFav = news.doc("$i");
    var snapshot = await docFav.get();
    if (snapshot.exists) {
      Map<String, dynamic> documentData = snapshot.data() as Map<String,
          dynamic>;

        newsList.add(News.fromJson(documentData));
      }
    }
  return newsList;
  }

Future<News> getOneNews(String id) async {
  CollectionReference news = FirebaseFirestore.instance.collection("News");
    final docFav = news.doc(id);
    var snapshot = await docFav.get();
    Map<String, dynamic> documentData = snapshot.data() as Map<String, dynamic>;
    return News.fromJson(documentData);
}

Future<List<News>> getFavouriteNews(List<dynamic> favouritesId) async {
  List<News> newsList = List.empty(growable: true);
  CollectionReference news = FirebaseFirestore.instance.collection("News");
  for (int i = 1; i <= await countId(); i++) {
    if (favouritesId.contains("$i")){
      final docFav = news.doc("$i");
      var snapshot = await docFav.get();
      if (snapshot.exists) {
        Map<String, dynamic> documentData = snapshot.data() as Map<String,
            dynamic>;

        newsList.add(News.fromJson(documentData));
      }
    }
  }
  return newsList;
}

Future<int> countId() async {
  CollectionReference news = FirebaseFirestore.instance.collection("News");
  var snapshot = await news.get();
  return snapshot.size;
}


