// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_bovine_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegisterBovineState {

 MuzzleState get muzzle; DateTime get entryDate; String? get tag; Sex? get sex; DateTime? get birthDate; String? get weightText; bool get saving;
/// Create a copy of RegisterBovineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterBovineStateCopyWith<RegisterBovineState> get copyWith => _$RegisterBovineStateCopyWithImpl<RegisterBovineState>(this as RegisterBovineState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RegisterBovineState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterBovineState&&(identical(other.muzzle, _this.muzzle) || other.muzzle == _this.muzzle)&&(identical(other.entryDate, _this.entryDate) || other.entryDate == _this.entryDate)&&(identical(other.tag, _this.tag) || other.tag == _this.tag)&&(identical(other.sex, _this.sex) || other.sex == _this.sex)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&(identical(other.weightText, _this.weightText) || other.weightText == _this.weightText)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as RegisterBovineState;
  return Object.hash(runtimeType,_this.muzzle,_this.entryDate,_this.tag,_this.sex,_this.birthDate,_this.weightText,_this.saving);
}

@override
String toString() {
  final _this = this as RegisterBovineState;
  return 'RegisterBovineState(muzzle: ${_this.muzzle}, entryDate: ${_this.entryDate}, tag: ${_this.tag}, sex: ${_this.sex}, birthDate: ${_this.birthDate}, weightText: ${_this.weightText}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $RegisterBovineStateCopyWith<$Res>  {
  factory $RegisterBovineStateCopyWith(RegisterBovineState value, $Res Function(RegisterBovineState) _then) = _$RegisterBovineStateCopyWithImpl;
@useResult
$Res call({
 MuzzleState muzzle, DateTime entryDate, String? tag, Sex? sex, DateTime? birthDate, String? weightText, bool saving
});




}
/// @nodoc
class _$RegisterBovineStateCopyWithImpl<$Res>
    implements $RegisterBovineStateCopyWith<$Res> {
  _$RegisterBovineStateCopyWithImpl(this._self, this._then);

  final RegisterBovineState _self;
  final $Res Function(RegisterBovineState) _then;

/// Create a copy of RegisterBovineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? muzzle = null,Object? entryDate = null,Object? tag = freezed,Object? sex = freezed,Object? birthDate = freezed,Object? weightText = freezed,Object? saving = null,}) {
  return _then(RegisterBovineState(
muzzle: null == muzzle ? _self.muzzle : muzzle // ignore: cast_nullable_to_non_nullable
as MuzzleState,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as DateTime,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,weightText: freezed == weightText ? _self.weightText : weightText // ignore: cast_nullable_to_non_nullable
as String?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterBovineState].
extension RegisterBovineStatePatterns on RegisterBovineState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterBovineState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterBovineState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterBovineState value)  $default,){
final _that = this;
switch (_that) {
case _RegisterBovineState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterBovineState value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterBovineState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MuzzleState muzzle,  DateTime entryDate,  String? tag,  Sex? sex,  DateTime? birthDate,  String? weightText,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterBovineState() when $default != null:
return $default(_that.muzzle,_that.entryDate,_that.tag,_that.sex,_that.birthDate,_that.weightText,_that.saving);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MuzzleState muzzle,  DateTime entryDate,  String? tag,  Sex? sex,  DateTime? birthDate,  String? weightText,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _RegisterBovineState():
return $default(_that.muzzle,_that.entryDate,_that.tag,_that.sex,_that.birthDate,_that.weightText,_that.saving);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MuzzleState muzzle,  DateTime entryDate,  String? tag,  Sex? sex,  DateTime? birthDate,  String? weightText,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _RegisterBovineState() when $default != null:
return $default(_that.muzzle,_that.entryDate,_that.tag,_that.sex,_that.birthDate,_that.weightText,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _RegisterBovineState extends RegisterBovineState {
  const _RegisterBovineState({this.muzzle = const MuzzleMissing(), required this.entryDate, this.tag, this.sex, this.birthDate, this.weightText, this.saving = false}): super._();
  

@override@JsonKey() final  MuzzleState muzzle;
@override final  DateTime entryDate;
@override final  String? tag;
@override final  Sex? sex;
@override final  DateTime? birthDate;
@override final  String? weightText;
@override@JsonKey() final  bool saving;

/// Create a copy of RegisterBovineState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterBovineStateCopyWith<_RegisterBovineState> get copyWith => __$RegisterBovineStateCopyWithImpl<_RegisterBovineState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterBovineState&&(identical(other.muzzle, muzzle) || other.muzzle == muzzle)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.weightText, weightText) || other.weightText == weightText)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,muzzle,entryDate,tag,sex,birthDate,weightText,saving);
}

@override
String toString() {
    return 'RegisterBovineState(muzzle: $muzzle, entryDate: $entryDate, tag: $tag, sex: $sex, birthDate: $birthDate, weightText: $weightText, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$RegisterBovineStateCopyWith<$Res> implements $RegisterBovineStateCopyWith<$Res> {
  factory _$RegisterBovineStateCopyWith(_RegisterBovineState value, $Res Function(_RegisterBovineState) _then) = __$RegisterBovineStateCopyWithImpl;
@override @useResult
$Res call({
 MuzzleState muzzle, DateTime entryDate, String? tag, Sex? sex, DateTime? birthDate, String? weightText, bool saving
});




}
/// @nodoc
class __$RegisterBovineStateCopyWithImpl<$Res>
    implements _$RegisterBovineStateCopyWith<$Res> {
  __$RegisterBovineStateCopyWithImpl(this._self, this._then);

  final _RegisterBovineState _self;
  final $Res Function(_RegisterBovineState) _then;

/// Create a copy of RegisterBovineState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? muzzle = null,Object? entryDate = null,Object? tag = freezed,Object? sex = freezed,Object? birthDate = freezed,Object? weightText = freezed,Object? saving = null,}) {
  return _then(_RegisterBovineState(
muzzle: null == muzzle ? _self.muzzle : muzzle // ignore: cast_nullable_to_non_nullable
as MuzzleState,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as DateTime,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as Sex?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,weightText: freezed == weightText ? _self.weightText : weightText // ignore: cast_nullable_to_non_nullable
as String?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
