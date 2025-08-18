import 'package:babysitter_ham/repository/preference_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final preferenceRepositoryProvider = Provider<PreferenceRepository>((ref) {
  return PreferenceRepositoryImpl();
});
