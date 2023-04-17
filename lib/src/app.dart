import 'package:flutter/material.dart';
import 'blocs/stories_provider.dart';
import 'blocs/comments_provider.dart';
import 'screens/news_list.dart';
import 'screens/news_detail.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'Hacking the news!',
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    print(settings);

    if (settings.name == "/") {
      return MaterialPageRoute(
        builder: (context) {
          return NewsList();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          final CommentsBloc = CommentsProvider.of(context);
          final id = int.parse(settings.name!.replaceFirst("/", ""));

          CommentsBloc.fetchItemWithComments(id);

          return NewsDetail(id: id);
        },
      );
    }
  }
}
