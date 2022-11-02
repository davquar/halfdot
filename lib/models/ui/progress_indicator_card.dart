import 'package:flutter/material.dart';

class ProgressIndicatorCard extends StatelessWidget {
  const ProgressIndicatorCard({
    super.key,
    this.height = 20,
    this.width = 20,
  });

  final int height;
  final int width;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Column(
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
