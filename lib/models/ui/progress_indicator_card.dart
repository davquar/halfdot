import 'package:flutter/material.dart';

class ProgressIndicatorCard extends StatelessWidget {
  final String cardTitle;
  final int height;
  final int width;

  const ProgressIndicatorCard({
    super.key,
    required this.cardTitle,
    this.height = 20,
    this.width = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(
            cardTitle,
            style: Theme.of(context).textTheme.headline6,
          ),
          const Padding(
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
