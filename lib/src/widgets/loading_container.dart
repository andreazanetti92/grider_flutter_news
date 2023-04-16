import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  @override
  Widget build(context) {
    return Column(
      children: [
        const Divider(height: 8.0),
        ListTile(
          title: buildRectShape(),
          subtitle: buildRectShape(),
        ),
      ],
    );
  }

  Widget buildRectShape() {
    return Container(
      color: Colors.grey[200],
      width: 150.0,
      height: 25.0,
      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
    );
  }
}
