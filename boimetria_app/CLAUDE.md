# Boimetria

Flutter app for cattle identification by muzzle biometrics. MVVM with Riverpod.

## Layers

    domain/     entities, value_objects, policies, interfaces, shared
    data/       implementations of domain interfaces
    ui/         screens, widgets, view models
    config/     dependency wiring, assets, locale
    routing/    go_router table

- Contracts live in `domain/interfaces/services/` and
  `domain/interfaces/repositories/`. Implementations live in `data/`.
- `ui/` must never import `data/`. Enforce with: `grep -rn "data/" lib/ui/`
- Infrastructure providers live in `config/dependencies.dart`, declared with the
  domain interface as their type. It is the only file that imports `data/`.
- Asset paths live in `config/assets.dart` and are injected, never hardcoded in
  a service.

## Business rules

- Tunable numbers live in `domain/policies/`, one class per decision they
  govern. Never inside a service.
- Services report what they observed. View models apply policy and produce UI
  state. Widgets render the state they are handed.
- A widget may display a rule; it must never evaluate one.
- Apply a rule once and encode the answer in a type, so nothing downstream can
  re-derive it differently.

## Errors

- Expected failures the caller must handle go in `Result`. A method returning
  `Result` must not throw `Exception`.
- `Error` means a bug: let it propagate. Never `catch (e)` without a type.
- The data layer never writes user-facing copy. It throws typed exceptions; the
  view model turns them into text.

## Style

- No comments in code.
- Prefer sealed classes so illegal states are unrepresentable.
- Helpers are abstract classes with statics, like `AppColors`.

## Commands

    flutter analyze
    flutter test

Decisions and their rationale: `docs/adr/`.
