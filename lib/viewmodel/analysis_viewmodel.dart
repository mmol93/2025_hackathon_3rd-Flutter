import 'dart:async';

import 'package:babysitter_ham/models/analysis.dart';
import 'package:babysitter_ham/provider/firestore_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalysisNotifier extends StreamNotifier<AiResponse?> {
  @override
  Stream<AiResponse?> build() {
    final fireStoreRepository = ref.watch(fireStoreProvider);
    return fireStoreRepository.getRecentAnalysisStream();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final analysisProvider = StreamNotifierProvider<AnalysisNotifier, AiResponse?>(
  () => AnalysisNotifier(),
);
