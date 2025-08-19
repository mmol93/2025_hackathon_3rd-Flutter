import 'package:babysitter_ham/models/diary.dart';
import 'package:babysitter_ham/viewmodel/diary_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewDiaryWidget extends ConsumerStatefulWidget {
  final Diary? existingDiary; // 수정할 일기 데이터

  const NewDiaryWidget({super.key, this.existingDiary});

  @override
  ConsumerState<NewDiaryWidget> createState() => _DiaryWriteScreenState();
}

class _DiaryWriteScreenState extends ConsumerState<NewDiaryWidget> {
  final TextEditingController _feedingTimesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _sleepCountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedPoopColor = '';
  String _selectedPoopType = '';
  FeedingType? _selectedFeedingType;

  final List<String> _poopColors = ['茶色', '黄色', '緑色', '黒色', '赤色'];
  final List<String> _poopTypes = ['軟便', '下痢', '便秘', '正常'];

  bool get _isEditMode => widget.existingDiary != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _loadExistingDiary();
    }
  }

  void _loadExistingDiary() {
    final diary = widget.existingDiary!;

    _selectedDate = diary.dateTime;
    _descriptionController.text = diary.description;

    if (diary.feedingInfo != null) {
      _feedingTimesController.text = diary.feedingInfo!.times.toString();
      _selectedFeedingType = diary.feedingInfo!.type;
    }

    if (diary.poopInfo != null) {
      _selectedPoopColor = diary.poopInfo!.color;
      _selectedPoopType = diary.poopInfo!.type;
    }

    if (diary.sleepCount != null) {
      _sleepCountController.text = diary.sleepCount.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    // false를 전달하여 초기 데이터 로딩 안함
    final diariesStream = ref.watch(diaryStreamProvider);

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text(
          _isEditMode ? '育児日記編集' : '育児日記作成',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.blue.withOpacity(0.1),
        iconTheme: IconThemeData(color: Colors.blue[600]),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: diariesStream.isLoading
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.blue[600]!,
                ),
              ),
            )
                : TextButton(
              onPressed: _saveDiary,
              child: Text(
                _isEditMode ? '更新' : '保存',
                style: TextStyle(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date
              _buildDateSection(),
              SizedBox(height: 20),

              // Description (필수)
              _buildDescriptionSection(),
              SizedBox(height: 20),

              // Feed info
              _buildFeedingSection(),
              SizedBox(height: 20),

              // Poop info
              _buildPoopSection(),
              SizedBox(height: 20),

              // Sleep count
              _buildSleepSection(),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.blue[600], size: 24),
              SizedBox(width: 12),
              Text(
                '日付',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!, width: 1),
            ),
            child: InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日 ${_selectedDate.hour}:${_selectedDate.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[800],
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.blue[600]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit, color: Colors.green[400], size: 24),
              SizedBox(width: 12),
              Text(
                '今日の記録',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildInputField(
            controller: _descriptionController,
            label: '日記内容',
            hint: '今日あったことを記録してみてください',
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedingSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.baby_changing_station,
                color: Colors.pink[400],
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                '授乳情報',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  controller: _feedingTimesController,
                  label: '回数',
                  hint: '例: 5',
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildFeedingTypeDropdown(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedingTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '種類',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.lightBlue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[200]!, width: 1),
          ),
          child: DropdownButtonFormField<FeedingType>(
            value: _selectedFeedingType,
            hint: Text(
              '選択',
              style: TextStyle(color: Colors.grey[500]),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            items: FeedingType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.displayName),
              );
            }).toList(),
            onChanged: (FeedingType? value) {
              setState(() {
                _selectedFeedingType = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPoopSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.fiber_manual_record,
                color: Colors.brown[400],
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                '排便情報',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            '色',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: _poopColors.map((color) {
              return ChoiceChip(
                label: Text(color),
                selected: _selectedPoopColor == color,
                onSelected: (selected) {
                  setState(() {
                    _selectedPoopColor = selected ? color : '';
                  });
                },
                selectedColor: Colors.blue[100],
                backgroundColor: Colors.grey[100],
                labelStyle: TextStyle(
                  color: _selectedPoopColor == color
                      ? Colors.blue[800]
                      : Colors.grey[600],
                  fontWeight: _selectedPoopColor == color
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Text(
            '形状',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: _poopTypes.map((type) {
              return ChoiceChip(
                label: Text(type),
                selected: _selectedPoopType == type,
                onSelected: (selected) {
                  setState(() {
                    _selectedPoopType = selected ? type : '';
                  });
                },
                selectedColor: Colors.blue[100],
                backgroundColor: Colors.grey[100],
                labelStyle: TextStyle(
                  color: _selectedPoopType == type
                      ? Colors.blue[800]
                      : Colors.grey[600],
                  fontWeight: _selectedPoopType == type
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bedtime, color: Colors.purple[400], size: 24),
              SizedBox(width: 12),
              Text(
                '睡眠情報',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildInputField(
            controller: _sleepCountController,
            label: '今日の睡眠回数',
            hint: '例: 4',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.lightBlue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[200]!, width: 1),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[600]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.grey[800]!,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue[600]!,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.grey[800]!,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _saveDiary() async {
    // 필수 필드 검증
    if (_descriptionController.text
        .trim()
        .isEmpty) {
      _showErrorMessage('日記内容を入力してください');
      return;
    }

    try {
      // false를 전달하여 초기 데이터 로딩하지 않는 viewmodel 사용
      final viewmodel = ref.read(diaryStreamProvider.notifier);

      // UI 데이터를 Diary 모델로 변환
      final diary = _createDiaryFromInputs();

      // 저장 또는 업데이트
      await viewmodel.saveDiary(diary);

      // 저장 완료 후 상태 확인
      final state = ref.read(diaryStreamProvider);

      state.when(
        data: (_) {
          _showSuccessMessage();
          Navigator.pop(context);
        },
        error: (error, _) {
          _showErrorMessage('保存に失敗しました: $error');
        },
        loading: () {
          // 로딩 중에는 아무것도 안함 (UI에서 이미 표시됨)
        },
      );
    } catch (e) {
      _showErrorMessage('保存に失敗しました: $e');
    }
  }

  Diary _createDiaryFromInputs() {
    final now = DateTime.now();

    return Diary(
      dateTime: _selectedDate,
      feedingInfo: (_feedingTimesController.text.isNotEmpty &&
          _selectedFeedingType != null)
          ? FeedingInfo(
        times: int.tryParse(_feedingTimesController.text) ?? 0,
        type: _selectedFeedingType!,
      )
          : null,
      description: _descriptionController.text.trim(),
      poopInfo: (_selectedPoopColor.isNotEmpty && _selectedPoopType.isNotEmpty)
          ? PoopInfo(color: _selectedPoopColor, type: _selectedPoopType)
          : null,
      sleepCount: _sleepCountController.text.isNotEmpty
          ? int.tryParse(_sleepCountController.text)
          : null,
      createdAt: _isEditMode | _selectedDate
          .toString()
          .isNotEmpty ? _selectedDate : now,
      updatedAt: now,
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text(_isEditMode
                ? '日記が更新されました！'
                : '日記が保存されました！'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _feedingTimesController.dispose();
    _descriptionController.dispose();
    _sleepCountController.dispose();
    super.dispose();
  }
}
