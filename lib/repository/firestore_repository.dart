import 'package:babysitter_ham/models/analysis.dart';
import 'package:babysitter_ham/models/baby_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/diary.dart';

class FireStoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _diaryCollectionName = 'diaries';
  final String _settingCollectionName = "setting";
  final String _babyInfoDocName = "baby_info";
  final String _analysisCollectionName = "analysis";

  String? get _currentUserId => _auth.currentUser?.uid;

  // diary collection
  CollectionReference? get _userDiariesCollection {
    if (_currentUserId == null) return null;
    return _firestore
        .collection('users')
        .doc(_currentUserId!)
        .collection(_diaryCollectionName);
  }

  // baby_info collection
  DocumentReference? get _userBabyInfoDocRef {
    if (_currentUserId == null) return null;
    return _firestore
        .collection('users')
        .doc(_currentUserId!)
        .collection(_settingCollectionName)
        .doc(_babyInfoDocName);
  }

  // analysis collection
  CollectionReference? get _userAnalysisCollection {
    if (_currentUserId == null) return null;
    return _firestore
        .collection('users')
        .doc(_currentUserId!)
        .collection(_analysisCollectionName);
  }

  Future<void> saveDiary(Diary diary) async {
    if (_userDiariesCollection == null) {
      throw DiaryException('사용자 인증이 필요합니다');
    }

    try {
      final dateId = _formatDateToString(diary.createdAt);

      await _userDiariesCollection!.doc(dateId).set(diary.toJson());
    } catch (e) {
      throw DiaryException('일기 저장에 실패했습니다: $e');
    }
  }

  Future<void> saveBabyInfo(BabyInfo babyInfo) async {
    if (_userBabyInfoDocRef == null) {
      throw BabyInfoException('사용자 인증이 필요합니다');
    }

    try {
      await _userBabyInfoDocRef!.set(babyInfo.toJson());
    } catch (e) {
      throw BabyInfoException('아기 정보 저장에 실패했습니다: $e');
    }
  }

  Future<List<Diary>> getAllDiaries() async {
    if (_userDiariesCollection == null) {
      throw DiaryException('사용자 인증이 필요합니다');
    }

    try {
      final querySnapshot = await _userDiariesCollection!
          .orderBy(FieldPath.documentId) // 문서 ID로 정렬
          .get();

      return querySnapshot.docs
          .map((doc) => Diary.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw DiaryException('일기 목록 조회에 실패했습니다: $e');
    }
  }

  Future<AiResponse?> getRecentAnalysis() async {
    if (_userAnalysisCollection == null) {
      throw AnalysisException('사용자 인증이 필요합니다');
    }

    try {
      final querySnapshot = await _userAnalysisCollection!
          .orderBy(FieldPath.documentId, descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      return AiResponse.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>
      );
    } catch (e) {
      throw AnalysisException('AI 분석 결과 조회에 실패했습니다: $e');
    }
  }

  Future<void> updateDiary(Diary diary) async {
    if (_userDiariesCollection == null) {
      throw DiaryException('사용자 인증이 필요합니다');
    }

    try {
      final dateId = _formatDateToString(diary.createdAt);
      final updatedDiary = diary.copyWith(updatedAt: DateTime.now());

      await _userDiariesCollection!.doc(dateId).update(updatedDiary.toJson());
    } catch (e) {
      throw DiaryException('일기 업데이트에 실패했습니다: $e');
    }
  }

  Future<void> deleteDiaryByDate(DateTime date) async {
    if (_userDiariesCollection == null) {
      throw DiaryException('사용자 인증이 필요합니다');
    }

    try {
      final dateId = _formatDateToString(date);
      await _userDiariesCollection!.doc(dateId).delete();
    } catch (e) {
      throw DiaryException('일기 삭제에 실패했습니다: $e');
    }
  }

  Stream<List<Diary>> getDiariesStream() {
    if (_userDiariesCollection == null) {
      throw DiaryException('사용자 인증이 필요합니다');
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
      throw DiaryException('일기 스트림 조회에 실패했습니다: $e');
    }
  }

  Stream<BabyInfo> getBabyInfoStream() {
    if (_userBabyInfoDocRef == null) {
      throw BabyInfoException('사용자 인증이 필요합니다');
    }

    try {
      return _userBabyInfoDocRef!.snapshots().map((doc) {
        if (doc.exists) {
          return BabyInfo.fromJson(doc.data() as Map<String, dynamic>);
        } else {
          return BabyInfo(birthday: '', sex: '', weight: '');
        }
      });
    } catch (e) {
      throw BabyInfoException('아기 정보 스트림 조회에 실패했습니다: $e');
    }
  }

  String _formatDateToString(DateTime date) {
    // YYYY-MM-DD
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}

class DiaryException implements Exception {
  final String message;

  DiaryException(this.message);

  @override
  String toString() => 'DiaryRepositoryException: $message';
}

class BabyInfoException implements Exception {
  final String message;

  BabyInfoException(this.message);

  @override
  String toString() => 'BabyInfoException: $message';
}

class AnalysisException implements Exception {
  final String message;

  AnalysisException(this.message);

  @override
  String toString() => 'AnalysisException: $message';
}