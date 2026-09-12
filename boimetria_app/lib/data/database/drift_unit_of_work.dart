import 'package:boimetria/data/database/app_database.dart';
import 'package:boimetria/domain/interfaces/unit_of_work.dart';

class DriftUnitOfWork implements UnitOfWork {
  DriftUnitOfWork(this._database);

  final AppDatabase _database;

  @override
  Future<T> run<T>(Future<T> Function() action) =>
      _database.transaction(action);
}
