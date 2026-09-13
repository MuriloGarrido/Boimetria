# Protocolo de avaliação do CattleMuzzleNet

Documento de referência para implementar a avaliação depois do treino.
O treino **não depende** de nada daqui: a loss, o sampler e o loop continuam
iguais. Só o ponto em que o melhor epoch é escolhido usa uma métrica de
validação (rank-1, seção 7).

---

## 1. Objetivo

Medir o quanto os embeddings do modelo servem para o que o app faz:

- **1:N (identificação):** o app recebe uma foto, busca a vaca mais próxima no
  banco (sqlite-vec) e decide se é essa vaca ou se o animal **não está
  cadastrado**.
- **1:1 (verificação):** duas fotos são da mesma vaca ou não?

Regra principal do projeto: **uma vaca errada nunca pode ser mostrada como a
certa.** Um falso aceite é pior que uma rejeição.

---

## 2. Cenário do app que a avaliação precisa reproduzir

- Vacas **não cadastradas podem ser fotografadas** (animal novo, de vizinho etc.).
  Por isso a identificação é **open-set**: a resposta é "vaca X" **ou** "não
  cadastrada".
- O cadastro tem **1 foto por vaca**.
- A busca sempre devolve a vaca mais próxima, mesmo quando o animal não está no
  banco. Quem impede a vaca errada é o **limiar**.
- Quando a vaca **está** cadastrada, ela "esconde" as vacas parecidas (a
  distância para ela é menor). Quando **não está**, a vaca parecida vira a mais
  próxima. Por isso a avaliação precisa testar os dois casos (seção 4).

---

## 3. Dados

- Divisão **por vaca**, nunca por imagem.
- **CFID** (pré-treino): 1 fold, train/val. Usado só para escolher o ponto de
  partida do fine-tuning. Não entra nos números finais.
- **CMPD300** (domínio): 5 folds, cada um com **200 train / 40 val / 60 test** vacas.
  - train, val e test não compartilham vacas dentro do fold;
  - cada vaca aparece no test de **exatamente um** fold;
  - o val também **não repete vacas entre folds**.
- **Val escolhe, test mede.** Limiar e melhor epoch saem só da val. O test é
  avaliado **uma única vez**, com tudo já fixado.

---

## 4. Protocolo 1:N (identificação open-set)

Terminologia da ISO/IEC 19795-1 e da NIST FRTE 1:N:

| Termo | Significado aqui |
|---|---|
| **Busca mated** | a vaca da foto **está** cadastrada na galeria |
| **Busca non-mated** | a vaca da foto **não está** cadastrada |
| **Galeria** | 1 foto cadastrada por vaca |
| **Consulta (probe)** | as demais fotos, buscadas contra a galeria |

### 4.1 Duas galerias com troca de papéis (estilo IJB-C)

Para cada conjunto avaliado (val ou test de um fold):

```
vacas do conjunto → metade G1, metade G2 (sorteio com semente fixa)

Rodada 1: galeria = G1 (1 foto de cada vaca de G1)
    consultas das vacas de G1 → mated
    consultas das vacas de G2 → non-mated

Rodada 2: galeria = G2
    consultas das vacas de G2 → mated
    consultas das vacas de G1 → non-mated

Resultado = combinação das duas rodadas
```

- Toda vaca é cadastrada em uma rodada e não cadastrada na outra.
- O tamanho da galeria é fixo em cada rodada, como um banco real.
- Test do CMPD300: 60 vacas → galerias de 30. Val: 40 vacas → galerias de 20.
- Em aberto: guardar G1/G2 no split file (`test_g1`, `test_g2`, `val_g1`,
  `val_g2`) ou sortear com semente na avaliação. Preferência: **no split file**,
  para ficar fixo e visível.

### 4.2 Decisão para cada consulta

```
distância para todas as fotos da galeria → vaca mais próxima + distância d

d < limiar  → "é a vaca X"
d ≥ limiar  → "não cadastrada"
```

| Tipo de consulta | Resultado | Classificação |
|---|---|---|
| mated | vaca certa e d < limiar | acerto (TP) |
| mated | vaca errada e d < limiar | **vaca errada mostrada** (FP) e não identificada (FN) |
| mated | d ≥ limiar | rejeitada (FN), no app vira "tire outra foto" |
| non-mated | d ≥ limiar | rejeição correta (TN) |
| non-mated | d < limiar | **vaca errada mostrada** (FP) |

---

## 5. Protocolo 1:1 (verificação)

- **Pares genuínos:** duas fotos da mesma vaca.
- **Pares impostores:** fotos de vacas diferentes (amostrados, com semente fixa).
- Decisão: `distância < limiar` → mesma vaca.

---

## 6. Limiar

- Escolhido **na val**, aplicado **sem alteração** no test.
- Critério: **taxa fixa de falso aceite = 1%**, porque aceitar a vaca errada é
  o erro mais grave.
  - **1:N:** limiar em que **FPIR = 1%** nas buscas non-mated da val.
    **Este é o limiar do app.**
  - **1:1:** limiar em que **FMR = 1%** nos pares impostores da val.
- O limiar de 1:1 **não serve** para 1:N: numa busca contra muitas vacas, a
  chance de alguma vaca errada ficar abaixo do limiar é bem maior que num único
  par. O limiar do 1:N tende a ser mais rigoroso.
- O limiar depende do **tamanho da galeria**. Relatar o tamanho usado (20 na
  val, 30 no test).
- EER também é relatado, mas só como métrica de comparação entre modelos, não
  para escolher o limiar do app.

---

## 7. Métricas

### 7.1 Identificação 1:N (open-set)

| Métrica | Definição |
|---|---|
| **FPIR** | buscas non-mated aceitas ÷ buscas non-mated (deve ficar perto de 1%) |
| **FNIR** | buscas mated não identificadas corretamente ÷ buscas mated |
| **Precision** | acertos ÷ consultas aceitas (TP ÷ (TP + FP)) |
| **Recall** | acertos ÷ buscas mated (TP ÷ mated) = 1 − FNIR |
| **F1** | média harmônica de precision e recall |
| **Rank-1** | só buscas mated, sem limiar: a vaca mais próxima é a certa? |
| **Rank-5** | a vaca certa está entre as 5 mais próximas (sem limiar) |
| **mAP** | só buscas mated, sem limiar. Com 1 foto por vaca na galeria, o AP de cada consulta é 1 ÷ posição da vaca certa |

Principal número do 1:N: **FNIR com FPIR = 1%**.

### 7.2 Verificação 1:1

| Métrica | Definição |
|---|---|
| **FMR** | pares impostores aceitos ÷ pares impostores |
| **FNMR** | pares genuínos rejeitados ÷ pares genuínos |
| **EER** | ponto em que FMR = FNMR (não depende do limiar escolhido) |
| **ROC-AUC** | área sob a curva ROC (não depende do limiar) |
| **Precision / Recall / F1** | no limiar escolhido; recall = 1 − FNMR |

### 7.3 Escolha do melhor epoch

- A cada epoch, avaliar na val e guardar o checkpoint com maior **rank-1**
  (buscas mated). O rank-1 não depende do limiar.
- O limiar é calculado **depois**, na val, com o melhor checkpoint.

---

## 8. Como relatar

- **Por fold:** todas as métricas das seções 7.1 e 7.2 no test, com o limiar da
  val daquele fold.
- **Resultado final:** média ± desvio padrão dos 5 folds.
- **Curvas:** DET ou ROC (1:1) e FNIR × FPIR (1:N), por fold ou agregadas.
- **Registrar junto:** limiar escolhido, FPIR alvo (1%), tamanho da galeria,
  número de consultas mated e non-mated, número de pares genuínos e impostores.
- **Comparações** (Siamesa × ArcFace, com × sem pré-treino) usam exatamente o
  mesmo protocolo e os mesmos splits.

---

## 9. Referências

- **ISO/IEC 19795-1**: biometric performance testing and reporting. Base para
  FMR, FNMR, FPIR, FNIR e EER. *Conferir a edição vigente antes de citar.*
- **NIST FRTE 1:N** (antigo FRVT): avaliação com buscas mated e non-mated,
  relatando FNIR com FPIR fixo. *Conferir o relatório atual no site da NIST.*
- **IJB-C**: protocolo open-set com duas galerias que deixam de fora os
  indivíduos uma da outra.

A avaliação segue a **terminologia e o protocolo** dessas referências, sem
alegar conformidade formal (que exige procedimentos e escala de testes
operacionais).

---

## 10. Limitações a declarar

- Poucas vacas por fold (galerias de 20 e 30 vacas). Números com FPIR de 1%
  têm incerteza alta; o desvio entre folds ajuda a mostrar isso.
- Um rebanho real pode ter muito mais vacas que a galeria do test. O limiar
  pode precisar de ajuste para galerias maiores.
- Fotos dos datasets podem ter qualidade melhor que as do campo.

---

## 11. Implicações para o app (fora do modelo)

O modelo define **quantos** erros acontecem; o app define **o estrago** que
eles causam.

- **Nunca cadastrar automaticamente** quando a resposta for "não cadastrada".
  Cadastro é sempre uma ação explícita do usuário.
- **Foto ruim de vaca cadastrada** pode ser rejeitada e virar cadastro
  duplicado. Mitigações:
  - checagem de qualidade da foto antes da busca (desfoque, escuro, focinho
    pequeno);
  - **zona de incerteza** com dois limiares:
    `aceita` / `tire outra foto ou confirme entre as 3 mais próximas` / `não cadastrada`;
  - ao cadastrar uma vaca nova, buscar antes e avisar se alguma vaca cadastrada
    estiver próxima ("pode ser a vaca X").
- Em aberto: avaliar com **dois limiares** (aceite / incerteza / rejeição) ou só
  um por enquanto.
