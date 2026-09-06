// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_animal_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RegisterAnimalState {
  MuzzleState get muzzle => throw _privateConstructorUsedError;
  DateTime get entryDate => throw _privateConstructorUsedError;
  String? get tag => throw _privateConstructorUsedError;
  Sex? get sex => throw _privateConstructorUsedError;
  DateTime? get birthDate => throw _privateConstructorUsedError;
  String? get weightText => throw _privateConstructorUsedError;
  bool get saving => throw _privateConstructorUsedError;

  /// Create a copy of RegisterAnimalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterAnimalStateCopyWith<RegisterAnimalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterAnimalStateCopyWith<$Res> {
  factory $RegisterAnimalStateCopyWith(
    RegisterAnimalState value,
    $Res Function(RegisterAnimalState) then,
  ) = _$RegisterAnimalStateCopyWithImpl<$Res, RegisterAnimalState>;
  @useResult
  $Res call({
    MuzzleState muzzle,
    DateTime entryDate,
    String? tag,
    Sex? sex,
    DateTime? birthDate,
    String? weightText,
    bool saving,
  });
}

/// @nodoc
class _$RegisterAnimalStateCopyWithImpl<$Res, $Val extends RegisterAnimalState>
    implements $RegisterAnimalStateCopyWith<$Res> {
  _$RegisterAnimalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterAnimalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? muzzle = null,
    Object? entryDate = null,
    Object? tag = freezed,
    Object? sex = freezed,
    Object? birthDate = freezed,
    Object? weightText = freezed,
    Object? saving = null,
  }) {
    return _then(
      _value.copyWith(
            muzzle: null == muzzle
                ? _value.muzzle
                : muzzle // ignore: cast_nullable_to_non_nullable
                      as MuzzleState,
            entryDate: null == entryDate
                ? _value.entryDate
                : entryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            tag: freezed == tag
                ? _value.tag
                : tag // ignore: cast_nullable_to_non_nullable
                      as String?,
            sex: freezed == sex
                ? _value.sex
                : sex // ignore: cast_nullable_to_non_nullable
                      as Sex?,
            birthDate: freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            weightText: freezed == weightText
                ? _value.weightText
                : weightText // ignore: cast_nullable_to_non_nullable
                      as String?,
            saving: null == saving
                ? _value.saving
                : saving // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RegisterAnimalStateImplCopyWith<$Res>
    implements $RegisterAnimalStateCopyWith<$Res> {
  factory _$$RegisterAnimalStateImplCopyWith(
    _$RegisterAnimalStateImpl value,
    $Res Function(_$RegisterAnimalStateImpl) then,
  ) = __$$RegisterAnimalStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    MuzzleState muzzle,
    DateTime entryDate,
    String? tag,
    Sex? sex,
    DateTime? birthDate,
    String? weightText,
    bool saving,
  });
}

/// @nodoc
class __$$RegisterAnimalStateImplCopyWithImpl<$Res>
    extends _$RegisterAnimalStateCopyWithImpl<$Res, _$RegisterAnimalStateImpl>
    implements _$$RegisterAnimalStateImplCopyWith<$Res> {
  __$$RegisterAnimalStateImplCopyWithImpl(
    _$RegisterAnimalStateImpl _value,
    $Res Function(_$RegisterAnimalStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegisterAnimalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? muzzle = null,
    Object? entryDate = null,
    Object? tag = freezed,
    Object? sex = freezed,
    Object? birthDate = freezed,
    Object? weightText = freezed,
    Object? saving = null,
  }) {
    return _then(
      _$RegisterAnimalStateImpl(
        muzzle: null == muzzle
            ? _value.muzzle
            : muzzle // ignore: cast_nullable_to_non_nullable
                  as MuzzleState,
        entryDate: null == entryDate
            ? _value.entryDate
            : entryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        tag: freezed == tag
            ? _value.tag
            : tag // ignore: cast_nullable_to_non_nullable
                  as String?,
        sex: freezed == sex
            ? _value.sex
            : sex // ignore: cast_nullable_to_non_nullable
                  as Sex?,
        birthDate: freezed == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        weightText: freezed == weightText
            ? _value.weightText
            : weightText // ignore: cast_nullable_to_non_nullable
                  as String?,
        saving: null == saving
            ? _value.saving
            : saving // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$RegisterAnimalStateImpl extends _RegisterAnimalState {
  const _$RegisterAnimalStateImpl({
    this.muzzle = const MuzzleMissing(),
    required this.entryDate,
    this.tag,
    this.sex,
    this.birthDate,
    this.weightText,
    this.saving = false,
  }) : super._();

  @override
  @JsonKey()
  final MuzzleState muzzle;
  @override
  final DateTime entryDate;
  @override
  final String? tag;
  @override
  final Sex? sex;
  @override
  final DateTime? birthDate;
  @override
  final String? weightText;
  @override
  @JsonKey()
  final bool saving;

  @override
  String toString() {
    return 'RegisterAnimalState(muzzle: $muzzle, entryDate: $entryDate, tag: $tag, sex: $sex, birthDate: $birthDate, weightText: $weightText, saving: $saving)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterAnimalStateImpl &&
            (identical(other.muzzle, muzzle) || other.muzzle == muzzle) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.sex, sex) || other.sex == sex) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.weightText, weightText) ||
                other.weightText == weightText) &&
            (identical(other.saving, saving) || other.saving == saving));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    muzzle,
    entryDate,
    tag,
    sex,
    birthDate,
    weightText,
    saving,
  );

  /// Create a copy of RegisterAnimalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterAnimalStateImplCopyWith<_$RegisterAnimalStateImpl> get copyWith =>
      __$$RegisterAnimalStateImplCopyWithImpl<_$RegisterAnimalStateImpl>(
        this,
        _$identity,
      );
}

abstract class _RegisterAnimalState extends RegisterAnimalState {
  const factory _RegisterAnimalState({
    final MuzzleState muzzle,
    required final DateTime entryDate,
    final String? tag,
    final Sex? sex,
    final DateTime? birthDate,
    final String? weightText,
    final bool saving,
  }) = _$RegisterAnimalStateImpl;
  const _RegisterAnimalState._() : super._();

  @override
  MuzzleState get muzzle;
  @override
  DateTime get entryDate;
  @override
  String? get tag;
  @override
  Sex? get sex;
  @override
  DateTime? get birthDate;
  @override
  String? get weightText;
  @override
  bool get saving;

  /// Create a copy of RegisterAnimalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterAnimalStateImplCopyWith<_$RegisterAnimalStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
