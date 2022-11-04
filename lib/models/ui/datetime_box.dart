import 'package:flutter/material.dart';

class DateTimeBox extends StatelessWidget {
  const DateTimeBox({
    required this.text,
    required this.onPressed,
    super.key,
  });

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).dialogBackgroundColor,
        ),
        child: TextButton.icon(
          style: const ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: onPressed,
          icon: Icon(
            Icons.calendar_month,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          label: Text(
            text,
            key: key,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
      ),
    );
  }
}
