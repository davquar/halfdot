import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    required this.msg,
    super.key,
    this.height = 20,
    this.width = 20,
  });

  final String msg;
  final int height;
  final int width;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const Image(
              image: AssetImage('assets/error.png'),
              height: 40,
            ),
            Text(msg),
          ],
        ),
      ),
    );
  }
}
