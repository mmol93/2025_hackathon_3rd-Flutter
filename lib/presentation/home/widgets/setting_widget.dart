import 'package:babysitter_ham/models/baby_info.dart';
import 'package:babysitter_ham/presentation/setting/baby_info_dialog.dart';
import 'package:babysitter_ham/viewmodel/setting_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingWidget extends ConsumerStatefulWidget {
  const SettingWidget({super.key});

  @override
  ConsumerState<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends ConsumerState<SettingWidget> {
  @override
  Widget build(BuildContext context) {
    final babyInfoStream = ref.watch(babyInfoStreamProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.lightBlue[50],
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // BabyInfo 섹션
              babyInfoStream.when(
                data: (babyInfo) => _buildBabyInfoCard(babyInfo),
                loading: () => _buildLoadingCard(),
                error: (error, stackTrace) => _buildErrorCard(error.toString()),
              ),

              const SizedBox(height: 20),

              // 로그아웃 버튼
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBabyInfoCard(BabyInfo babyInfo) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '赤ちゃん情報',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => showEditBabyInfoDialog(
                    context: context,
                    ref: ref,
                    currentBabyInfo: babyInfo,
                  ),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('編集'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 생일 정보
            _buildInfoRow(
              Icons.cake,
              '誕生日',
              babyInfo.birthday.isEmpty ? '未設定' : babyInfo.birthday,
              Colors.pink[400]!,
            ),

            const SizedBox(height: 12),

            // 성별 정보
            _buildInfoRow(
              Icons.child_care,
              '性別',
              babyInfo.sex.isEmpty ? '未設定' : babyInfo.sex,
              Colors.blue[400]!,
            ),

            const SizedBox(height: 12),

            // 체중 정보
            _buildInfoRow(
              Icons.monitor_weight,
              '体重',
              babyInfo.weight.isEmpty ? '未設定' : babyInfo.weight,
              Colors.green[400]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Container(
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
      child: const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 12),
            Text(
              'データの読み込みに失敗しました',
              style: TextStyle(fontSize: 16, color: Colors.red[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.logout, color: Colors.red[600], size: 24),
        ),
        title: Text(
          'ログアウト',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16,
        ),
        onTap: () {
          // 로그아웃 기능은 아직 구현하지 않음
        },
      ),
    );
  }
}
