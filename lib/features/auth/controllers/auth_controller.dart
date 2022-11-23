import 'dart:io';

import 'package:bigbucks/features/auth/repository/auth_repository.dart';
import 'package:bigbucks/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository, ref);
});

final userProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController(this.authRepository, this.ref);

  Future<UserModel?> getUserData() {
    return authRepository.getUserData();
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authRepository.verifyOTP(context, verificationId, userOTP);
  }

  void saveUserData(BuildContext context, String name, File? profilePic,
      String? email, String? upiID) {
    authRepository.saveUserData(
      context: context,
      name: name,
      profilePic: profilePic,
      ref: ref,
      upiID: upiID,
      email: email,
    );
  }
}
