class Diary {
  final String id;
  final DateTime dateTime;
  final FeedingInfo? feedingInfo;
  final String description;
  final PoopInfo? poopInfo;
  final int? sleepCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Diary({
    required this.id,
    required this.dateTime,
    this.feedingInfo,
    required this.description,
    this.poopInfo,
    this.sleepCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
      id: json['id'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime'] as int),
      feedingInfo: json['feedingInfo'] != null
          ? FeedingInfo.fromJson(json['feedingInfo'] as Map<String, dynamic>)
          : null,
      description: json['diaryContent'] as String? ?? '',
      poopInfo:
          json['poopInfo'] !=
              null // 추가된 부분
          ? PoopInfo.fromJson(json['poopInfo'] as Map<String, dynamic>)
          : null,
      sleepCount: json['sleepCount'] as int?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'feedingInfo': feedingInfo?.toJson(),
      'diaryContent': description,
      'poopInfo': poopInfo?.toJson(), // 추가된 부분
      'sleepCount': sleepCount,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  Diary copyWith({
    String? id,
    DateTime? dateTime,
    FeedingInfo? feedingInfo,
    String? diaryContent,
    PoopInfo? poopInfo,
    int? sleepCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Diary(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      feedingInfo: feedingInfo ?? this.feedingInfo,
      description: diaryContent ?? this.description,
      poopInfo: poopInfo ?? this.poopInfo,
      // 추가된 부분
      sleepCount: sleepCount ?? this.sleepCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Diary &&
        other.id == id &&
        other.dateTime == dateTime &&
        other.feedingInfo == feedingInfo &&
        other.description == description &&
        other.poopInfo == poopInfo && // 추가된 부분
        other.sleepCount == sleepCount &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      dateTime,
      feedingInfo,
      description,
      poopInfo,
      sleepCount,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'Diary(id: $id, dateTime: $dateTime, feedingInfo: $feedingInfo, '
        'description: $description, poopInfo: $poopInfo, sleepCount: $sleepCount, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

enum FeedingType {
  breastMilk('母乳'),
  formula('粉ミルク'),
  babyFood('離乳食');

  const FeedingType(this.displayName);

  final String displayName;

  static FeedingType fromString(String value) {
    return FeedingType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => FeedingType.breastMilk,
    );
  }
}

class FeedingInfo {
  final int times;
  final FeedingType type;

  const FeedingInfo({required this.times, required this.type});

  factory FeedingInfo.fromJson(Map<String, dynamic> json) {
    return FeedingInfo(
      times: json['times'] as int? ?? 0,
      type: FeedingType.fromString(json['type'] as String? ?? 'breastMilk'),
    );
  }

  Map<String, dynamic> toJson() {
    return {'times': times, 'type': type.name};
  }

  FeedingInfo copyWith({int? times, FeedingType? type}) {
    return FeedingInfo(times: times ?? this.times, type: type ?? this.type);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FeedingInfo && other.times == times && other.type == type;
  }

  @override
  int get hashCode => Object.hash(times, type);

  @override
  String toString() => 'FeedingInfo(times: $times, type: ${type.displayName})';
}

class PoopInfo {
  final String color;
  final String type;

  const PoopInfo({required this.color, required this.type});

  factory PoopInfo.fromJson(Map<String, dynamic> json) {
    return PoopInfo(
      color: json['color'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'color': color, 'type': type};
  }

  PoopInfo copyWith({String? color, String? type}) {
    return PoopInfo(color: color ?? this.color, type: type ?? this.type);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PoopInfo && other.color == color && other.type == type;
  }

  @override
  int get hashCode => Object.hash(color, type);

  @override
  String toString() => 'PoopInfo(color: $color, type: $type)';
}
