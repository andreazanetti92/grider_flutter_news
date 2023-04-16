import 'package:flutter/material.dart';
import 'stories_bloc.dart';
export 'stories_bloc.dart';

class StoriesProvider extends InheritedWidget {
  final StoriesBloc storiesBloc;

  StoriesProvider({Key? key, required Widget child})
      : storiesBloc = StoriesBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static StoriesBloc of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<StoriesProvider>()!
        .storiesBloc);
  }
}
