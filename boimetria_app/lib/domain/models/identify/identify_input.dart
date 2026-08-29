import 'dart:typed_data';

/// De onde vem a imagem que entra no fluxo de identificação.
///
/// - [raw]: imagem inteira (galeria/câmera nativa) que ainda precisa passar
///   pelo YOLO para achar e recortar a mufla.
/// - [cropped]: mufla já recortada (câmera com detecção em tempo real), que
///   pula a etapa de detecção.
enum ImageKind { raw, cropped }

class IdentifyInput {
  const IdentifyInput({required this.bytes, required this.kind});

  final Uint8List bytes;
  final ImageKind kind;
}
