import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void changeTab(int index) {
    state = index;
  }
}

final tabNotifierProvider = NotifierProvider<TabNotifier, int>(TabNotifier.new);
