import 'dart:io';

import 'package:bigbucks/common/repository/common_firebase_storage_repository.dart';
import 'package:bigbucks/common/screens/loader.dart';
import 'package:bigbucks/common/utils/utils.dart';
import 'package:bigbucks/features/auth/screens/otp_screen.dart';
import 'package:bigbucks/features/auth/screens/user_information_screen.dart';
import 'package:bigbucks/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository(this.auth, this.firestore);

  Future<UserModel?> getUserData() async {
    var userData = await firestore.collection('users').doc(auth.currentUser!.uid).get();
    UserModel? user;
    if(userData.data()!=null) {
      user = UserModel.fromJson(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            if (!Platform.isAndroid) {
              await auth.signInWithCredential(credential);
            }
          },
          verificationFailed: (FirebaseAuthException exception) {
            throw Exception(exception.message);
          },
          codeSent: (String verificationId, int? resendToken) {
            Navigator.pushNamed(context, OTPScreen.routeName,
                arguments: verificationId);
          },
          codeAutoRetrievalTimeout: (String s) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void verifyOTP(
      BuildContext context, String verificationId, String userOTP) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void saveUserData(
      {required BuildContext context,
      required String name,
      required File? profilePic,
      String? email,
      String? upiID,
      required ProviderRef ref}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = '';

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase('profilePic/$uid', profilePic);
      }

      UserModel user = UserModel(
        name: name,
        phoneNumber: auth.currentUser!.phoneNumber!,
        photoUrl: profilePic != null ? photoUrl : null,
        email: email,
        upiID: upiID,
      );

      await firestore.collection('users').doc(uid).set(user.toJson());
// ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Loader()),
          (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
