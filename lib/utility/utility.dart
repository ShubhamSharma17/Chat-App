//* Screen Width
import 'package:flutter/material.dart';

// api key
const String apiKey = "AIzaSyD01JTrPz7lTQcEQqKSswGZIdfVW_FwLcc";

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
//* Screen Height
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

// global object for accessing device screen size
late Size md;

//! UI Spaces
const double _tinySpace = 5.0;
const double _smallSpace = 10.0;
const double _semiMediumSpace = 15.0;
const double _largeSpace = 25.0;
const double _mediumSpace = 20.0;

//* Horizontal Space
const Widget horizontalSpaceTiny = SizedBox(width: _tinySpace);
const Widget horizontalSpaceSmall = SizedBox(width: _smallSpace);
const Widget horizontalSpaceMedium = SizedBox(width: _mediumSpace);
const Widget horizontalSpaceSemiMedium = SizedBox(width: _semiMediumSpace);
const Widget horizontalSpaceLarge = SizedBox(width: _largeSpace);

//Variable Horizontal Space
Widget horizontalSpace(double width) => SizedBox(width: width);

//* Vertical Space
const Widget verticalSpaceTiny = SizedBox(height: _tinySpace);
const Widget verticalSpaceSmall = SizedBox(height: _smallSpace);
const Widget verticalSpaceMedium = SizedBox(height: _mediumSpace);
const Widget verticalSpacesSemiMedium = SizedBox(height: _semiMediumSpace);
const Widget verticalSpacesLarge = SizedBox(height: _largeSpace);

//Variable Vertical Space
Widget verticalSpace(double height) => SizedBox(height: height);

// custom sized box
class CustomSizedBox extends StatelessWidget {
  final double? height;
  final double? width;
  const CustomSizedBox({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
