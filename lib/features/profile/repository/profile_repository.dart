import 'package:bigbucks/models/person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  ),
);

class ProfileRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ProfileRepository(this.auth, this.firestore);

  Future<Person?> getUserDetails() async {
    final personDetails =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();

    return Person.fromMap(personDetails.data()!);
  }
}
