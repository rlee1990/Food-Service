import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({Key key, Widget title, Widget leading, List<Widget> actions, bool centerTitle, double elevation, PreferredSizeWidget bottom}) : 
  super(key: key, title: title, actions: actions, centerTitle: centerTitle, elevation: elevation, leading: leading, bottom: bottom);
}