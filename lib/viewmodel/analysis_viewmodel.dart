import 'dart:async';

import 'package:babysitter_ham/models/analysis.dart';
import 'package:babysitter_ham/provider/firestore_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalysisNotifier extends AsyncNotifier<AiResponse?> {
  @override
  Future<AiResponse?> build() async {
    final fireStoreRepository = ref.watch(fireStoreProvider);
    return await fireStoreRepository.getRecentAnalysis();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final fireStoreRepository = ref.read(fireStoreProvider);
      return await fireStoreRepository.getRecentAnalysis();
    });
  }
}

final analysisProvider = AsyncNotifierProvider<AnalysisNotifier,
    AiResponse?>(() {
  return AnalysisNotifier();
});
