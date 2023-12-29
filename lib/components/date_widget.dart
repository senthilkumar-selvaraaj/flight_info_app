import 'dart:async';
import 'package:aai_chennai/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateTimeHolder extends StatefulWidget {
  const DateTimeHolder({super.key});

  @override
  State<DateTimeHolder> createState() => _DateTimeHolderState();
}

class _DateTimeHolderState extends State<DateTimeHolder> {
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return MouseRegion(
      onEnter: (event) {
        print("Mouse Entered");
      },
      onExit: (event) {
        print("Mouse Exited");
      },
      onHover: (event) {
        print("Mouser Hover");
      },
      child: Container(
        decoration: ShapeDecoration(
          color: theme.dateTimeBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          shadows: const [],
        ),
        padding: const EdgeInsets.only(right: 15, bottom: 7.0, top: 7.0),
        width: 220,
        height: 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              DateFormat('hh:mm a').format(DateTime.now()),
              style: TextStyle(fontSize: 18, color: theme.dateTimeColor, fontWeight: FontWeight.w500),
            ),
            // SizedBox(height: 5,),
            Text(
              DateFormat('EEEEE, dd MMMM yyyy').format(DateTime.now()),
              style: TextStyle(fontSize: 12, color: theme.dateTimeColor, fontWeight: FontWeight.w400),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}
