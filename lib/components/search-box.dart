import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../constants.dart';

class SearchBox extends StatelessWidget {
  final Function onChanged;
  final Function function;

  const SearchBox({Key key, this.onChanged, this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();
    return Neumorphic(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      style: kNeumorphicStyle.copyWith(
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(25),
        ),
        depth: -5,
        shape: NeumorphicShape.concave,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.search,
              color: kPrimaryColor,
            ),
            onPressed: () {
              function();
              controller.clear();
              FocusScope.of(context).unfocus();
            },
          ),
          hintText: 'Search Here',
          hintStyle: TextStyle(color: kDarkTextColor),
        ),
      ),
    );
  }
}
