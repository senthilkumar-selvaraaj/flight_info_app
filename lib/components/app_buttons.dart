
import 'package:aai_chennai/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilledActionButton extends StatefulWidget {
  final Function() didTapped;
  final String title;
  final double height;
  final double width;
  final bool showCircularBar;
  const FilledActionButton({super.key, required this.title, this.height = 50, this.width = 160, this.showCircularBar = false, required this.didTapped});

  @override
  State<FilledActionButton> createState() => _FilledActionButtonState();
}

class _FilledActionButtonState extends State<FilledActionButton> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return GestureDetector(onTap: widget.didTapped, child: SizedBox(
      width: widget.width,
      height: widget.height,
      child:
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(decoration: ShapeDecoration(
        color: theme.loginButtonBgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side:    BorderSide(width: 1.0, color: theme.loginButtonBgColor)
        ),
      ), child: Center(
        child: widget.showCircularBar ? const CircularProgressIndicator(color: Colors.white,) : Text(
              widget.title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white),
            ),
      ),),)
      
    ));
  }
}

class BorderedActionButton extends StatefulWidget {
  final String title;
  final Function() didTapped;
  final double height;
  final double width;
  final bool showCircularBar;
  final AppTheme theme;
  const BorderedActionButton({super.key, required this.title, this.height = 50, this.width = 160, required this.theme , this.showCircularBar = false, required this.didTapped});

  @override
  State<BorderedActionButton> createState() => _BorderedActionButtonState();
}

class _BorderedActionButtonState extends State<BorderedActionButton> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;

    return GestureDetector(onTap: widget.didTapped, child: SizedBox(
      width: widget.width,
      height: widget.height,
      child:
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(decoration: ShapeDecoration(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side:  const BorderSide(
                width: 2.0,
                color: AppColors.primaryBlue,
              )
        ),
        shadows: const [],
      ), child: Center(
        child: widget.showCircularBar ?  CircularProgressIndicator(color: widget.theme.flightBRDTextColor,) : Text(
              widget.title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: theme.loginButtonBgColor),
            ),
      ),),)
      
    ));
  }
}


class ConfirmActionButton extends StatelessWidget {
  final String title;
  final Function() didTapped;
  final double height;
  final double width;
  const ConfirmActionButton({super.key, required this.title, this.height = 50, this.width = 160, required this.didTapped});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        focusNode: null,
        autofocus: false,
          style: ElevatedButton.styleFrom(
              backgroundColor: Provider.of<ThemeNotifier>(context).isDark ? AppColors.white : AppColors.secondaryBlue,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              side:  BorderSide(
                width: 2.0,
                color: Provider.of<ThemeNotifier>(context).isDark ? AppColors.white : AppColors.primaryBlue,
              ),
              shadowColor: Colors.transparent),
          onPressed: didTapped,
          child: Text(
            title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Provider.of<ThemeNotifier>(context).isDark ? AppColors.secondaryBlue : AppColors.white) ,
          )),
    );
  }
}



class CancelActionButton extends StatelessWidget {
  final String title;
  final Function() didTapped;
  final double height;
  final double width;
  const CancelActionButton({super.key, required this.title, this.height = 50, this.width = 160, required this.didTapped});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,

      child: ElevatedButton(
        autofocus: false,
        focusNode: null,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              side:  BorderSide(
                width: 2.0,
                color: Provider.of<ThemeNotifier>(context).isDark ? Colors.white :  AppColors.primaryBlue,
              ),
              shadowColor: Colors.transparent),
          onPressed: didTapped,
          child: Text(
            title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: !Provider.of<ThemeNotifier>(context).isDark ? AppColors.secondaryBlue : AppColors.white) ,
          )),
    );
  }
}



