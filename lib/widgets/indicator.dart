import 'package:flutter/material.dart';

// CircularProgressIndicator indicator(Color c) {
//   return
// }
class GlobalIndicator extends StatelessWidget {
  final Color c;
  const GlobalIndicator({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: c,
      padding: const EdgeInsets.all(0),
      strokeWidth: 4,
    );
  }
}
