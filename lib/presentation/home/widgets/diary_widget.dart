import 'package:babysitter_ham/models/diary.dart';
import 'package:babysitter_ham/navigator/open_navigator.dart';
import 'package:babysitter_ham/presentation/home/widgets/new_diary_widget.dart';
import 'package:babysitter_ham/viewmodel/diary_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiaryWidget extends ConsumerStatefulWidget {
  const DiaryWidget({super.key});

  @override
  ConsumerState<DiaryWidget> createState() => _DiaryWidgetState();
}

class _DiaryWidgetState extends ConsumerState<DiaryWidget> {
  int _expandedIndex = -1; // 확장된 아이템의 인덱스

  @override
  Widget build(BuildContext context) {
    final diariesStream = ref.watch(diaryStreamProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.lightBlue[50],
        body: diariesStream.when(
          data: (diaries) {
            if (diaries.isEmpty) {
              return _buildEmptyState();
            }
            return _buildDiaryList(diaries);
          },
          loading: () =>
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                ),
              ),
          error: (error, stackTrace) => _buildErrorState(error.toString()),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            slideNavigateStateful(context, NewDiaryWidget());
          },
          icon: const Icon(Icons.add),
          label: const Text('日記作成'),
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.baby_changing_station,
            size: 64,
            color: Colors.blue[600],
          ),
          const SizedBox(height: 16),
          Text(
            'まだ日記がありません',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[600],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '赤ちゃんの大切な瞬間を記録してみてください',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'エラーが発生しました',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.refresh(diaryStreamProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
            child: const Text('再試行'),
          ),
        ],
      ),
    );
  }

  Widget _buildDiaryList(List<Diary> diaries) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.refresh(diaryStreamProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: diaries.length,
        itemBuilder: (context, index) {
          final diary = diaries[index];
          final isExpanded = _expandedIndex == index;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // 기본 리스트 아이템
                InkWell(
                  onTap: () {
                    setState(() {
                      _expandedIndex = isExpanded ? -1 : index;
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // 날짜 표시
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _formatDate(diary.dateTime),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // 일기 내용 미리보기
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                diary.description.isEmpty
                                    ? '内容がありません'
                                    : diary.description,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: diary.description.isEmpty
                                      ? Colors.grey[500]
                                      : Colors.grey[800],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDateTime(diary.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 확장 아이콘
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.blue[600],
                        ),
                      ],
                    ),
                  ),
                ),
                // 확장된 내용
                if (isExpanded) _buildExpandedContent(diary, index),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpandedContent(Diary diary, int index) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 16),

          // 일기 내용
          _buildDetailSection(
            '今日の記録',
            diary.description.isEmpty ? '記録がありません' : diary.description,
            Icons.edit,
            Colors.green[400]!,
          ),

          const SizedBox(height: 16),

          // 수유 정보
          if (diary.feedingInfo != null)
            _buildDetailSection(
              '授乳情報',
              '回数: ${diary.feedingInfo!.times}回\n'
                  '種類: ${diary.feedingInfo!.type.displayName}',
              Icons.baby_changing_station,
              Colors.pink[400]!,
            ),

          if (diary.feedingInfo != null) const SizedBox(height: 16),

          // 배변 정보
          if (diary.poopInfo != null)
            _buildDetailSection(
              '排便情報',
              '色: ${diary.poopInfo!.color}\n'
                  '形状: ${diary.poopInfo!.type}',
              Icons.fiber_manual_record,
              Colors.brown[400]!,
            ),

          if (diary.poopInfo != null) const SizedBox(height: 16),

          // 수면 정보
          if (diary.sleepCount != null)
            _buildDetailSection(
              '睡眠情報',
              '睡眠回数: ${diary.sleepCount}回',
              Icons.bedtime,
              Colors.purple[400]!,
            ),

          if (diary.sleepCount != null) const SizedBox(height: 16),

          // 수정 버튼
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                slideNavigateStateful(
                  context,
                  NewDiaryWidget(existingDiary: diary),
                );
              },
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('編集'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title,
      String content,
      IconData icon,
      Color iconColor,) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 '
        '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
