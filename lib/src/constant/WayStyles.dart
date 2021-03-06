import 'package:flutter/material.dart';
import 'package:flutter_waya/src/utils/BaseUtils.dart';

import 'WayColor.dart';
import 'WayConstant.dart';

const double radiusLocal = WayConstant.Radius;
const double fontSize = WayConstant.fontSize;

class WayStyles {
  //统一所有阴影效果
  static List<BoxShadow> boxShadow() {
    return [
      BoxShadow(color: getColors(boxShadowColor), blurRadius: radiusLocal, spreadRadius: 1, offset: Offset(0, 3)),
    ];
  }

  //left right  margin or padding 20
  static EdgeInsetsGeometry edgeInsetsHorizontal({double width: 20}) {
    return EdgeInsets.symmetric(horizontal: BaseUtils.getWidth(width));
  }

  static Decoration borderRadiusTop({Color color, double radius}) {
    return BoxDecoration(
      color: color ?? getColors(white),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius ?? radiusLocal), topRight: Radius.circular(radius ?? radiusLocal)),
    );
  }

  //top bottom  margin or padding 20
  static EdgeInsetsGeometry edgeInsetsVertical({double height: 20}) {
    return EdgeInsets.symmetric(vertical: BaseUtils.getHeight(height));
  }

  //统一白色背景 圆角
  static Decoration containerWhiteRadius({Color color, double radius, bool shadow: false}) {
    return BoxDecoration(
      color: color ?? getColors(white),
      borderRadius: BorderRadius.circular(radius ?? radiusLocal),
      boxShadow: shadow ? boxShadow() : null,
    );
  }

  //统一 白色背景 圆角 边框
  static Decoration containerRadiusWidth({Color color, double width, Color widthColor, double radius}) {
    return BoxDecoration(
        color: color ?? getColors(white),
        borderRadius: BorderRadius.circular(radius ?? radiusLocal),
        border: Border.all(width: width ?? BaseUtils.getWidth(1), color: widthColor ?? getColors(background)));
  }

  //统一下划线样式
  static Decoration containerUnderlineBackground({Color color, double width, Color underlineColor}) {
    return BoxDecoration(
        color: color,
        border: Border(
            bottom:
                BorderSide(width: width ?? BaseUtils.getHeight(1), color: underlineColor ?? getColors(background))));
  }

  //统一上划线样式
  static Decoration containerTopLineBackground({Color color}) {
    return BoxDecoration(color: color, border: Border(top: BorderSide(color: getColors(background))));
  }

  static TextStyle textStyleWhite({double fontSize, TextStyle textStyle}) {
    return mergeTextStyle(
        textStyle, TextStyle(color: getColors(white), fontSize: fontSize, decoration: TextDecoration.none));
  }

  static TextStyle textStyleBlack70({double fontSize, TextStyle textStyle}) {
    return mergeTextStyle(
        textStyle, TextStyle(color: getColors(black70), fontSize: fontSize, decoration: TextDecoration.none));
  }

  static TextStyle textStyleBlue({double fontSize, TextStyle textStyle}) {
    return mergeTextStyle(
        textStyle, TextStyle(color: getColors(blue), fontSize: fontSize, decoration: TextDecoration.none));
  }

  static TextStyle textStyleBlack30({double fontSize, TextStyle textStyle}) {
    return mergeTextStyle(
        textStyle, TextStyle(color: getColors(black30), fontSize: fontSize, decoration: TextDecoration.none));
  }

  //以上是多种颜色字体 样式

  //start 合并到 end
  static TextStyle mergeTextStyle(TextStyle startStyle, TextStyle endStyle) {
    if (startStyle != null && endStyle != null) {
      endStyle.merge(startStyle);
    }
    return endStyle;
  }
}
