import 'dart:io';

import 'package:bigbucks/features/auth/repository/auth_repository.dart';
import 'package:bigbucks/models/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userdataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<Person?> getUserData() async {
    Person? person = await authRepository.getCurrentUserData();
    return person;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(
      context,
      phoneNumber,
    );
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }

  void sendDataToFirebase(
    BuildContext context,
    String name,
    String email,
    String upiID,
    File? profilePic,
  ) {
    authRepository.saveDataToFirebase(
      name: name,
      email: email,
      upiID: upiID,
      profilePic: profilePic,
      ref: ref,
      context: context,
    );
  }
}
