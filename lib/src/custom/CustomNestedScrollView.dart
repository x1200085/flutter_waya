import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_waya/src/constant/WayColor.dart';
import 'package:flutter_waya/src/utils/MediaQueryUtils.dart';

class CustomNestedScrollView extends StatefulWidget {
  final ScrollController controller;
  final Widget title;
  final Widget leading;
  final Widget topBody;
  final Widget tabBarBody;
  final Widget body;
  final Color backgroundColor;
  final double expandedHeight;
  final Size preferredSize;
  final bool pinned;
  final bool containsStatusBar;
  final bool floating;
  final bool centerTitle;
  final ScrollPhysics physics;
  final CollapseMode collapseMode;

  CustomNestedScrollView(
      {Key key,
      this.title,
      this.pinned: true,
      this.floating: true,
      this.centerTitle,
      this.backgroundColor,
      this.topBody,
      this.tabBarBody,
      this.physics,
      this.containsStatusBar: true,
      this.expandedHeight,
      this.preferredSize,
      this.collapseMode: CollapseMode.parallax,
      this.body,
      this.leading,
      this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CustomNestedScrollViewState();
  }
}

class CustomNestedScrollViewState extends State<CustomNestedScrollView> {
  GlobalKey containerKey = GlobalKey();
  GlobalKey preferredSizeKey = GlobalKey();
  bool showNestedScrollView = false;
  double expandedHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      double containerHeight = containerKey.currentContext.findRenderObject().paintBounds.size.height;
      double preferredSizeHeight = preferredSizeKey.currentContext.findRenderObject().paintBounds.size.height;
      expandedHeight = widget.containsStatusBar
          ? containerHeight + preferredSizeHeight - MediaQueryUtils.getStatusBarHeight()
          : containerHeight + preferredSizeHeight;
      setState(() {
        showNestedScrollView = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return showNestedScrollView
        ? NestedScrollView(
            controller: widget.controller,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  leading: widget.leading ?? Container(),
                  pinned: widget.pinned,
                  floating: widget.floating,
                  centerTitle: widget.centerTitle ?? true,
                  title: widget.title,
                  backgroundColor: widget.backgroundColor ?? getColors(background),
                  expandedHeight: expandedHeight,
                  flexibleSpace: FlexibleSpaceBar(collapseMode: widget.collapseMode, background: widget.topBody),
                  bottom: PreferredSize(child: widget.tabBarBody, preferredSize: widget.preferredSize),
                ),
              ];
            },
            body: widget.body,
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(key: containerKey, child: widget.topBody),
              PreferredSize(key: preferredSizeKey, child: widget.tabBarBody, preferredSize: widget.preferredSize)
            ],
          );
  }
}
