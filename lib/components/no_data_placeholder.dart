import 'package:aai_chennai/utils/themes.dart';
import 'package:flutter/material.dart';

class NoDataView extends StatelessWidget {
  const NoDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(height: 350, width: 350, child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Image(image: AssetImage('assets/images/no_data_placeholder.png'), fit: BoxFit.contain,),  Text("No Data Found", style:  TextStyle(color: AppColors.secondaryGrey, fontSize: 20),)],)));
  }
}