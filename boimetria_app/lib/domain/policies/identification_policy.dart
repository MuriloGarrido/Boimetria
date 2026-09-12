import 'package:boimetria/domain/value_objects/distance.dart';

abstract class IdentificationPolicy {
  // PROVISORIO. Era 0.2, herdado do sweep de runs/aug_margin1.0, que nao e' o
  // modelo que esta em assets/models. Rodando eval_onnx.py no modelo que o app
  // carrega (split_1/test, 5180 pares): ROC-AUC 95.97, mesmo animal 0.3221,
  // animais diferentes 1.1178. Com 0.2 o recall cai para 42% — a media do
  // mesmo animal (0.3221) fica acima do limiar, entao a maioria dos acertos
  // era recusada. Duas fotos do mesmo boi nao casavam por isso, nao por falha
  // do cattlemuzzlenet: o retrieval top-1 e' 96.33%, o modelo ranqueia certo e
  // o limiar e' que vetava.
  //
  // 0.35 e' o ponto razoavel nesse modelo: precisao 99.2%, 0.54% de falsos
  // aceites, recall 66%. O melhor F1 (0.60) aceita 7.7% de falsos, o que em
  // 1:N multiplica por cada animal cadastrado — errar de boi e' pior que pedir
  // outra foto.
  //
  // Refazer o sweep no modelo final depois do retreino e conferir no split_2
  // antes de fixar.
  //
  // A identificacao deve ranquear todos os cadastrados e usar este limiar so'
  // para recusar quando ate' o mais proximo estiver longe demais.
  static const maximumDistance = Distance(0.35);

  static const candidates = 1;
}
