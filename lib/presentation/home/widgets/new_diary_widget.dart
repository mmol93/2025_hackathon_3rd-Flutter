import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewDiaryWidget extends ConsumerStatefulWidget {
  const NewDiaryWidget({super.key});

  @override
  ConsumerState<NewDiaryWidget> createState() => _DiaryWriteScreenState();
}

class _DiaryWriteScreenState extends ConsumerState<NewDiaryWidget> {
  final TextEditingController _feedingTimesController = TextEditingController();
  final TextEditingController _feedingAmountController =
      TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _sleepTimeController = TextEditingController();
  final TextEditingController _sleepPatternController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedPoopColor = '';
  String _selectedPoopType = '';

  final List<String> _poopColors = ['茶色', '黄色', '緑色', '黒色', '赤色'];
  final List<String> _poopTypes = ['軟便', '下痢', '便秘', '正常'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text(
          '育児日記作成',
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
            child: TextButton(
              onPressed: _saveDiary,
              child: Text(
                '保存',
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

              // Feed info
              ...[_buildFeedingSection(), SizedBox(height: 20)],

              // Poop info
              _buildPoopSection(),
              SizedBox(height: 20),

              // Sleeping info
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
                  hint: '例: 5回',
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildInputField(
                  controller: _feedingAmountController,
                  label: '授乳量',
                  hint: '例: 120ml',
                ),
              ),
            ],
          ),
        ],
      ),
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
            controller: _sleepTimeController,
            label: '睡眠時間',
            hint: '例: 22:00 - 06:00',
          ),
          SizedBox(height: 16),
          _buildInputField(
            controller: _sleepPatternController,
            label: '睡眠パターン',
            hint: '睡眠パターンを記録してみてください',
            maxLines: 2,
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

  void _saveDiary() {
    // 일기 저장 로직
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('日記が保存されました！'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _feedingTimesController.dispose();
    _feedingAmountController.dispose();
    _foodController.dispose();
    _sleepTimeController.dispose();
    _sleepPatternController.dispose();
    super.dispose();
  }
}
