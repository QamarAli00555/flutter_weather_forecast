import 'package:flutter/material.dart';

class NoSearchResults extends StatelessWidget {
  const NoSearchResults({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                fit: BoxFit.contain, "assets/icons/optimized_search.png"),
            const SizedBox(width: 20),
            Text(text,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500))
          ],
        ));
  }
}
