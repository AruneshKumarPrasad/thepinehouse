import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'models.dart';

class FireHelp {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> fireAddData(Model profile) async {
    await db.collection("profiles").doc(profile.profileID).set(
      {
        "ID": profile.profileID,
        "Name": profile.nameInProfile,
        "Phone": profile.phoneNumber,
        "Age": profile.age,
        "Department": profile.department,
        "ImageURL": profile.imageLink,
      },
    );
  }

  Reference referenceRoot = FirebaseStorage.instance.ref();

  Future<String?> fireStorageUpload(String fileName, File imageFile) async {
    Reference referenceDirImages = referenceRoot.child('profile_images');
    Reference referenceForUpload = referenceDirImages.child("pic$fileName");
    try {
      //Store the file on Database
      await referenceForUpload.putFile(imageFile);
      //Get and Store the URL from Database
      final url = await referenceForUpload.getDownloadURL();
      return url;
    } catch (error) {
      return null;
    }
  }

  Future<void> startDelete(
      {required imageFileName,
      required documentID,
      required BuildContext ctx}) async {
    // Delete Data
    db.collection("profiles").doc(documentID).delete().then(
          (doc) => ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Text("Deleted"),
              ),
              behavior: SnackBarBehavior.floating,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              duration: const Duration(milliseconds: 750),
            ),
          ),
          onError: (e) => ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Text("Delete Failed"),
              ),
              behavior: SnackBarBehavior.floating,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              duration: const Duration(milliseconds: 750),
            ),
          ),
        );

    // Delete Image ref
    Reference referenceDirImages = referenceRoot.child('profile_images');
    Reference referenceForUpload = referenceDirImages.child(imageFileName);

    // Delete image here
    await referenceForUpload.delete();
  }
}
