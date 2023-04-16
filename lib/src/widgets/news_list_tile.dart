import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grider_flutter_news/src/widgets/loading_container.dart';
import '../Models/item_model.dart';
import '../blocs/stories_provider.dart';

class NewListTile extends StatelessWidget {
  final int? itemId;

  const NewListTile({this.itemId});

  @override
  // write the type BuildContext do not let the StreamBuilder's snap to get data
  Widget build(context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel?>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        return FutureBuilder(
          future: snapshot.data![itemId],
          builder: (context, AsyncSnapshot<ItemModel?> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return LoadingContainer();
            }

            return buildTile(context, itemSnapshot.data);
          },
        );
      },
    );
  }

  Widget buildTile(BuildContext context, ItemModel? item) {
    return Column(
      children: [
        const Divider(
          height: 8.0,
        ),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/${item.id}');
          },
          title: Text(item!.title!),
          subtitle: Text('${item.score} upvotes'),
          trailing: Column(
            children: [
              const Icon(Icons.comment_outlined),
              Text('${item.descendants}'),
            ],
          ),
        )
      ],
    );
  }
}
