import 'package:boimetria/domain/entities/bovine.dart';
import 'package:boimetria/domain/shared/result.dart';
import 'package:boimetria/domain/value_objects/bovine_draft.dart';

abstract interface class BovineRepository {
  Future<Result<Bovine>> enroll(BovineDraft draft);

  Future<Result<List<Bovine>>> all();

  Future<Result<Bovine?>> byId(int id);

  Future<Result<Bovine?>> byTag(String tag);
}
