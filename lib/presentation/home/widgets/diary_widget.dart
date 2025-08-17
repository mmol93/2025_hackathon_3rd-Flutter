import 'package:babysitter_ham/navigator/open_navigator.dart';
import 'package:babysitter_ham/presentation/home/widgets/new_diary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiaryWidget extends ConsumerWidget {
  const DiaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
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
              'Diary',
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
    );
  }
}
