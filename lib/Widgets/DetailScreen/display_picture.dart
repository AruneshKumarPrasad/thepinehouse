import 'package:flutter/material.dart';

import '../../Global/global.dart';

class DisplayPicture extends StatelessWidget {
  const DisplayPicture({
    Key? key,
    required this.darkModeEnabled,
    required this.profile,
  }) : super(key: key);

  final bool darkModeEnabled;
  final Map<String, dynamic> profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 250,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: darkModeEnabled
            ? GlobalTraits.bgGlobalColorDark
            : GlobalTraits.bgGlobalColor,
        boxShadow: darkModeEnabled
            ? GlobalTraits.neuShadowsDark
            : GlobalTraits.neuShadows,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Image.network(
          profile["ImageURL"],
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
