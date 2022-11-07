import 'package:flutter/material.dart';

import '../../Global/global.dart';

class DisplayDetails extends StatelessWidget {
  const DisplayDetails({
    Key? key,
    required this.darkModeEnabled,
    required this.profile,
  }) : super(key: key);

  final bool darkModeEnabled;
  final Map<String, dynamic> profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: double.infinity,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name :  ${profile["Name"]}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Phone Number :  ${profile["Phone"]}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Age :  ${profile["Age"]}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Department :  ${profile["Department"]}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  "More coming soon!",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
