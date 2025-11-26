// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'python.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PyArgument {
  Object get field0;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PyArgument &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  @override
  String toString() {
    return 'PyArgument(field0: $field0)';
  }
}

/// @nodoc
class $PyArgumentCopyWith<$Res> {
  $PyArgumentCopyWith(PyArgument _, $Res Function(PyArgument) __);
}

/// Adds pattern-matching-related methods to [PyArgument].
extension PyArgumentPatterns on PyArgument {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PyArgument_Str value)? str,
    TResult Function(PyArgument_Int value)? int,
    TResult Function(PyArgument_Float value)? float,
    TResult Function(PyArgument_Bool value)? bool,
    TResult Function(PyArgument_ListStr value)? listStr,
    TResult Function(PyArgument_ListInt value)? listInt,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case PyArgument_Str() when str != null:
        return str(_that);
      case PyArgument_Int() when int != null:
        return int(_that);
      case PyArgument_Float() when float != null:
        return float(_that);
      case PyArgument_Bool() when bool != null:
        return bool(_that);
      case PyArgument_ListStr() when listStr != null:
        return listStr(_that);
      case PyArgument_ListInt() when listInt != null:
        return listInt(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PyArgument_Str value) str,
    required TResult Function(PyArgument_Int value) int,
    required TResult Function(PyArgument_Float value) float,
    required TResult Function(PyArgument_Bool value) bool,
    required TResult Function(PyArgument_ListStr value) listStr,
    required TResult Function(PyArgument_ListInt value) listInt,
  }) {
    final _that = this;
    switch (_that) {
      case PyArgument_Str():
        return str(_that);
      case PyArgument_Int():
        return int(_that);
      case PyArgument_Float():
        return float(_that);
      case PyArgument_Bool():
        return bool(_that);
      case PyArgument_ListStr():
        return listStr(_that);
      case PyArgument_ListInt():
        return listInt(_that);
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PyArgument_Str value)? str,
    TResult? Function(PyArgument_Int value)? int,
    TResult? Function(PyArgument_Float value)? float,
    TResult? Function(PyArgument_Bool value)? bool,
    TResult? Function(PyArgument_ListStr value)? listStr,
    TResult? Function(PyArgument_ListInt value)? listInt,
  }) {
    final _that = this;
    switch (_that) {
      case PyArgument_Str() when str != null:
        return str(_that);
      case PyArgument_Int() when int != null:
        return int(_that);
      case PyArgument_Float() when float != null:
        return float(_that);
      case PyArgument_Bool() when bool != null:
        return bool(_that);
      case PyArgument_ListStr() when listStr != null:
        return listStr(_that);
      case PyArgument_ListInt() when listInt != null:
        return listInt(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? str,
    TResult Function(PlatformInt64 field0)? int,
    TResult Function(double field0)? float,
    TResult Function(bool field0)? bool,
    TResult Function(List<String> field0)? listStr,
    TResult Function(Int64List field0)? listInt,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case PyArgument_Str() when str != null:
        return str(_that.field0);
      case PyArgument_Int() when int != null:
        return int(_that.field0);
      case PyArgument_Float() when float != null:
        return float(_that.field0);
      case PyArgument_Bool() when bool != null:
        return bool(_that.field0);
      case PyArgument_ListStr() when listStr != null:
        return listStr(_that.field0);
      case PyArgument_ListInt() when listInt != null:
        return listInt(_that.field0);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) str,
    required TResult Function(PlatformInt64 field0) int,
    required TResult Function(double field0) float,
    required TResult Function(bool field0) bool,
    required TResult Function(List<String> field0) listStr,
    required TResult Function(Int64List field0) listInt,
  }) {
    final _that = this;
    switch (_that) {
      case PyArgument_Str():
        return str(_that.field0);
      case PyArgument_Int():
        return int(_that.field0);
      case PyArgument_Float():
        return float(_that.field0);
      case PyArgument_Bool():
        return bool(_that.field0);
      case PyArgument_ListStr():
        return listStr(_that.field0);
      case PyArgument_ListInt():
        return listInt(_that.field0);
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String field0)? str,
    TResult? Function(PlatformInt64 field0)? int,
    TResult? Function(double field0)? float,
    TResult? Function(bool field0)? bool,
    TResult? Function(List<String> field0)? listStr,
    TResult? Function(Int64List field0)? listInt,
  }) {
    final _that = this;
    switch (_that) {
      case PyArgument_Str() when str != null:
        return str(_that.field0);
      case PyArgument_Int() when int != null:
        return int(_that.field0);
      case PyArgument_Float() when float != null:
        return float(_that.field0);
      case PyArgument_Bool() when bool != null:
        return bool(_that.field0);
      case PyArgument_ListStr() when listStr != null:
        return listStr(_that.field0);
      case PyArgument_ListInt() when listInt != null:
        return listInt(_that.field0);
      case _:
        return null;
    }
  }
}

/// @nodoc

class PyArgument_Str extends PyArgument {
  const PyArgument_Str(this.field0) : super._();

  @override
  final String field0;

  /// Create a copy of PyArgument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PyArgument_StrCopyWith<PyArgument_Str> get copyWith =>
      _$PyArgument_StrCopyWithImpl<PyArgument_Str>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PyArgument_Str &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @override
  String toString() {
    return 'PyArgument.str(field0: $field0)';
  }
}

/// @nodoc
abstract mixin class $PyArgument_StrCopyWith<$Res>
    implements $PyArgumentCopyWith<$Res> {
  factory $PyArgument_StrCopyWith(
          PyArgument_Str value, $Res Function(PyArgument_Str) _then) =
      _$PyArgument_StrCopyWithImpl;
  @useResult
  $Res call({String field0});
}

/// @nodoc
class _$PyArgument_StrCopyWithImpl<$Res>
    implements $PyArgument_StrCopyWith<$Res> {
  _$PyArgument_StrCopyWithImpl(this._self, this._then);

  final PyArgument_Str _self;
  final $Res Function(PyArgument_Str) _then;

  /// Create a copy of PyArgument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? field0 = null,
  }) {
    return _then(PyArgument_Str(
      null == field0
          ? _self.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class PyArgument_Int extends PyArgument {
  const PyArgument_Int(this.field0) : super._();

  @override
  final PlatformInt64 field0;

  /// Create a copy of PyArgument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PyArgument_IntCopyWith<PyArgument_Int> get copyWith =>
      _$PyArgument_IntCopyWithImpl<PyArgument_Int>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PyArgument_Int &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @override
  String toString() {
    return 'PyArgument.int(field0: $field0)';
  }
}

/// @nodoc
abstract mixin class $PyArgument_IntCopyWith<$Res>
    implements $PyArgumentCopyWith<$Res> {
  factory $PyArgument_IntCopyWith(
          PyArgument_Int value, $Res Function(PyArgument_Int) _then) =
      _$PyArgument_IntCopyWithImpl;
  @useResult
  $Res call({PlatformInt64 field0});
}

/// @nodoc
class _$PyArgument_IntCopyWithImpl<$Res>
    implements $PyArgument_IntCopyWith<$Res> {
  _$PyArgument_IntCopyWithImpl(this._self, this._then);

  final PyArgument_Int _self;
  final $Res Function(PyArgument_Int) _then;

  /// Create a copy of PyArgument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? field0 = null,
  }) {
    return _then(PyArgument_Int(
      null == field0
          ? _self.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as PlatformInt64,
    ));
  }
}

/// @nodoc

class PyArgument_Float extends PyArgument {
  const PyArgument_Float(this.field0) : super._();

  @override
  final double field0;

  /// Create a copy of PyArgument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PyArgument_FloatCopyWith<PyArgument_Float> get copyWith =>
      _$PyArgument_FloatCopyWithImpl<PyArgument_Float>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PyArgument_Float &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @override
  String toString() {
    return 'PyArgument.float(field0: $field0)';
  }
}

/// @nodoc
abstract mixin class $PyArgument_FloatCopyWith<$Res>
    implements $PyArgumentCopyWith<$Res> {
  factory $PyArgument_FloatCopyWith(
          PyArgument_Float value, $Res Function(PyArgument_Float) _then) =
      _$PyArgument_FloatCopyWithImpl;
  @useResult
  $Res call({double field0});
}

/// @nodoc
class _$PyArgument_FloatCopyWithImpl<$Res>
    implements $PyArgument_FloatCopyWith<$Res> {
  _$PyArgument_FloatCopyWithImpl(this._self, this._then);

  final PyArgument_Float _self;
  final $Res Function(PyArgument_Float) _then;

  /// Create a copy of PyArgument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? field0 = null,
  }) {
    return _then(PyArgument_Float(
      null == field0
          ? _self.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class PyArgument_Bool extends PyArgument {
  const PyArgument_Bool(this.field0) : super._();

  @override
  final bool field0;

  /// Create a copy of PyArgument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PyArgument_BoolCopyWith<PyArgument_Bool> get copyWith =>
      _$PyArgument_BoolCopyWithImpl<PyArgument_Bool>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PyArgument_Bool &&
            (identical(other.field0, field0) || other.field0 == field0));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field0);

  @override
  String toString() {
    return 'PyArgument.bool(field0: $field0)';
  }
}

/// @nodoc
abstract mixin class $PyArgument_BoolCopyWith<$Res>
    implements $PyArgumentCopyWith<$Res> {
  factory $PyArgument_BoolCopyWith(
          PyArgument_Bool value, $Res Function(PyArgument_Bool) _then) =
      _$PyArgument_BoolCopyWithImpl;
  @useResult
  $Res call({bool field0});
}

/// @nodoc
class _$PyArgument_BoolCopyWithImpl<$Res>
    implements $PyArgument_BoolCopyWith<$Res> {
  _$PyArgument_BoolCopyWithImpl(this._self, this._then);

  final PyArgument_Bool _self;
  final $Res Function(PyArgument_Bool) _then;

  /// Create a copy of PyArgument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? field0 = null,
  }) {
    return _then(PyArgument_Bool(
      null == field0
          ? _self.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class PyArgument_ListStr extends PyArgument {
  const PyArgument_ListStr(final List<String> field0)
      : _field0 = field0,
        super._();

  final List<String> _field0;
  @override
  List<String> get field0 {
    if (_field0 is EqualUnmodifiableListView) return _field0;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_field0);
  }

  /// Create a copy of PyArgument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PyArgument_ListStrCopyWith<PyArgument_ListStr> get copyWith =>
      _$PyArgument_ListStrCopyWithImpl<PyArgument_ListStr>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PyArgument_ListStr &&
            const DeepCollectionEquality().equals(other._field0, _field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_field0));

  @override
  String toString() {
    return 'PyArgument.listStr(field0: $field0)';
  }
}

/// @nodoc
abstract mixin class $PyArgument_ListStrCopyWith<$Res>
    implements $PyArgumentCopyWith<$Res> {
  factory $PyArgument_ListStrCopyWith(
          PyArgument_ListStr value, $Res Function(PyArgument_ListStr) _then) =
      _$PyArgument_ListStrCopyWithImpl;
  @useResult
  $Res call({List<String> field0});
}

/// @nodoc
class _$PyArgument_ListStrCopyWithImpl<$Res>
    implements $PyArgument_ListStrCopyWith<$Res> {
  _$PyArgument_ListStrCopyWithImpl(this._self, this._then);

  final PyArgument_ListStr _self;
  final $Res Function(PyArgument_ListStr) _then;

  /// Create a copy of PyArgument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? field0 = null,
  }) {
    return _then(PyArgument_ListStr(
      null == field0
          ? _self._field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class PyArgument_ListInt extends PyArgument {
  const PyArgument_ListInt(this.field0) : super._();

  @override
  final Int64List field0;

  /// Create a copy of PyArgument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PyArgument_ListIntCopyWith<PyArgument_ListInt> get copyWith =>
      _$PyArgument_ListIntCopyWithImpl<PyArgument_ListInt>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PyArgument_ListInt &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  @override
  String toString() {
    return 'PyArgument.listInt(field0: $field0)';
  }
}

/// @nodoc
abstract mixin class $PyArgument_ListIntCopyWith<$Res>
    implements $PyArgumentCopyWith<$Res> {
  factory $PyArgument_ListIntCopyWith(
          PyArgument_ListInt value, $Res Function(PyArgument_ListInt) _then) =
      _$PyArgument_ListIntCopyWithImpl;
  @useResult
  $Res call({Int64List field0});
}

/// @nodoc
class _$PyArgument_ListIntCopyWithImpl<$Res>
    implements $PyArgument_ListIntCopyWith<$Res> {
  _$PyArgument_ListIntCopyWithImpl(this._self, this._then);

  final PyArgument_ListInt _self;
  final $Res Function(PyArgument_ListInt) _then;

  /// Create a copy of PyArgument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? field0 = null,
  }) {
    return _then(PyArgument_ListInt(
      null == field0
          ? _self.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as Int64List,
    ));
  }
}

// dart format on
