import 'package:flight_info_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';

class StatusIcon extends StatefulWidget {
  final IconData icon;
  final bool showBadge;
  const StatusIcon({super.key, required this.icon, this.showBadge = true});

  @override
  State<StatusIcon> createState() => _StatusIconState();
}

class _StatusIconState extends State<StatusIcon> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<ThemeNotifier>(context).currentTheme;
    return GestureDetector(
      onTap: () {
        if (widget.icon == Icons.contrast){
            Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
        }
      },
      child: MouseRegion(child: Stack(
        children: [
          Container(
              margin:
                  const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
              decoration: ShapeDecoration(
                color: theme.statusIconBgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                shadows: const [],
              ),
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  widget.icon,
                  color: theme.statusIconColor,
                ),
              )),
          Visibility(visible: widget.showBadge, child: Positioned(
              top: 7,
              right: 7,
              child: Container(
                height: 10,
                width: 10,
                decoration: ShapeDecoration(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  shadows: const [],
                ),
              )))
        ],
      ),
      onEnter: (p){
        if (widget.icon == Icons.contrast){
          //   showPopover(
          //   context: context,
          //   backgroundColor: theme.popOverBackgroundColor,
          //   bodyBuilder: (context) => Center(child: Text("Switch to ${Provider.of<ThemeNotifier>(context).isDark ? 'Light' : 'Dark'} Mode", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.white),)),
          //   onPop: () => print('Popover was popped!'),
          //   direction: PopoverDirection.bottom,
          //   barrierColor: Colors.transparent,
          //   width: 160,
          //   height: 42,
          //   arrowHeight: 10,
          //   arrowWidth: 20,
          //   transition: PopoverTransition.other,
          //   transitionDuration: const Duration(milliseconds: 50)
          // );
        }
          
      },
      onExit: (p){
        
      },
      ),
    );
  }
}
