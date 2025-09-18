import 'dart:async';

import 'package:babysitter_ham/provider/login_provider.dart';
import 'package:babysitter_ham/repository/login_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginViewModel extends AsyncNotifier<void> {
  late final LoginRepository _loginRepository;

  @override
  FutureOr<void> build() {
    _loginRepository = ref.watch(authRepositoryProvider);
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_loginRepository.signInWithGoogle);
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_loginRepository.signOut);
  }
}

final loginViewModelProvider = AsyncNotifierProvider.autoDispose<
    LoginViewModel,
    void>(
  LoginViewModel.new,
);
