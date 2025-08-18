import 'package:babysitter_ham/models/diary.dart';
import 'package:babysitter_ham/provider/firestore_provider.dart';
import 'package:babysitter_ham/repository/firestore_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiaryViewmodel extends FamilyAsyncNotifier<List<Diary>, bool> {
  late FireStoreRepository _fireStoreRepository;

  @override
  Future<List<Diary>> build(bool shouldLoadInitialData) async {
    _fireStoreRepository = ref.watch(fireStoreProvider);

    if (shouldLoadInitialData) {
      // 초기 데이터 로드
      return await _fireStoreRepository.getAllDiaries();
    } else {
      // 빈 리스트 반환
      return [];
    }
  }

  // 일기 저장 후 데이터 새로고침
  Future<void> saveDiary(Diary diary) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _fireStoreRepository.saveDiary(diary);
      return await _fireStoreRepository.getAllDiaries();
    });
  }

  // 데이터 수동 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return await _fireStoreRepository.getAllDiaries();
    });
  }

  // 일기 삭제 후 새로고침
  Future<void> deleteDiary(DateTime date) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _fireStoreRepository.deleteDiaryByDate(date);
      return await _fireStoreRepository.getAllDiaries();
    });
  }
}

final diaryViewmodelProvider =
    AsyncNotifierProvider.family<DiaryViewmodel, List<Diary>, bool>(
      () => DiaryViewmodel(),
    );
