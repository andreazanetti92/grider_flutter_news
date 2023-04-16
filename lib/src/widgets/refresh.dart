import 'package:flutter/material.dart';
import 'package:grider_flutter_news/src/blocs/stories_provider.dart';

class Refresh extends StatelessWidget {
  late final Widget? child;

  Refresh({this.child});

  @override
  Widget build(context) {
    final bloc = StoriesProvider.of(context);
    return RefreshIndicator(
      child: child!,
      onRefresh: () async {
        await bloc.clearCache();
        await bloc.fetchTopIds();
      },
    );
  }
}
