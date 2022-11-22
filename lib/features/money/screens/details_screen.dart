import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailsScreen extends ConsumerWidget {
  static const String routeName = '/details-screen';
  final String userId;
  final String name;
  final String photoUrl;

  const DetailsScreen({
    required this.userId,
    required this.name,
    required this.photoUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
    );
  }
}
