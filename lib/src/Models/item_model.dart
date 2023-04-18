import 'dart:convert';

class ItemModel {
  late final int? id;
  late final bool? deleted;
  late final String? type;
  late final String? by;
  late final int? time;
  late final String? text;
  late final bool? dead;
  late final int? parent;
  late final List<dynamic>?
      kids; // Post's comments // Not included reply to a post
  late final String? url;
  late final int? score; // Post's upvote
  late final String? title;
  late final int? descendants; // tot num of comments

  ItemModel.fromJSON(Map<String, dynamic> parsedJSON)
      : id = parsedJSON['id'],
        deleted = parsedJSON['deleted'] ?? false,
        type = parsedJSON['type'],
        by = parsedJSON['by'] ?? "",
        time = parsedJSON['time'],
        text = parsedJSON['text'] ?? "",
        dead = parsedJSON['dead'] ?? false,
        parent = parsedJSON['parent'],
        kids = parsedJSON['kids'] ?? [],
        url = parsedJSON['url'],
        score = parsedJSON['score'],
        title = parsedJSON['title'],
        descendants = parsedJSON['descendants'] ?? 0;

  ItemModel.fromDB(Map<String, dynamic> queryResult)
      : id = queryResult['id'],
        deleted = queryResult['deleted'] == 1, // 1 == 1 -> true 0 == 1 -> false
        type = queryResult['type'],
        by = queryResult['by'],
        time = queryResult['time'],
        text = queryResult['text'],
        dead = queryResult['dead'] == 1,
        parent = queryResult['parent'],
        kids = jsonDecode(
            queryResult['kids']), // The blob will be converted to List<int>
        url = queryResult['url'],
        score = queryResult['score'],
        title = queryResult['title'],
        descendants = queryResult['descendants'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "deleted": deleted! ? 1 : 0,
      "type": type,
      "by": by,
      "time": time,
      "text": text,
      "dead": dead! ? 1 : 0,
      "parent": parent,
      "kids": jsonEncode(kids),
      "url": url,
      "score": score,
      "title": title,
      "descendants": descendants
    };
  }
}
