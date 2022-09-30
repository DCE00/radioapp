import 'package:flutter/material.dart';
import 'package:radioapp/constants/appcolors.dart';
import 'package:radioapp/utilities/playbutton.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: AppColors().primaryColor),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: PlayButton(
            iconSize: 100,
            heightSize: 125,
            widthSize: 125,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
