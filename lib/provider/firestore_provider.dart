import 'package:babysitter_ham/repository/firestore_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fireStoreProvider = Provider<FireStoreRepository>((ref) {
  return FireStoreRepository();
});
