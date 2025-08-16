import 'dart:async';

import 'package:babysitter_ham/provider/login_provider.dart';
import 'package:babysitter_ham/repository/login_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginViewModel extends AsyncNotifier<void> {
  late final LoginRepository _authRepository;

  @override
  FutureOr<void> build() {
    _authRepository = ref.watch(authRepositoryProvider);
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_authRepository.signInWithGoogle);
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_authRepository.signOut);
  }
}

final loginViewModelProvider = AsyncNotifierProvider<LoginViewModel, void>(
  LoginViewModel.new,
);
