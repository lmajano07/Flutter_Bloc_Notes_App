import 'package:flutter_notes_app/repositories/repositories.dart';
import 'package:flutter_notes_app/models/models.dart';

abstract class BaseAuthRepository extends BaseRepository {
  Future<User> loginAnonymously();
  Future<User> signupWithEmailAndPassword(
      {required String email, required String password});
  Future<User> loginWithEmailAndPassword(
      {required String email, required String password});
  Future<User> logout();
  Future<User?> getCurrentUser();
  Future<bool> isAnonymous();
}
