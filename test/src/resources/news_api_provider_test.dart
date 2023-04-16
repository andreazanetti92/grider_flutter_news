import 'package:grider_flutter_news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test(
    'FetchTopIds return a List of IDs<int>',
    () async {
      // setup test case
      final newsApi = NewsApiProvider();
      newsApi.client = MockClient((request) async {
        return Response(json.encode([1, 2, 3, 4, 5, 6, 7, 8, 9]), 200);
      });

      final ids = await newsApi.fetchTopIDs();

      // expectation
      expect(ids, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
    },
  );
  test(
    'FetchItem return an ItemModel',
    () async {
      // setup test case
      final newsApi = NewsApiProvider();
      final jsonMap = {
        'id': 123,
        // 'deleted': false,
        // 'type': 'typedata',
        // 'by': 'bydata',
        // 'time': 0,
        // 'text': 'textdata',
        // 'dead': false,
        // 'parent': 0,
        // 'kids': [1, 2, 3],
        // 'url': 'urldata',
        // 'score': 0,
        // 'title': 'titledata',
        // 'descendants': 0
      };
      newsApi.client = MockClient((request) async {
        return Response(json.encode(jsonMap), 200);
      });

      final item = await newsApi.fetchItem(123);

      // expectation
      expect(item.id, 123);
    },
  );
}
