
import 'package:currency/Controller/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateWidget extends ConsumerWidget {
  const DateWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sz = MediaQuery.sizeOf(context);
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final update = ref.watch(currencyState.select((val) => val.lastUpdated));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 05),
      decoration: BoxDecoration(borderRadius: .circular(15), color: c.primary),
      height: sz.height * 0.05,
      width: sz.width * 1.0,
      child: Align(
        alignment: .centerLeft,
        child: Text('Last Updated: $update', style: t.bodySmall),
      ),
    );
  }
}