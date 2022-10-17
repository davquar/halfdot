import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  final String cardTitle;
  final String msg;
  final int height;
  final int width;

  const ErrorCard({
    super.key,
    required this.cardTitle,
    required this.msg,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Image(
                  image: AssetImage("assets/error.png"),
                  height: 40,
                ),
                Text(msg),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
