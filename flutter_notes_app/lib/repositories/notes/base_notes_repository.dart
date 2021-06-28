import 'package:flutter_notes_app/repositories/repositories.dart';
import 'package:flutter_notes_app/models/models.dart';

abstract class BaseNotesRepository extends BaseRepository {
  Future<Note> addNote({required Note note});
  Future<Note> updateNote({required Note note});
  Future<Note> deleteNote({required Note note});
  Stream<List<Note>> streamNotes({required String userId});
}
