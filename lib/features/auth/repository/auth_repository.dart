import 'dart:io';

import 'package:bigbucks/common/repository/common_firebase_storage_repository.dart';
import 'package:bigbucks/common/utils/utils.dart';
import 'package:bigbucks/features/auth/screens/otp_screen.dart';
import 'package:bigbucks/features/auth/screens/user_information.dart';
import 'package:bigbucks/features/home/screens/home_screen.dart';
import 'package:bigbucks/models/person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
      auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({
    required this.auth,
    required this.firestore,
  });

  Future<Person?> getCurrentUserData() async {
    var personData =
        await firestore.collection("users").doc(auth.currentUser?.uid).get();
    Person? person;
    if (personData.data() != null) {
      person = Person.fromMap(personData.data()!);
    }
    return person;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: ((verificationId, forceResendingToken) async {
          Navigator.of(context).pushNamed(
            OTPScreen.routeName,
            arguments: verificationId,
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );

      await auth.signInWithCredential(phoneAuthCredential);

      Navigator.of(context).pushNamedAndRemoveUntil(
        UserInformation.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void saveDataToFirebase({
    required String name,
    required String email,
    required String upiID,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'profilePic/$uid',
              profilePic,
            );
      }

      print(auth.currentUser!.phoneNumber);

      var person = Person(
        name: name,
        phoneNumber: auth.currentUser!.phoneNumber!,
        email: email,
        upiID: upiID,
        photoUrl: photoUrl,
      );

      await firestore.collection("users").doc(uid).set(person.toMap());

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) {
          return const HomeScreen();
        }),
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
