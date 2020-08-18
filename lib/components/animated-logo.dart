import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:untitled_goodreads_project/constants.dart';

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({Key key, this.text}) : super(key: key);

  @override
  _AnimatedLogoState createState() => _AnimatedLogoState();

  final List<String> text;
}

class _AnimatedLogoState extends State<AnimatedLogo> {
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: TyperAnimatedTextKit(
        textAlign: TextAlign.center,
        speed: Duration(milliseconds: 100),
        alignment: Alignment.center,
        text: widget.text,
        textStyle: Theme.of(context)
            .textTheme
            .headline5
            .copyWith(color: kSecondaryColor),
        onFinished: () {
          setState(() {});
        },
      ),
    );
  }
}
