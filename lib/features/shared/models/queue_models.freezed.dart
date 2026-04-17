// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QueuePatient _$QueuePatientFromJson(Map<String, dynamic> json) {
  return _QueuePatient.fromJson(json);
}

/// @nodoc
mixin _$QueuePatient {
  int get id => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  int get urgencyScore => throw _privateConstructorUsedError;
  String get condition => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QueuePatientCopyWith<QueuePatient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueuePatientCopyWith<$Res> {
  factory $QueuePatientCopyWith(
    QueuePatient value,
    $Res Function(QueuePatient) then,
  ) = _$QueuePatientCopyWithImpl<$Res, QueuePatient>;
  @useResult
  $Res call({
    int id,
    String description,
    int priority,
    int urgencyScore,
    String condition,
    String status,
    DateTime createdAt,
  });
}

/// @nodoc
class _$QueuePatientCopyWithImpl<$Res, $Val extends QueuePatient>
    implements $QueuePatientCopyWith<$Res> {
  _$QueuePatientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? priority = null,
    Object? urgencyScore = null,
    Object? condition = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as int,
            urgencyScore: null == urgencyScore
                ? _value.urgencyScore
                : urgencyScore // ignore: cast_nullable_to_non_nullable
                      as int,
            condition: null == condition
                ? _value.condition
                : condition // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QueuePatientImplCopyWith<$Res>
    implements $QueuePatientCopyWith<$Res> {
  factory _$$QueuePatientImplCopyWith(
    _$QueuePatientImpl value,
    $Res Function(_$QueuePatientImpl) then,
  ) = __$$QueuePatientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String description,
    int priority,
    int urgencyScore,
    String condition,
    String status,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$QueuePatientImplCopyWithImpl<$Res>
    extends _$QueuePatientCopyWithImpl<$Res, _$QueuePatientImpl>
    implements _$$QueuePatientImplCopyWith<$Res> {
  __$$QueuePatientImplCopyWithImpl(
    _$QueuePatientImpl _value,
    $Res Function(_$QueuePatientImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? priority = null,
    Object? urgencyScore = null,
    Object? condition = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$QueuePatientImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as int,
        urgencyScore: null == urgencyScore
            ? _value.urgencyScore
            : urgencyScore // ignore: cast_nullable_to_non_nullable
                  as int,
        condition: null == condition
            ? _value.condition
            : condition // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QueuePatientImpl implements _QueuePatient {
  _$QueuePatientImpl({
    required this.id,
    required this.description,
    required this.priority,
    required this.urgencyScore,
    required this.condition,
    required this.status,
    required this.createdAt,
  });

  factory _$QueuePatientImpl.fromJson(Map<String, dynamic> json) =>
      _$$QueuePatientImplFromJson(json);

  @override
  final int id;
  @override
  final String description;
  @override
  final int priority;
  @override
  final int urgencyScore;
  @override
  final String condition;
  @override
  final String status;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'QueuePatient(id: $id, description: $description, priority: $priority, urgencyScore: $urgencyScore, condition: $condition, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueuePatientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.urgencyScore, urgencyScore) ||
                other.urgencyScore == urgencyScore) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    description,
    priority,
    urgencyScore,
    condition,
    status,
    createdAt,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QueuePatientImplCopyWith<_$QueuePatientImpl> get copyWith =>
      __$$QueuePatientImplCopyWithImpl<_$QueuePatientImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QueuePatientImplToJson(this);
  }
}

abstract class _QueuePatient implements QueuePatient {
  factory _QueuePatient({
    required final int id,
    required final String description,
    required final int priority,
    required final int urgencyScore,
    required final String condition,
    required final String status,
    required final DateTime createdAt,
  }) = _$QueuePatientImpl;

  factory _QueuePatient.fromJson(Map<String, dynamic> json) =
      _$QueuePatientImpl.fromJson;

  @override
  int get id;
  @override
  String get description;
  @override
  int get priority;
  @override
  int get urgencyScore;
  @override
  String get condition;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$QueuePatientImplCopyWith<_$QueuePatientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
