import 'package:flutter/material.dart';

import '../../Global/global.dart';

class DisplayAppBar extends StatelessWidget {
  const DisplayAppBar({
    Key? key,
    required this.darkModeEnabled,
  }) : super(key: key);

  final bool darkModeEnabled;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 60,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
            margin: const EdgeInsets.only(left: 14, top: 10, bottom: 10),
            padding: const EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: darkModeEnabled
                  ? GlobalTraits.neuShadowsCircularDark
                  : GlobalTraits.neuShadowsCircular,
              color: darkModeEnabled
                  ? GlobalTraits.bgGlobalColorDark
                  : GlobalTraits.bgGlobalColor,
            ),
            child: Icon(
              Icons.arrow_back,
              color: darkModeEnabled
                  ? GlobalTraits.bgGlobalColor
                  : GlobalTraits.bgGlobalColorDark,
            )),
      ),
      title: Text(
        "Profile",
        style: TextStyle(
            color: darkModeEnabled
                ? GlobalTraits.bgGlobalColor
                : GlobalTraits.bgGlobalColorDark,
            fontSize: 32),
      ),
    );
  }
}
