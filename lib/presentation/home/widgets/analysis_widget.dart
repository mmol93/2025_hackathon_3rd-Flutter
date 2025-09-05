import 'package:babysitter_ham/models/analysis.dart';
import 'package:babysitter_ham/presentation/common_widget/common_header_card.dart';
import 'package:babysitter_ham/viewmodel/analysis_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalysisWidget extends ConsumerWidget {
  const AnalysisWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisAsync = ref.watch(analysisProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.lightBlue[50],
        body: analysisAsync.when(
          data: (aiResponse) {
            if (aiResponse == null) {
              return _buildEmptyState(context);
            }
            return _buildAnalysisContent(aiResponse, ref, context);
          },
          loading: () =>
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue[600]!),
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '分析結果を読み込み中...',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                        color: Colors.blue[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          error: (error, stackTrace) =>
              _buildErrorState(error.toString(), ref, context),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: CommonCardWidget.buildBasicCard(
        borderRadius: 28,
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.psychology_outlined,
                  size: 48,
                  color: Colors.blue[600],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'まだ分析結果がありません',
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '赤ちゃんの日記を作成すると\nAI分析結果が表示されます',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, WidgetRef ref, BuildContext context) {
    return Center(
      child: CommonCardWidget.buildBasicCard(
        borderRadius: 28,
        border: Border.all(color: Colors.red[100]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red[400],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'エラーが発生しました',
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.red[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                error,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => ref.read(analysisProvider.notifier).refresh(),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('再試行'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisContent(AiResponse aiResponse, WidgetRef ref,
      BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await ref.read(analysisProvider.notifier).refresh();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // AI의 아기 상태 점수 표시
            _buildConfidenceScoreCard(aiResponse.confidenceScore, context),

            // Analysis 결과를 카드 위젯 형태로 표시
            ..._buildConditionalCards(aiResponse, context),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Analysis 각 항목에 맞게 카드뷰 생성
  List<Widget> _buildConditionalCards(AiResponse aiResponse,
      BuildContext context) {
    List<Widget> cards = [];

    // AI 조언
    if (aiResponse.analysis.advice
        .trim()
        .isNotEmpty) {
      cards.add(const SizedBox(height: 24));
      cards.add(
        CommonCardWidget.buildContentCard(
          title: 'AIアドバイス',
          content: aiResponse.analysis.advice,
          icon: Icons.lightbulb_outline,
          context: context,
          gradientColors: [Colors.orange[300]!, Colors.orange[500]!],
        ),
      );
    }

    // 성장 패턴
    if (aiResponse.analysis.growthPattern
        .trim()
        .isNotEmpty) {
      cards.add(const SizedBox(height: 20));
      cards.add(
        CommonCardWidget.buildContentCard(
          title: '成長パターン',
          content: aiResponse.analysis.growthPattern,
          icon: Icons.trending_up,
          context: context,
          gradientColors: [Colors.green[300]!, Colors.green[500]!],
        ),
      );
    }

    // 우선 행동 항목 (리스트가 비어있지 않은 경우에만 표시)
    if (aiResponse.analysis.priorityActions.isNotEmpty) {
      cards.add(const SizedBox(height: 20));
      cards.add(
        _buildPriorityActionsCard(aiResponse.analysis.priorityActions, context),
      );
    }

    // 권장사항
    if (aiResponse.analysis.recommendations
        .trim()
        .isNotEmpty) {
      cards.add(const SizedBox(height: 20));
      cards.add(
        CommonCardWidget.buildContentCard(
          title: '推奨事項',
          content: aiResponse.analysis.recommendations,
          icon: Icons.recommend,
          context: context,
          gradientColors: [Colors.blue[300]!, Colors.blue[500]!],
        ),
      );
    }

    // 위험 요소
    if (aiResponse.analysis.riskFactors
        .trim()
        .isNotEmpty) {
      cards.add(const SizedBox(height: 20));
      cards.add(
        CommonCardWidget.buildContentCard(
          title: 'リスク要因',
          content: aiResponse.analysis.riskFactors,
          icon: Icons.warning_amber_outlined,
          context: context,
          gradientColors: [Colors.red[300]!, Colors.red[500]!],
        ),
      );
    }

    return cards;
  }

  Widget _buildConfidenceScoreCard(int confidenceScore, BuildContext context) {
    Color scoreColor;
    String scoreText;
    IconData scoreIcon;

    if (confidenceScore >= 80) {
      scoreColor = Colors.green;
      scoreText = '良い';
      scoreIcon = Icons.verified;
    } else if (confidenceScore >= 60) {
      scoreColor = Colors.orange;
      scoreText = '普通';
      scoreIcon = Icons.info;
    } else {
      scoreColor = Colors.red;
      scoreText = '注意';
      scoreIcon = Icons.warning;
    }

    return CommonCardWidget.buildSpecialCard(
      gradientColors: [Colors.blue[400]!, Colors.blue[600]!],
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.baby_changing_station,
                  size: 32,
                  color: Colors.blue[600],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '赤ちゃん状態スコア',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '$confidenceScore点',
                          style: Theme
                              .of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: scoreColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: scoreColor.withOpacity(0.3),
                                spreadRadius: 0,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                scoreIcon,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                scoreText,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityActionsCard(List<String> actions, BuildContext context) {
    final actionsBody = Column(
      children: actions
          .asMap()
          .entries
          .map((entry) {
        final index = entry.key;
        final action = entry.value;
        return Container(
          margin: EdgeInsets.only(bottom: index == actions.length - 1 ? 0 : 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.purple[100]!,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.purple[300]!,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 18,
                  color: Colors.purple[600],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  action,
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );

    return CommonCardWidget.buildCustomBodyCard(
      title: '優先行動項目',
      body: actionsBody,
      icon: Icons.checklist_rtl,
      context: context,
      gradientColors: [Colors.purple[300]!, Colors.purple[500]!],
      headerSuffix: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          '${actions.length}項目',
          style: Theme
              .of(context)
              .textTheme
              .labelMedium
              ?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
