import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_waya/waya.dart';
import 'package:flutter_waya/src/constant/BaseEnum.dart';
import 'package:flutter_waya/src/utils/MediaQueryUtils.dart';

isDebug() {
  return !kReleaseMode;
}

class BaseUtils {
  static Timer timerInfo;

  // 截屏
  static capture(GlobalKey globalKey) async {
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    var image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData;
  }

  // 复制到粘贴板
  static copy(text) {
    Clipboard.setData(new ClipboardData(text: text));
  }

  //分页 计算总页数
  static totalPageCount(int recordCount, int pageSize) {
    int totalPage = recordCount ~/ pageSize;
    if (recordCount % pageSize != 0) {
      totalPage += 1;
    }
    return totalPage;
  }

  //时间戳转换
  static stampToDate(int s, {DateType dateType = DateType.dateTime, bool micro}) {
    if (micro == null) {
      micro = false;
    }
    if (micro) {
      //微秒
      return formatDate(DateTime.fromMicrosecondsSinceEpoch(s).toString(), dateType);
    } else {
      //毫秒
      return formatDate(DateTime.fromMillisecondsSinceEpoch(s).toString(), dateType);
    }
  }

  static formatDate(String date, [DateType dateType = DateType.dateTime]) {
    DateTime time = DateTime.parse(date);
    switch (dateType) {
      case DateType.dateTime:
        return time.year.toString() +
            '-' +
            time.month.toString().padLeft(2, '0') +
            '-' +
            time.day.toString().padLeft(2, '0') +
            ' ' +
            time.hour.toString().padLeft(2, '0') +
            ':' +
            time.second.toString().padLeft(2, '0');
      case DateType.data:
        return time.year.toString() +
            '-' +
            time.month.toString().padLeft(2, '0') +
            '-' +
            time.day.toString().padLeft(2, '0');
      case DateType.time:
        return time.hour.toString().padLeft(2, '0') +
            ':' +
            time.minute.toString().padLeft(2, '0') +
            ':' +
            time.second.toString();
      case DateType.monthSecond: //月到分
        return time.month.toString().padLeft(2, '0') +
            '-' +
            time.day.toString().padLeft(2, '0') +
            ' ' +
            time.hour.toString().padLeft(2, '0') +
            '-' +
            time.second.toString().padLeft(2, '0');
    }
  }

//  * 全面屏适配
//  * @returns {number} 返回全面屏对应的16：9 屏幕高度

  static phoneFitHeight(BuildContext context) {
    double h = MediaQuery
        .of(context)
        .size
        .height;
    double s = MediaQuery
        .of(context)
        .devicePixelRatio;
    double y = s * h;

    if (Platform.isAndroid) {
      if (y < 1000) {
        //720p以下手机
        return h;
      } else if (y > 1000 && y < 1300) {
        //720p 16:9
        return h;
      } else if (y > 1300 && y < 1650) {
        //720p 18:9
        return 1280 / s;
      } else if (y > 1700 && y < 1930) {
        //1080p 16:9
        return h;
      } else if (y > 1930 && y < 2400) {
        //1080p 18:9 19.5:9
        return 1920 / s;
      } else if (y > 2400 && y < 2560) {
        //2k 16:9
        return h;
      } else if (y > 2560 && y < 3300) {
        //2k 18:9  19.5:9
        return 2560 / s;
      } else {
        return h;
      }
    } else if (Platform.isIOS) {
      if (y < 1400) {
        //4.7寸 16:9
        return h;
      } else if (y > 1400 && y < 1850) {
        //iphone xr 18:9
        return 1334 / s;
      } else if (y > 1700 && y < 1800) {
        //iphone 11 18:9
        return 1334 / s;
      } else if (y > 1850 && y < 2300) {
        //iphone plus 16:9
        return h;
      } else if (y > 2300) {
        //iphone x  18:9
        return 2208 / s;
      }
    } else {
      return h;
    }
  }

  //相对iphone 6s 尺寸设计稿 高
  static getHeight([double height, bool intType]) {
    double h;
    if (height == null || height == 0) {
      h = MediaQueryUtils
          .getSize()
          .height;
    } else {
      //  h = (height / 667) * phoneFitHeight(context);
      h = (height / 667) * MediaQueryUtils.getHeight();
    }
    return intType == true ? h.toInt() : h;
  }

  //相对iphone 6s 尺寸设计稿 宽
  static getWidth([double width, bool intType]) {
    double w;
    if (width == null || width == 0) {
      w = MediaQueryUtils
          .getSize()
          .width;
    } else {
      w = (width / 375) * MediaQueryUtils.getWidth();
    }
    return intType == true ? w.toInt() : w;
  }

  //关闭键盘
  static focusScope(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static timerUtils(Duration duration, [Function function]) {
    timerInfo = Timer(duration, () {
      if (function != null) function();
      timerInfo.cancel();
    });
    return timerInfo;
  }

  static timePeriodic(Duration duration, [Function function]) {
    //需要手动释放timer
    timerInfo = Timer.periodic(duration, (covariant) {
      if (function is Function) function();
    });
    return timerInfo;
  }

  static cancelTimer() {
    if (timerInfo != null) timerInfo.cancel();
  }

  // md5 加密
  static setMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  static setStatusBarLight(bool isLight) {
    const color = Color(0x00000000);
    if (isLight is bool) {
      if (isLight) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          systemNavigationBarDividerColor: color,
          statusBarColor: color,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ));
      } else {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          systemNavigationBarDividerColor: color,
          statusBarColor: color,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ));
      }
    }
  }

  static popBack(navigator) {
    Future future = navigator;
    future.then((value) {
      if (value == null) {
        BaseNavigatorUtils.getInstance().pop();
      } else {
        BaseNavigatorUtils.getInstance().pop(value);
      }
    });
  }
//   // 确保输入的全部是数字
//
//  static allAreNum(number) {
//    number = number.hashCode(/[^\d]/g, '' + '');
//    return number;
//  }
}
