import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_app/repositories/repositories.dart';
import 'package:flutter_notes_app/models/models.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository, AuthState? initialState})
      : _authRepository = authRepository,
        super(initialState ?? Unauthenticated());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is Login) {
      yield* _mapLoginToState();
    } else if (event is Logout) {
      yield* _mapLogoutToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      User? currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        currentUser = await _authRepository.loginAnonymously();
      }
      final isAnonymous = await _authRepository.isAnonymous();
      if (isAnonymous) {
        yield Anonymous(currentUser);
      } else {
        yield Authenticated(currentUser);
      }
    } catch (e) {
      print(e);
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLoginToState() async* {
    try {
      User? currentUser = await _authRepository.getCurrentUser();
      yield Authenticated(currentUser);
    } catch (e) {
      print(e);
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLogoutToState() async* {
    try {
      await _authRepository.logout();
      yield* _mapAppStartedToState();
    } catch (e) {
      print(e);
      yield Unauthenticated();
    }
  }
}
