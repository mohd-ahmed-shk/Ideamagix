import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final bool? automaticallyImplyLeading;
  final bool? centerTitle;
  final double? leadingWidth;
  final List<Widget>? actions;
  @override
  final Size preferredSize;

  const BaseAppBar(
      {super.key, this.preferredSize = const Size.fromHeight(kToolbarHeight), required this.title, this.automaticallyImplyLeading, this.centerTitle, this.leadingWidth, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leadingWidth: leadingWidth,
      automaticallyImplyLeading: automaticallyImplyLeading ?? false,
      centerTitle: centerTitle ?? false,
      actions: actions,

    );
  }
}
