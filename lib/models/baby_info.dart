class BabyInfo {
  final String birthday;
  final String sex;
  final String weight;

  BabyInfo({required this.birthday, required this.sex, required this.weight});

  factory BabyInfo.fromJson(Map<String, dynamic> json) {
    return BabyInfo(
      birthday: json['birthday'] as String? ?? '',
      sex: json['sex'] as String? ?? '',
      weight: json['weight'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'birthday': birthday, 'sex': sex, 'weight': weight};
  }

  BabyInfo copyWith({String? birthday, String? sex, String? weight}) {
    return BabyInfo(
      birthday: birthday ?? this.birthday,
      sex: sex ?? this.sex,
      weight: weight ?? this.weight,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BabyInfo &&
        other.birthday == birthday &&
        other.sex == sex &&
        other.weight == weight;
  }

  @override
  int get hashCode {
    return Object.hash(birthday, sex, weight);
  }

  @override
  String toString() {
    return 'BabyInfo(birthday: $birthday, sex: $sex, weight: $weight)';
  }
}
