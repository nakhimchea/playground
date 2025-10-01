import 'package:flutter/material.dart';

class SubAiModelItem extends StatelessWidget {
  final String title;
  const SubAiModelItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 153, 149, 149).withOpacity(.8),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall!.copyWith(height: 1.2),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
