sealed class MuzzleDetectionFailure implements Exception {
  const MuzzleDetectionFailure(this.diagnostic);

  final String diagnostic;

  @override
  String toString() => '$runtimeType: $diagnostic';
}

final class ImageDecodeFailure extends MuzzleDetectionFailure {
  const ImageDecodeFailure() : super('image bytes could not be decoded');
}

final class ModelLoadFailure extends MuzzleDetectionFailure {
  ModelLoadFailure(this.asset, this.cause)
    : super('could not load $asset: $cause');

  final String asset;
  final Exception cause;
}
