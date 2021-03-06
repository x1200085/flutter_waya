import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderWidget<T extends ChangeNotifier> extends StatelessWidget {
  // Provider
  final Create<T> create;
  final ValueWidgetBuilder<T> builder;

  ProviderWidget({@required this.builder, @required this.create});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: create, child: Consumer<T>(builder: builder));
  }
}
