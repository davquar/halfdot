import 'package:flutter/material.dart';

class NumberedListItem extends StatelessWidget {
  final num number;
  final String item;

  const NumberedListItem({
    super.key,
    required this.number,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(5),
            ),
            child: SizedBox(
              height: 20,
              width: 40,
              child: Text(
                number.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const VerticalDivider(
            width: 4,
            color: Colors.transparent,
          ),
          Expanded(
            child: Text(
              item,
            ),
          ),
        ],
      ),
    );
  }
}
