import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/diary.dart';

class FireStoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collection = 'diaries';

  // 현재 사용자 ID 가져오기
  String? get _currentUserId => _auth.currentUser?.uid;

  // 사용자별 컬렉션 참조
  CollectionReference? get _userDiariesCollection {
    if (_currentUserId == null) return null;
    return _firestore
        .collection(_collection)
        .doc(_currentUserId)
        .collection('entries');
  }

  // 일기 저장
  Future<void> saveDiary(Diary diary) async {
    if (_userDiariesCollection == null) {
      throw DiaryRepositoryException('사용자 인증이 필요합니다');
    }

    try {
      final dateId = _formatDateAsId(diary.createdAt);

      await _userDiariesCollection!.doc(dateId).set(diary.toJson());
    } catch (e) {
      throw DiaryRepositoryException('일기 저장에 실패했습니다: $e');
    }
  }

  // 특정 날짜 일기 조회
  Future<Diary?> getDiaryByDate(DateTime date) async {
    if (_userDiariesCollection == null) {
      throw DiaryRepositoryException('사용자 인증이 필요합니다');
    }

    try {
      final dateId = _formatDateAsId(date);
      final doc = await _userDiariesCollection!.doc(dateId).get();

      if (doc.exists && doc.data() != null) {
        return Diary.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw DiaryRepositoryException('일기 조회에 실패했습니다: $e');
    }
  }

  // 모든 일기 조회(최신순)
  Future<List<Diary>> getAllDiaries() async {
    if (_userDiariesCollection == null) {
      throw DiaryRepositoryException('사용자 인증이 필요합니다');
    }

    try {
      final querySnapshot = await _userDiariesCollection!
          .orderBy(FieldPath.documentId) // 문서 ID로 정렬
          .get();

      return querySnapshot.docs
          .map((doc) => Diary.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DiaryRepositoryException('일기 목록 조회에 실패했습니다: $e');
    }
  }

  // 일기 업데이트
  Future<void> updateDiary(Diary diary) async {
    if (_userDiariesCollection == null) {
      throw DiaryRepositoryException('사용자 인증이 필요합니다');
    }

    try {
      final dateId = _formatDateAsId(diary.createdAt);
      final updatedDiary = diary.copyWith(updatedAt: DateTime.now());

      await _userDiariesCollection!.doc(dateId).update(updatedDiary.toJson());
    } catch (e) {
      throw DiaryRepositoryException('일기 업데이트에 실패했습니다: $e');
    }
  }

  // 일기 삭제
  Future<void> deleteDiaryByDate(DateTime date) async {
    if (_userDiariesCollection == null) {
      throw DiaryRepositoryException('사용자 인증이 필요합니다');
    }

    try {
      final dateId = _formatDateAsId(date);
      await _userDiariesCollection!.doc(dateId).delete();
    } catch (e) {
      throw DiaryRepositoryException('일기 삭제에 실패했습니다: $e');
    }
  }

  // 실시간 일기 목록 스트림
  Stream<List<Diary>> getDiariesStream() {
    if (_userDiariesCollection == null) {
      throw DiaryRepositoryException('사용자 인증이 필요합니다');
    }

    try {
      return _userDiariesCollection!
          .orderBy(FieldPath.documentId)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map(
                  (doc) => Diary.fromJson(doc.data() as Map<String, dynamic>),
                )
                .toList();
          });
    } catch (e) {
      throw DiaryRepositoryException('일기 스트림 조회에 실패했습니다: $e');
    }
  }

  // 특정 날짜 일기 존재 여부 확인
  Future<bool> diaryExistsForDate(DateTime date) async {
    if (_userDiariesCollection == null) {
      throw DiaryRepositoryException('사용자 인증이 필요합니다');
    }

    try {
      final dateId = _formatDateAsId(date);
      final doc = await _userDiariesCollection!.doc(dateId).get();
      return doc.exists;
    } catch (e) {
      throw DiaryRepositoryException('일기 존재 확인에 실패했습니다: $e');
    }
  }

  // 날짜를 문서 ID 형식으로 변환 (YYYY-MM-DD)
  String _formatDateAsId(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}

// 커스텀 예외 클래스
class DiaryRepositoryException implements Exception {
  final String message;

  DiaryRepositoryException(this.message);

  @override
  String toString() => 'DiaryRepositoryException: $message';
}
