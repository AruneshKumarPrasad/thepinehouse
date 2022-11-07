import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thepinehouse/Helpers/firebase.dart';
import 'package:thepinehouse/Screens/detail_screen.dart';

import '../Global/global.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({
    Key? key,
    required this.darkModeEnabled,
  }) : super(key: key);

  final bool darkModeEnabled;

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  bool _deletePressed = false;

  final Stream<QuerySnapshot> _profileStream =
      FirebaseFirestore.instance.collection('profiles').snapshots();

  Future<void> _performDelete(
      {required String imageName,
      required String docID,
      required BuildContext cText}) async {
    await FireHelp()
        .startDelete(imageFileName: imageName, documentID: docID, ctx: cText);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      child: StreamBuilder<QuerySnapshot>(
        stream: _profileStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          } else {
            List<Map<String, dynamic>> listOfDataMaps =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              return document.data()! as Map<String, dynamic>;
            }).toList();
            return Scrollbar(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 5),
                itemCount: snapshot.data!.docs.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          flex: 9,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DetailScreen(
                                    darkModeEnabled: widget.darkModeEnabled,
                                    profile: listOfDataMaps[index],
                                  ),
                                ),
                              );
                            },
                            child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                height: 80,
                                decoration: BoxDecoration(
                                  boxShadow: widget.darkModeEnabled
                                      ? GlobalTraits.neuShadowsDark
                                      : GlobalTraits.neuShadows,
                                  color: widget.darkModeEnabled
                                      ? GlobalTraits.bgGlobalColorDark
                                      : GlobalTraits.bgGlobalColor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AnimatedContainer(
                                      height: 60,
                                      width: 60,
                                      padding: const EdgeInsets.all(5),
                                      duration:
                                          const Duration(milliseconds: 200),
                                      decoration: BoxDecoration(
                                        boxShadow: widget.darkModeEnabled
                                            ? GlobalTraits.neuShadowsDark
                                            : GlobalTraits.neuShadows,
                                        color: widget.darkModeEnabled
                                            ? GlobalTraits.bgGlobalColorDark
                                            : GlobalTraits.bgGlobalColor,
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        child: Image.network(
                                          listOfDataMaps[index]["ImageURL"],
                                          alignment: Alignment.center,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 32,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            listOfDataMaps[index]["Name"],
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            listOfDataMaps[index]["Department"],
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        Flexible(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _deletePressed = !_deletePressed;
                                _performDelete(
                                    imageName:
                                        "pic${listOfDataMaps[index]["ID"]}",
                                    docID: listOfDataMaps[index]["ID"],
                                    cText: context);
                                _deletePressed = !_deletePressed;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              height: 80,
                              width: 65,
                              decoration: BoxDecoration(
                                boxShadow: _deletePressed
                                    ? []
                                    : widget.darkModeEnabled
                                        ? GlobalTraits.neuShadowsDark
                                        : GlobalTraits.neuShadows,
                                color: widget.darkModeEnabled
                                    ? GlobalTraits.bgGlobalColorDark
                                    : GlobalTraits.bgGlobalColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: const Center(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Icon(
                                    Icons.delete,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
