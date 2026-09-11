import 'package:boimetria/config/assets.dart';
import 'package:boimetria/data/services/onnx_muzzle_detector_service.dart';
import 'package:boimetria/data/database/app_database.dart';
import 'package:boimetria/data/repositories/local_bovine_repository.dart';
import 'package:boimetria/data/services/onnx_muzzle_embedder_service.dart';
import 'package:boimetria/domain/interfaces/services/muzzle_detector.dart';
import 'package:boimetria/domain/interfaces/repositories/bovine_repository.dart';
import 'package:boimetria/domain/interfaces/services/muzzle_embedder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final muzzleDetectorProvider = FutureProvider<MuzzleDetectorService>((
  ref,
) async {
  final service = await OnnxMuzzleDetectorService.load(Assets.yolo);
  ref.onDispose(service.close);
  return service;
});

final muzzleEmbedderProvider = FutureProvider<MuzzleEmbedderService>((
  ref,
) async {
  final service = await OnnxMuzzleEmbedderService.load(
    Assets.cattleMuzzleNet,
    Assets.cattleMuzzleNetVersion,
  );
  ref.onDispose(service.close);
  return service;
});

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final bovineRepositoryProvider = Provider<BovineRepository>((ref) {
  return LocalBovineRepository(ref.watch(databaseProvider));
});
