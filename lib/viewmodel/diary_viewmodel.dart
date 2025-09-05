import 'package:babysitter_ham/models/diary.dart';
import 'package:babysitter_ham/provider/firestore_provider.dart';
import 'package:babysitter_ham/repository/firestore_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiaryStreamNotifier extends StreamNotifier<List<Diary>> {
  FireStoreRepository? _fireStoreRepository;

  FireStoreRepository get fireStoreRepository {
    _fireStoreRepository ??= ref.read(fireStoreProvider);
    return _fireStoreRepository!;
  }

  @override
  Stream<List<Diary>> build() {
    return fireStoreRepository.getDiariesStream();
  }

  Future<void> saveDiary(Diary diary) async {
    await fireStoreRepository.saveDiary(diary);
  }
}

final diaryStreamProvider =
    StreamNotifierProvider.autoDispose<DiaryStreamNotifier, List<Diary>>(
      () => DiaryStreamNotifier(),
    );
