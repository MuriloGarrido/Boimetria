import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:boimetria/domain/entities/identify_input.dart';
import '../ui/home/widgets/home_screen.dart';
import '../ui/identify/identify_result_screen.dart';
import '../ui/register/widgets/register_animal_screen.dart';

/// Tabela central de rotas do app. Cada [GoRoute] mapeia um caminho para
/// a tela correspondente; argumentos complexos chegam via `state.extra`.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/identify',
        builder: (context, state) {
          final input = state.extra as IdentifyInput;
          return IdentifyResultScreen(input: input);
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterAnimalScreen(),
      ),
    ],
  );
});
