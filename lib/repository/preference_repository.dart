import 'dart:convert';

import 'package:babysitter_ham/models/diary.dart';
import 'package:babysitter_ham/utils/time_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PreferenceRepository {
  final TimeUtil timeUtils;

  PreferenceRepository(this.timeUtils);

  Future<void> saveDiaryList(List<Diary> diaryList);

  Future<List<Diary>?> getDiaryList();

  Future<void> clearAllDiaryInfo();
}

class PreferenceRepositoryImpl implements PreferenceRepository {
  static const String _diaryKey = 'cached_diary_list';

  Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<void> saveDiaryList(List<Diary> diaryList) async {
    final prefs = await _prefs;

    try {
      final jsonList = diaryList.map((item) => item.toJson()).toList();
      final jsonString = jsonEncode(jsonList);

      await prefs.setString(_diaryKey, jsonString);
    } catch (e) {
      throw Exception('세일 정보 저장 실패: $e');
    }
  }

  @override
  Future<List<Diary>?> getDiaryList() async {
    final prefs = await _prefs;

    try {
      final jsonString = prefs.getString(_diaryKey);
      if (jsonString == null) return null;

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => Diary.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearAllDiaryInfo() async {
    final prefs = await _prefs;
    await Future.wait([prefs.remove(_diaryKey)]);
  }

  @override
  TimeUtil get timeUtils => TimeUtil();
}
