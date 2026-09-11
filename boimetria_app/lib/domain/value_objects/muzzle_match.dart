import 'package:boimetria/domain/entities/muzzle_template.dart';
import 'package:boimetria/domain/value_objects/distance.dart';

class MuzzleMatch {
  const MuzzleMatch({required this.template, required this.distance});

  final MuzzleTemplate template;
  final Distance distance;
}
