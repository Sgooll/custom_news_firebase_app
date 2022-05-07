import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lichi_test/src/widgets/comments_widget.dart';

import '../cubit/single_news_cubit.dart';
import '../models/news.dart';
import 'edit_news_page.dart';


class SingleNewsPage extends StatelessWidget {

  final News _item;


  const SingleNewsPage({Key? key, required News item}):
        _item = item,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SingleNewsCubit(),
      child: _SingleNewsPage(item: _item),
    );
  }
}

class _SingleNewsPage extends StatefulWidget {
  News _item;

  _SingleNewsPage({Key? key, required News item}):
        _item = item,
        super(key: key);

  @override
  State<_SingleNewsPage> createState() => _SingleNewsPageState();
}

class _SingleNewsPageState extends State<_SingleNewsPage> {
  bool isLongPressed = false;

  Widget showFavourites() {
    for (int i = 0; i < widget._item.favourite.length; i++){
      return ListView.builder(
          itemCount: widget._item.favourite.length,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Text("${widget._item.favourite[index]}",
                style: const TextStyle(fontSize: 14.0,
                    color: Colors.black));
          }
      );
    }
    return Container();
  }

  Future<void> addToFavourite() async {
    CollectionReference favourites = FirebaseFirestore.instance.collection("Favourites");
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    final docFav = favourites.doc(uid);
    var snapshot = await docFav.get();
    if (snapshot.exists) {
      Map<String, dynamic> documentData = snapshot.data() as Map<String, dynamic>;
      for (int i = 0; i <= documentData["favouritesId"].length; i++){
        if ("$i" == widget._item.id){
          print("Already in favourites");
          return;
        }
      }
      documentData["favouritesId"].add(widget._item.id);
      docFav.set(documentData);
    }
    else {
      favourites.doc(uid).set({'favouritesId' : []});
      snapshot = await docFav.get();
      Map<String, dynamic> documentData = snapshot.data() as Map<String, dynamic>;
      documentData["favouritesId"].add(widget._item.id);
      docFav.set(documentData);
    }
    //add favourites in news collection
    CollectionReference news = FirebaseFirestore.instance.collection("News");
    final newsDoc = news.doc(widget._item.id);
    snapshot = await newsDoc.get();
    Map<String, dynamic> newsData = snapshot.data() as Map<String, dynamic>;
    String? email = FirebaseAuth.instance.currentUser?.email;
    newsData["favourite"].add(email);
    newsDoc.set(newsData);
    print('added to favourite');
    return;
  }

  Future<void> addComment(String comment) async {
    if (comment == null || comment == "") {print("null comment");return;};
    CollectionReference news = FirebaseFirestore.instance.collection("News");
    final newsDoc = news.doc(widget._item.id);
    final snapshot = await newsDoc.get();
    Map<String, dynamic> newsData = snapshot.data() as Map<String, dynamic>;
    newsData["comments"].add(comment);
      newsDoc.set(newsData);
    print('comment added');
  }



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleNewsCubit, SingleNewsState>(builder: (context, state){
      final TextEditingController commentsController = TextEditingController();
      final double height = MediaQuery
          .of(context)
          .size
          .height;
      final double width = MediaQuery
          .of(context)
          .size
          .width;
      if (state is SingleNewsInitial){
        context.read<SingleNewsCubit>().informInitial();
        context.read<SingleNewsCubit>().loadSingleNews(widget._item.id);
        return Scaffold(
            appBar: AppBar(backgroundColor: Colors.grey,
              title: Text(widget._item.title,
                style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                ),
              ),
            ),
            backgroundColor: Colors.black54,
            body: const Center(child: CircularProgressIndicator())
        );
      }
      if (state is SingleNewsErrorState){
        return Text("Error ${state.errorMessage}", style: const TextStyle(color: Colors.red));
      }
      if (state is SingleNewsLoadedState) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        widget._item = state.news;
        return RefreshIndicator(
          onRefresh: () => context.read<SingleNewsCubit>().reloadSingleNews(),
          child: Scaffold(
            appBar: AppBar(backgroundColor: Colors.grey,
              title: const Text("News",
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onLongPress: () =>
                              setState(() =>
                              this.isLongPressed == false
                                  ? this.isLongPressed = true
                                  : this.isLongPressed = false,),
                          onPressed: () => addToFavourite(),
                          child: const Text("Add to favourite")),
                      SizedBox(width: width/8,),
                      uid == widget._item.author ? FloatingActionButton(
                        heroTag: "btn1",
                          onPressed: () => FirebaseFirestore.instance.collection("News").doc(widget._item.id).delete(),
                          child: const Icon(Icons.delete_forever)) : Container(margin: EdgeInsets.all(20),),
                      uid == widget._item.author ? FloatingActionButton(
                        heroTag: "btn2",
                          onPressed: () =>Navigator.push(context,
                              MaterialPageRoute(builder: (context) => EditNewsPage(id: widget._item.id))) ,
                          child: const Icon(Icons.edit)) : Container(margin: EdgeInsets.all(20),),
                      const SizedBox(width: 20)

                    ],
                  ),
                  this.isLongPressed == true ? showFavourites() : Container(),
                  Container(
                    width: width,
                    height: height / 2,
                    margin: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget._item.image),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  Text(widget._item.title,
                      style: const TextStyle(fontSize: 18.0,
                          color: Colors.black)
                  ),
                  Text(widget._item.body,
                      style: const TextStyle(fontSize: 14.0,
                          color: Colors.black)
                  ),
                  Text("published: ${widget._item.date.toDate()}",
                      style: const TextStyle(fontSize: 14.0,
                          color: Colors.black)),
                  Text("Comments:"),
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 150,
                    child: TextField(
                      controller: commentsController,
                      onSubmitted: (_) => addComment(commentsController.text),
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
                        labelText: "Type something",
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () => addComment(commentsController.text),
                      child: const Text("Add comment")),
                  CommentsWidget(item: widget._item.comments),
                ],
              ),
            ),

          ),
        );
      }
      return Container();
    });
  }
}