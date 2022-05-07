import 'package:flutter/material.dart';
import '../models/news.dart';


class NewsWidget extends StatelessWidget {

  final News _item;

  const NewsWidget({Key? key, required News item}):
        _item = item,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery
        .of(context)
        .size
        .height;
    final double width = MediaQuery
        .of(context)
        .size
        .width;

    return Card(
      color: Colors.grey,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      elevation: 6,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 8, left: 8, right: 8),
        child: Row(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                width: width / 4.30,
                height: height / 9,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(_item.image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              Column(
                children: [
                  Text(_item.title,
                    style: const TextStyle(fontSize: 18.0,
                    color: Colors.black)
                    ),
                  Text(_item.body,
                      style: const TextStyle(fontSize: 14.0,
                          color: Colors.black)
                  )
                ],
              )

        ],
      ),
    ));
  }
}