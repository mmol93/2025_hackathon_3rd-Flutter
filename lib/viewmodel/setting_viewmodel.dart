import 'package:babysitter_ham/models/baby_info.dart';
import 'package:babysitter_ham/provider/firestore_provider.dart';
import 'package:babysitter_ham/repository/firestore_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BabyInfoStreamNotifier extends StreamNotifier<BabyInfo> {
  FireStoreRepository? _fireStoreRepository;

  FireStoreRepository get fireStoreRepository {
    _fireStoreRepository ??= ref.read(fireStoreProvider);
    return _fireStoreRepository!;
  }

  @override
  Stream<BabyInfo> build() {
    return fireStoreRepository.getBabyInfoStream();
  }

  // 저장
  Future<void> saveDiary(BabyInfo babyInfo) async {
    await fireStoreRepository.saveBabyInfo(babyInfo);
  }
}

final babyInfoStreamProvider =
    StreamNotifierProvider.autoDispose<BabyInfoStreamNotifier, BabyInfo>(
      () => BabyInfoStreamNotifier(),
    );
