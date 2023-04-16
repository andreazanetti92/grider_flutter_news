import 'dart:convert';

class TopIdsModel {
  late final int? id;
  late final int? datetime;
  late final List<int>? topIds;

  TopIdsModel.fromJson(List<int>? listIds)
      : id = null,
        datetime = DateTime.now().millisecondsSinceEpoch,
        topIds = listIds;

  TopIdsModel.fromDB(Map<String, dynamic> queryResult)
      : id = queryResult['id'],
        datetime = queryResult['datetimeCreated'],
        topIds = List<int>.from(jsonDecode(queryResult['listIds']));

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "datetimeCreated": datetime,
      "listIds": jsonEncode(topIds),
    };
  }
}
