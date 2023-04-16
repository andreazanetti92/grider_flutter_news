import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:grider_flutter_news/src/Models/item_model.dart';
import 'package:grider_flutter_news/src/Models/top_ids_model.dart';

import 'news_api_provider.dart';
import 'news_db_provider.dart';

class Repository {
  // NewsDbProvider newsDbProvider = NewsDbProvider();

  List<Source> sources = <Source>[
    newsDbProvider, // init in news_db_provider.dart
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    newsDbProvider, // init in news_db_provider.dart
  ];

  Future<List<int>?> fetchTopIds() async {
    TopIdsModel? topIdsModel;
    Source source;

    for (source in sources) {
      topIdsModel = await source.fetchTopIDs();

      if (topIdsModel != null && topIdsModel.datetime! >= (15 * 60 * 1000)) {
        continue;
      }

      if (topIdsModel != null && topIdsModel.topIds!.isNotEmpty) {
        break;
      }
    }

    for (var cache in caches) {
      cache.addTopIds(TopIdsModel.fromJson(topIdsModel!.topIds));
    }

    return topIdsModel!.topIds;
  }

  Future<ItemModel?> fetchItem(int id) async {
    ItemModel? item;
    Source? source;

    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }

    for (var cache in caches) {
      if (item != null) {
        cache.addItem(item);

        // Another way to avoid to try to insert the same item
        // if (source is! NewsDbProvider) {
        //   cache.addItem(item);
        // }
      }
    }

    return item;
  }

  clearCache() async {
    for (var cache in caches) {
      await cache.clear();
    }
  }
}

abstract class Source {
  Future<TopIdsModel?> fetchTopIDs();
  Future<ItemModel?> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel? item);
  Future<int> addTopIds(TopIdsModel model);
  Future<int> clear();
}
