import 'package:flutter/material.dart';


class CommentsWidget extends StatelessWidget {

  final List<dynamic> _item;

  const CommentsWidget({Key? key, required List<dynamic> item}):
        _item = item,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_item.length < 3) {
      return ListView.builder(
          itemCount: _item.length,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Text(_item[index],
                style: const TextStyle(fontSize: 14.0,
                    color: Colors.black));
          }
      );
    }
    else {
      return Column(
        children: [
          ListView.builder(
              itemCount: _item.length - 3,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                while (index < 3) {
                  return Text(_item[index],
                      style: const TextStyle(fontSize: 14.0,
                          color: Colors.black));
                }
                return Container();
              }
          ),
          ExpansionTile(
            title: const Text("More comments"),
            children: [
              const SizedBox(height: 10),
              ListView.builder(
                  itemCount: _item.length - 3,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    index += 3;
                      return Text(_item[index],
                          style: const TextStyle(fontSize: 14.0,
                              color: Colors.black));
                  }
              ),
            ],
          ),
        ],
      );
    }
  }
}