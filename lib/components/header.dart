import 'package:aai_chennai/components/date_widget.dart';
import 'package:aai_chennai/components/logo.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {

    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [LogoPlaceHolder(), DateTimeHolder()],
    );
  }
}
