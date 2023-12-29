
import 'package:aai_chennai/components/powerd_by.dart';
import 'package:aai_chennai/components/status_icon_list.dart';
import 'package:flutter/material.dart';

class Footter extends StatelessWidget {
  const Footter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [PowerdBy(), StatusList()],
    );
  }
}
