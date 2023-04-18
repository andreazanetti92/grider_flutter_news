import 'dart:async';
import 'package:flutter/material.dart';
import '../Models/item_model.dart';
import 'package:flutter_html/flutter_html.dart';
import '../widgets/loading_container.dart';

class Comment extends StatelessWidget {
  late final int? itemId;
  late final Map<int, Future<ItemModel?>>? itemMap;
  late final int? depth;

  Comment({this.itemId, this.itemMap, this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: itemMap![itemId],
        builder: (context, AsyncSnapshot<ItemModel?> snapshot) {
          if (!snapshot.hasData) {
            return LoadingContainer();
          }

          final item = snapshot.data!;

          final children = <Widget>[
            ListTile(
              contentPadding: EdgeInsets.only(
                right: 16.0,
                left: depth == 0 ? 16.0 : depth! * 16.0,
              ),
              title: Html(data: item.text) /*buildText(item)*/,
              subtitle: item.by! == "" ? const Text("Deleted") : Text(item.by!),
            ),
            const Divider(),
          ];

          for (var kidId in item.kids!) {
            children.add(
              Comment(
                itemId: kidId,
                itemMap: itemMap,
                depth: depth! + 1,
              ),
            );
          }

          return Column(
            children: children,
          );
        });
  }

  // Widget buildText(ItemModel? item) {
  //   final text = item!.text!
  //       .replaceAll("&#x27;", "'")
  //       .replaceAll("<p>", "\n\n")
  //       .replaceAll("</p>", "")
  //       .replaceAll("&#x2F;", "/")
  //       .replaceAll("&quot;", '"');

  //   return Text(text);
  // }
}
