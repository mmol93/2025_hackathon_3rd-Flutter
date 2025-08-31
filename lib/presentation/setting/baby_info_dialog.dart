import 'package:babysitter_ham/models/baby_info.dart';
import 'package:babysitter_ham/presentation/common_widget/common_snackbar.dart';
import 'package:babysitter_ham/viewmodel/setting_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showEditBabyInfoDialog({
  required BuildContext context,
  required WidgetRef ref,
  required BabyInfo currentBabyInfo,
}) async {
  final TextEditingController weightController = TextEditingController(
    text: currentBabyInfo.weight,
  );
  DateTime? selectedDate;
  String selectedSex = currentBabyInfo.sex.isEmpty
      ? '男の子'
      : currentBabyInfo.sex;

  // 기존 생일 파싱
  if (currentBabyInfo.birthday.isNotEmpty) {
    try {
      final parts = currentBabyInfo.birthday.split('-');
      if (parts.length == 3) {
        selectedDate = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      }
    } catch (e) {
      selectedDate = DateTime.now();
    }
  } else {
    selectedDate = DateTime.now();
  }

  await showDialog(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (statefulContext, setState) => AlertDialog(
        title: const Text(
          '赤ちゃん情報編集',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 생일 선택
              Text(
                '誕生日',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: dialogContext,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    locale: const Locale('ja', 'JP'),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cake, color: Colors.pink[400]),
                      const SizedBox(width: 8),
                      Text(
                        selectedDate != null
                            ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
                            : '日付を選択',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Icon(Icons.calendar_today, color: Colors.grey[400]),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 성별 선택
              Text(
                '性別',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedSex,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
                    items: ['男の子', '女の子'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            Icon(
                              value == '男の子' ? Icons.boy : Icons.girl,
                              color: Colors.blue[400],
                            ),
                            const SizedBox(width: 8),
                            Text(value),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedSex = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 체중 입력
              Text(
                '体重',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  hintText: '例: 3.5kg',
                  prefixIcon: Icon(
                    Icons.monitor_weight,
                    color: Colors.green[400],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue[600]!),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),

              // 주의사항 추가
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange[600],
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '注意事項',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '体重は週に一回以上測定してください。\n測定が困難な場合は空欄に設定してください。',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('キャンセル', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              final newBabyInfo = BabyInfo(
                birthday: selectedDate != null
                    ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
                    : '',
                sex: selectedSex,
                weight: weightController.text.trim(),
              );

              try {
                await ref
                    .read(babyInfoStreamProvider.notifier)
                    .saveBabyInfo(newBabyInfo);

                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
                if (!context.mounted) return;
                showSuccessSnackBar(context, '赤ちゃん情報を更新しました');
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('更新に失敗しました: $e')));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
            child: const Text('保存'),
          ),
        ],
      ),
    ),
  );
}
