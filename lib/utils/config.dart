//set constant config here
import 'package:flutter/material.dart';

class Config {
  static MediaQueryData? mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static String base_url = 'http://192.168.214.245:8000';

  //width and height initialization
  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData!.size.width;
    screenHeight = mediaQueryData!.size.height;
  }

  static get widthSize {
    return screenWidth;
  }

  static get heightSize {
    return screenHeight;
  }

  static get baseURL {
    return base_url;
  }

  //define spacing height
  static const spaceSmall = SizedBox(
    height: 18,
  );
  static final spaceMedium = SizedBox(
    height: screenHeight! * 0.05,
  );
  static final spaceBig = SizedBox(
    height: screenHeight! * 0.08,
  );

  //textform field border
  static const outlinedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static const focusBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: Colors.blueAccent,
      ));
  static const errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: Colors.orangeAccent,
      ));

  static const primaryColor = Colors.blueAccent;
  static const secondaryColor = Colors.orangeAccent;

}
