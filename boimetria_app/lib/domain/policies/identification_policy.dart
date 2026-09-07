import 'package:boimetria/domain/value_objects/distance.dart';

abstract class IdentificationPolicy {
  // PROVISORIO: 0.2 saiu do sweep de runs/aug_margin1.0, que nao e' o modelo
  // que esta em assets/models. Rodando eval_onnx.py no modelo que o app carrega
  // (split_1/test, 5180 pares): ROC-AUC 95.97, mesmo animal 0.3221, animais
  // diferentes 1.1178 — com 0.2 o recall cai para 42%.
  //
  // Nesse modelo o ponto razoavel seria 0.35: precisao 99.2%, 0.54% de falsos
  // aceites, recall 66%. O melhor F1 (0.60) aceita 7.7% de falsos, o que em 1:N
  // multiplica por cada animal cadastrado — errar de boi e' pior que pedir
  // outra foto.
  //
  // Nao ajustado ainda porque o modelo vai ser retreinado. Refazer o sweep no
  // modelo final e conferir tambem no split_2 antes de fixar.
  //
  // Vale lembrar: retrieval top-1 = 96.33%. A identificacao deve ranquear todos
  // os cadastrados e usar este limiar so' para recusar quando ate' o mais
  // proximo estiver longe demais.
  static const maximumDistance = Distance(0.2);
}
