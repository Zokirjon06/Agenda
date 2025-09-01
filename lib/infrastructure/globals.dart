import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppSvg {
  static final AppSvg _instance = AppSvg._();
  static AppSvg get instance => _instance;
  AppSvg._();

  SvgPicture fromAsset(String name,
      {BoxFit? fit,
      Color? color,
      required double height,
      required double width}) {
    return SvgPicture.asset(
      height: height,
      width: width,
      name,
      fit: fit ?? BoxFit.contain,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }
}