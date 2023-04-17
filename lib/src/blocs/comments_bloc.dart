import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../Models/item_model.dart';
import '../resources/repository.dart';

class CommentsBloc {
  final _repository = Repository();
  late final _commentsFetcher = PublishSubject<int>();
  late final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel?>>>();

  // Stream getters
  Stream<Map<int, Future<ItemModel?>>> get itemWithComments =>
      _commentsOutput.stream;

  // Sink getters
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel?>>>(
      (cache, int id, index) {
        print(index);
        cache[id] = _repository.fetchItem(id);
        cache[id]!.then((ItemModel? item) {
          for (var kidId in item!.kids!) {
            fetchItemWithComments(kidId);
          }
        });

        return cache;
      },
      <int, Future<ItemModel?>>{},
    );
  }

  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}
