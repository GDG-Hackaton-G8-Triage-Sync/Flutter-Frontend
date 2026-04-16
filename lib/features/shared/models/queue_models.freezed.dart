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
  @JsonKey(name: 'urgency_score')
  int get urgencyScore => throw _privateConstructorUsedError;
  String get condition => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this QueuePatient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QueuePatient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
    @JsonKey(name: 'urgency_score') int urgencyScore,
    String condition,
    String status,
    @JsonKey(name: 'created_at') DateTime createdAt,
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

  /// Create a copy of QueuePatient
  /// with the given fields replaced by the non-null parameter values.
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
    @JsonKey(name: 'urgency_score') int urgencyScore,
    String condition,
    String status,
    @JsonKey(name: 'created_at') DateTime createdAt,
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

  /// Create a copy of QueuePatient
  /// with the given fields replaced by the non-null parameter values.
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
  const _$QueuePatientImpl({
    required this.id,
    required this.description,
    required this.priority,
    @JsonKey(name: 'urgency_score') required this.urgencyScore,
    required this.condition,
    required this.status,
    @JsonKey(name: 'created_at') required this.createdAt,
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
  @JsonKey(name: 'urgency_score')
  final int urgencyScore;
  @override
  final String condition;
  @override
  final String status;
  @override
  @JsonKey(name: 'created_at')
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of QueuePatient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
  const factory _QueuePatient({
    required final int id,
    required final String description,
    required final int priority,
    @JsonKey(name: 'urgency_score') required final int urgencyScore,
    required final String condition,
    required final String status,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
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
  @JsonKey(name: 'urgency_score')
  int get urgencyScore;
  @override
  String get condition;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of QueuePatient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QueuePatientImplCopyWith<_$QueuePatientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StatusUpdateRequest _$StatusUpdateRequestFromJson(Map<String, dynamic> json) {
  return _StatusUpdateRequest.fromJson(json);
}

/// @nodoc
mixin _$StatusUpdateRequest {
  String get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this StatusUpdateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatusUpdateRequestCopyWith<StatusUpdateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatusUpdateRequestCopyWith<$Res> {
  factory $StatusUpdateRequestCopyWith(
    StatusUpdateRequest value,
    $Res Function(StatusUpdateRequest) then,
  ) = _$StatusUpdateRequestCopyWithImpl<$Res, StatusUpdateRequest>;
  @useResult
  $Res call({String status, String? notes});
}

/// @nodoc
class _$StatusUpdateRequestCopyWithImpl<$Res, $Val extends StatusUpdateRequest>
    implements $StatusUpdateRequestCopyWith<$Res> {
  _$StatusUpdateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? notes = freezed}) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StatusUpdateRequestImplCopyWith<$Res>
    implements $StatusUpdateRequestCopyWith<$Res> {
  factory _$$StatusUpdateRequestImplCopyWith(
    _$StatusUpdateRequestImpl value,
    $Res Function(_$StatusUpdateRequestImpl) then,
  ) = __$$StatusUpdateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, String? notes});
}

/// @nodoc
class __$$StatusUpdateRequestImplCopyWithImpl<$Res>
    extends _$StatusUpdateRequestCopyWithImpl<$Res, _$StatusUpdateRequestImpl>
    implements _$$StatusUpdateRequestImplCopyWith<$Res> {
  __$$StatusUpdateRequestImplCopyWithImpl(
    _$StatusUpdateRequestImpl _value,
    $Res Function(_$StatusUpdateRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? notes = freezed}) {
    return _then(
      _$StatusUpdateRequestImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StatusUpdateRequestImpl implements _StatusUpdateRequest {
  const _$StatusUpdateRequestImpl({required this.status, this.notes});

  factory _$StatusUpdateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatusUpdateRequestImplFromJson(json);

  @override
  final String status;
  @override
  final String? notes;

  @override
  String toString() {
    return 'StatusUpdateRequest(status: $status, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatusUpdateRequestImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, notes);

  /// Create a copy of StatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatusUpdateRequestImplCopyWith<_$StatusUpdateRequestImpl> get copyWith =>
      __$$StatusUpdateRequestImplCopyWithImpl<_$StatusUpdateRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StatusUpdateRequestImplToJson(this);
  }
}

abstract class _StatusUpdateRequest implements StatusUpdateRequest {
  const factory _StatusUpdateRequest({
    required final String status,
    final String? notes,
  }) = _$StatusUpdateRequestImpl;

  factory _StatusUpdateRequest.fromJson(Map<String, dynamic> json) =
      _$StatusUpdateRequestImpl.fromJson;

  @override
  String get status;
  @override
  String? get notes;

  /// Create a copy of StatusUpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatusUpdateRequestImplCopyWith<_$StatusUpdateRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
