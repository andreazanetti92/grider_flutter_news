import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:grider_flutter_news/src/Models/top_ids_model.dart';
import 'package:http/http.dart' show Client;

import '../Models/item_model.dart';
import 'repository.dart';

const _host = 'hacker-news.firebaseio.com';

class NewsApiProvider implements Source {
  Client client = Client();

  @override
  Future<TopIdsModel?> fetchTopIDs() async {
    final response = await client.get(Uri(
      scheme: 'https',
      host: _host,
      path: '/v0/topstories.json',
    ));

    final ids = json.decode(response.body);

    final topIdsModel = TopIdsModel.fromJson(ids.cast<int>());

    return topIdsModel;
  }

  @override
  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get(Uri(
      scheme: 'https',
      host: _host,
      path: '/v0/item/$id.json',
    ));

    final parsedJson = json.decode(response.body);

    return ItemModel.fromJSON(parsedJson);
  }
}
