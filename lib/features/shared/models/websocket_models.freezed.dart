// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PatientUpdateData _$PatientUpdateDataFromJson(Map<String, dynamic> json) {
  return _PatientUpdateData.fromJson(json);
}

/// @nodoc
mixin _$PatientUpdateData {
  int get id => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PatientUpdateDataCopyWith<PatientUpdateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PatientUpdateDataCopyWith<$Res> {
  factory $PatientUpdateDataCopyWith(
    PatientUpdateData value,
    $Res Function(PatientUpdateData) then,
  ) = _$PatientUpdateDataCopyWithImpl<$Res, PatientUpdateData>;
  @useResult
  $Res call({int id, String status, int priority});
}

/// @nodoc
class _$PatientUpdateDataCopyWithImpl<$Res, $Val extends PatientUpdateData>
    implements $PatientUpdateDataCopyWith<$Res> {
  _$PatientUpdateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? priority = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PatientUpdateDataImplCopyWith<$Res>
    implements $PatientUpdateDataCopyWith<$Res> {
  factory _$$PatientUpdateDataImplCopyWith(
    _$PatientUpdateDataImpl value,
    $Res Function(_$PatientUpdateDataImpl) then,
  ) = __$$PatientUpdateDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String status, int priority});
}

/// @nodoc
class __$$PatientUpdateDataImplCopyWithImpl<$Res>
    extends _$PatientUpdateDataCopyWithImpl<$Res, _$PatientUpdateDataImpl>
    implements _$$PatientUpdateDataImplCopyWith<$Res> {
  __$$PatientUpdateDataImplCopyWithImpl(
    _$PatientUpdateDataImpl _value,
    $Res Function(_$PatientUpdateDataImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? priority = null,
  }) {
    return _then(
      _$PatientUpdateDataImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PatientUpdateDataImpl implements _PatientUpdateData {
  _$PatientUpdateDataImpl({
    required this.id,
    required this.status,
    required this.priority,
  });

  factory _$PatientUpdateDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PatientUpdateDataImplFromJson(json);

  @override
  final int id;
  @override
  final String status;
  @override
  final int priority;

  @override
  String toString() {
    return 'PatientUpdateData(id: $id, status: $status, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatientUpdateDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, status, priority);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PatientUpdateDataImplCopyWith<_$PatientUpdateDataImpl> get copyWith =>
      __$$PatientUpdateDataImplCopyWithImpl<_$PatientUpdateDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PatientUpdateDataImplToJson(this);
  }
}

abstract class _PatientUpdateData implements PatientUpdateData {
  factory _PatientUpdateData({
    required final int id,
    required final String status,
    required final int priority,
  }) = _$PatientUpdateDataImpl;

  factory _PatientUpdateData.fromJson(Map<String, dynamic> json) =
      _$PatientUpdateDataImpl.fromJson;

  @override
  int get id;
  @override
  String get status;
  @override
  int get priority;
  @override
  @JsonKey(ignore: true)
  _$$PatientUpdateDataImplCopyWith<_$PatientUpdateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
