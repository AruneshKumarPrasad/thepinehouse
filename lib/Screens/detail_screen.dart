import 'package:flutter/material.dart';

import '../Widgets/DetailScreen/display_app_bar.dart';
import '../Widgets/DetailScreen/display_detail.dart';
import '../Widgets/DetailScreen/display_picture.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    Key? key,
    required this.darkModeEnabled,
    required this.profile,
  }) : super(key: key);

  final bool darkModeEnabled;
  final Map<String, dynamic> profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: DisplayAppBar(darkModeEnabled: darkModeEnabled),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 15,
        ),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DisplayPicture(darkModeEnabled: darkModeEnabled, profile: profile),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: DisplayDetails(
                  darkModeEnabled: darkModeEnabled, profile: profile),
            ),
          ],
        ),
      ),
    );
  }
}
