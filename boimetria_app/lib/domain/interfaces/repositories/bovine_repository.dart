import 'package:boimetria/domain/entities/bovine.dart';
import 'package:boimetria/domain/value_objects/bovine_draft.dart';

abstract interface class BovineRepository {
  Future<Bovine> enroll(BovineDraft draft);

  Future<List<Bovine>> all();

  Future<Bovine?> byId(int id);

  Future<Bovine?> byTag(String tag);
}
