import 'package:flutter/foundation.dart';

class Analysis {
  final String advice;
  final String growthPattern;
  final List<String> priorityActions;
  final String recommendations;
  final String riskFactors;

  Analysis({
    required this.advice,
    required this.growthPattern,
    required this.priorityActions,
    required this.recommendations,
    required this.riskFactors,
  });

  factory Analysis.fromJson(Map<String, dynamic> json) {
    return Analysis(
      advice: json['advice'] as String? ?? '',
      growthPattern: json['growth_pattern'] as String? ?? '',
      priorityActions:
          (json['priority_actions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      recommendations: json['recommendations'] as String? ?? '',
      riskFactors: json['risk_factors'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'advice': advice,
      'growth_pattern': growthPattern,
      'priority_actions': priorityActions,
      'recommendations': recommendations,
      'risk_factors': riskFactors,
    };
  }

  Analysis copyWith({
    String? advice,
    String? growthPattern,
    List<String>? priorityActions,
    String? recommendations,
    String? riskFactors,
  }) {
    return Analysis(
      advice: advice ?? this.advice,
      growthPattern: growthPattern ?? this.growthPattern,
      priorityActions: priorityActions ?? this.priorityActions,
      recommendations: recommendations ?? this.recommendations,
      riskFactors: riskFactors ?? this.riskFactors,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Analysis &&
        other.advice == advice &&
        other.growthPattern == growthPattern &&
        listEquals(other.priorityActions, priorityActions) &&
        other.recommendations == recommendations &&
        other.riskFactors == riskFactors;
  }

  @override
  int get hashCode {
    return Object.hash(
      advice,
      growthPattern,
      priorityActions,
      recommendations,
      riskFactors,
    );
  }

  @override
  String toString() {
    return 'Analysis(advice: $advice, growthPattern: $growthPattern, priorityActions: $priorityActions, recommendations: $recommendations, riskFactors: $riskFactors)';
  }
}

class AiResponse {
  final Analysis analysis;
  final int confidenceScore;

  AiResponse({required this.analysis, required this.confidenceScore});

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      analysis: Analysis.fromJson(
        json['analysis'] as Map<String, dynamic>? ?? {},
      ),
      confidenceScore: json['confidence_score'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'analysis': analysis.toJson(), 'confidence_score': confidenceScore};
  }

  AiResponse copyWith({Analysis? analysis, int? confidenceScore}) {
    return AiResponse(
      analysis: analysis ?? this.analysis,
      confidenceScore: confidenceScore ?? this.confidenceScore,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AiResponse &&
        other.analysis == analysis &&
        other.confidenceScore == confidenceScore;
  }

  @override
  int get hashCode {
    return Object.hash(analysis, confidenceScore);
  }

  @override
  String toString() {
    return 'AiResponse(analysis: $analysis, confidenceScore: $confidenceScore)';
  }
}
