import 'package:babysitter_ham/presentation/home/tap_notifier.dart';
import 'package:babysitter_ham/presentation/home/widgets/diary_widget.dart';
import 'package:babysitter_ham/presentation/home/widgets/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const bottomNavItem = [
  BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
  BottomNavigationBarItem(icon: Icon(Icons.sunny), label: "diary"),
  BottomNavigationBarItem(icon: Icon(Icons.settings), label: "settings"),
];

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(tabNotifierProvider);

    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.blue,
          showUnselectedLabels: true,
          items: bottomNavItem,
          onTap: (index) {
            ref.read(tabNotifierProvider.notifier).changeTab(index);
          },
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [HomeWidget(), DiaryWidget()],
      ),
    );
  }
}
