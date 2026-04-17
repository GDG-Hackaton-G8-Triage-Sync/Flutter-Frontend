// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SymptomSubmission _$SymptomSubmissionFromJson(Map<String, dynamic> json) {
  return _SymptomSubmission.fromJson(json);
}

/// @nodoc
mixin _$SymptomSubmission {
  String get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SymptomSubmissionCopyWith<SymptomSubmission> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SymptomSubmissionCopyWith<$Res> {
  factory $SymptomSubmissionCopyWith(
    SymptomSubmission value,
    $Res Function(SymptomSubmission) then,
  ) = _$SymptomSubmissionCopyWithImpl<$Res, SymptomSubmission>;
  @useResult
  $Res call({String description});
}

/// @nodoc
class _$SymptomSubmissionCopyWithImpl<$Res, $Val extends SymptomSubmission>
    implements $SymptomSubmissionCopyWith<$Res> {
  _$SymptomSubmissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? description = null}) {
    return _then(
      _value.copyWith(
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SymptomSubmissionImplCopyWith<$Res>
    implements $SymptomSubmissionCopyWith<$Res> {
  factory _$$SymptomSubmissionImplCopyWith(
    _$SymptomSubmissionImpl value,
    $Res Function(_$SymptomSubmissionImpl) then,
  ) = __$$SymptomSubmissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String description});
}

/// @nodoc
class __$$SymptomSubmissionImplCopyWithImpl<$Res>
    extends _$SymptomSubmissionCopyWithImpl<$Res, _$SymptomSubmissionImpl>
    implements _$$SymptomSubmissionImplCopyWith<$Res> {
  __$$SymptomSubmissionImplCopyWithImpl(
    _$SymptomSubmissionImpl _value,
    $Res Function(_$SymptomSubmissionImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? description = null}) {
    return _then(
      _$SymptomSubmissionImpl(
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SymptomSubmissionImpl implements _SymptomSubmission {
  _$SymptomSubmissionImpl({required this.description});

  factory _$SymptomSubmissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SymptomSubmissionImplFromJson(json);

  @override
  final String description;

  @override
  String toString() {
    return 'SymptomSubmission(description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SymptomSubmissionImpl &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SymptomSubmissionImplCopyWith<_$SymptomSubmissionImpl> get copyWith =>
      __$$SymptomSubmissionImplCopyWithImpl<_$SymptomSubmissionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SymptomSubmissionImplToJson(this);
  }
}

abstract class _SymptomSubmission implements SymptomSubmission {
  factory _SymptomSubmission({required final String description}) =
      _$SymptomSubmissionImpl;

  factory _SymptomSubmission.fromJson(Map<String, dynamic> json) =
      _$SymptomSubmissionImpl.fromJson;

  @override
  String get description;
  @override
  @JsonKey(ignore: true)
  _$$SymptomSubmissionImplCopyWith<_$SymptomSubmissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TriageResult _$TriageResultFromJson(Map<String, dynamic> json) {
  return _TriageResult.fromJson(json);
}

/// @nodoc
mixin _$TriageResult {
  int get id => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  @JsonKey(name: 'urgency_score')
  int get urgencyScore => throw _privateConstructorUsedError;
  String get condition => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TriageResultCopyWith<TriageResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TriageResultCopyWith<$Res> {
  factory $TriageResultCopyWith(
    TriageResult value,
    $Res Function(TriageResult) then,
  ) = _$TriageResultCopyWithImpl<$Res, TriageResult>;
  @useResult
  $Res call({
    int id,
    int priority,
    @JsonKey(name: 'urgency_score') int urgencyScore,
    String condition,
    String status,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$TriageResultCopyWithImpl<$Res, $Val extends TriageResult>
    implements $TriageResultCopyWith<$Res> {
  _$TriageResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
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
abstract class _$$TriageResultImplCopyWith<$Res>
    implements $TriageResultCopyWith<$Res> {
  factory _$$TriageResultImplCopyWith(
    _$TriageResultImpl value,
    $Res Function(_$TriageResultImpl) then,
  ) = __$$TriageResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int priority,
    @JsonKey(name: 'urgency_score') int urgencyScore,
    String condition,
    String status,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$TriageResultImplCopyWithImpl<$Res>
    extends _$TriageResultCopyWithImpl<$Res, _$TriageResultImpl>
    implements _$$TriageResultImplCopyWith<$Res> {
  __$$TriageResultImplCopyWithImpl(
    _$TriageResultImpl _value,
    $Res Function(_$TriageResultImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? priority = null,
    Object? urgencyScore = null,
    Object? condition = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$TriageResultImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$TriageResultImpl implements _TriageResult {
  _$TriageResultImpl({
    required this.id,
    required this.priority,
    @JsonKey(name: 'urgency_score') required this.urgencyScore,
    required this.condition,
    required this.status,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$TriageResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TriageResultImplFromJson(json);

  @override
  final int id;
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
    return 'TriageResult(id: $id, priority: $priority, urgencyScore: $urgencyScore, condition: $condition, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriageResultImpl &&
            (identical(other.id, id) || other.id == id) &&
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
    priority,
    urgencyScore,
    condition,
    status,
    createdAt,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TriageResultImplCopyWith<_$TriageResultImpl> get copyWith =>
      __$$TriageResultImplCopyWithImpl<_$TriageResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TriageResultImplToJson(this);
  }
}

abstract class _TriageResult implements TriageResult {
  factory _TriageResult({
    required final int id,
    required final int priority,
    @JsonKey(name: 'urgency_score') required final int urgencyScore,
    required final String condition,
    required final String status,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$TriageResultImpl;

  factory _TriageResult.fromJson(Map<String, dynamic> json) =
      _$TriageResultImpl.fromJson;

  @override
  int get id;
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
  @override
  @JsonKey(ignore: true)
  _$$TriageResultImplCopyWith<_$TriageResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PatientJourney _$PatientJourneyFromJson(Map<String, dynamic> json) {
  return _PatientJourney.fromJson(json);
}

/// @nodoc
mixin _$PatientJourney {
  int get queuePosition => throw _privateConstructorUsedError;
  String get urgencyLevel => throw _privateConstructorUsedError;
  int get estimatedWaitMinutes => throw _privateConstructorUsedError;
  List<TimelineStep> get timeline => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PatientJourneyCopyWith<PatientJourney> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PatientJourneyCopyWith<$Res> {
  factory $PatientJourneyCopyWith(
    PatientJourney value,
    $Res Function(PatientJourney) then,
  ) = _$PatientJourneyCopyWithImpl<$Res, PatientJourney>;
  @useResult
  $Res call({
    int queuePosition,
    String urgencyLevel,
    int estimatedWaitMinutes,
    List<TimelineStep> timeline,
  });
}

/// @nodoc
class _$PatientJourneyCopyWithImpl<$Res, $Val extends PatientJourney>
    implements $PatientJourneyCopyWith<$Res> {
  _$PatientJourneyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? queuePosition = null,
    Object? urgencyLevel = null,
    Object? estimatedWaitMinutes = null,
    Object? timeline = null,
  }) {
    return _then(
      _value.copyWith(
            queuePosition: null == queuePosition
                ? _value.queuePosition
                : queuePosition // ignore: cast_nullable_to_non_nullable
                      as int,
            urgencyLevel: null == urgencyLevel
                ? _value.urgencyLevel
                : urgencyLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            estimatedWaitMinutes: null == estimatedWaitMinutes
                ? _value.estimatedWaitMinutes
                : estimatedWaitMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            timeline: null == timeline
                ? _value.timeline
                : timeline // ignore: cast_nullable_to_non_nullable
                      as List<TimelineStep>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PatientJourneyImplCopyWith<$Res>
    implements $PatientJourneyCopyWith<$Res> {
  factory _$$PatientJourneyImplCopyWith(
    _$PatientJourneyImpl value,
    $Res Function(_$PatientJourneyImpl) then,
  ) = __$$PatientJourneyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int queuePosition,
    String urgencyLevel,
    int estimatedWaitMinutes,
    List<TimelineStep> timeline,
  });
}

/// @nodoc
class __$$PatientJourneyImplCopyWithImpl<$Res>
    extends _$PatientJourneyCopyWithImpl<$Res, _$PatientJourneyImpl>
    implements _$$PatientJourneyImplCopyWith<$Res> {
  __$$PatientJourneyImplCopyWithImpl(
    _$PatientJourneyImpl _value,
    $Res Function(_$PatientJourneyImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? queuePosition = null,
    Object? urgencyLevel = null,
    Object? estimatedWaitMinutes = null,
    Object? timeline = null,
  }) {
    return _then(
      _$PatientJourneyImpl(
        queuePosition: null == queuePosition
            ? _value.queuePosition
            : queuePosition // ignore: cast_nullable_to_non_nullable
                  as int,
        urgencyLevel: null == urgencyLevel
            ? _value.urgencyLevel
            : urgencyLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        estimatedWaitMinutes: null == estimatedWaitMinutes
            ? _value.estimatedWaitMinutes
            : estimatedWaitMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        timeline: null == timeline
            ? _value._timeline
            : timeline // ignore: cast_nullable_to_non_nullable
                  as List<TimelineStep>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PatientJourneyImpl implements _PatientJourney {
  _$PatientJourneyImpl({
    required this.queuePosition,
    required this.urgencyLevel,
    required this.estimatedWaitMinutes,
    required final List<TimelineStep> timeline,
  }) : _timeline = timeline;

  factory _$PatientJourneyImpl.fromJson(Map<String, dynamic> json) =>
      _$$PatientJourneyImplFromJson(json);

  @override
  final int queuePosition;
  @override
  final String urgencyLevel;
  @override
  final int estimatedWaitMinutes;
  final List<TimelineStep> _timeline;
  @override
  List<TimelineStep> get timeline {
    if (_timeline is EqualUnmodifiableListView) return _timeline;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timeline);
  }

  @override
  String toString() {
    return 'PatientJourney(queuePosition: $queuePosition, urgencyLevel: $urgencyLevel, estimatedWaitMinutes: $estimatedWaitMinutes, timeline: $timeline)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatientJourneyImpl &&
            (identical(other.queuePosition, queuePosition) ||
                other.queuePosition == queuePosition) &&
            (identical(other.urgencyLevel, urgencyLevel) ||
                other.urgencyLevel == urgencyLevel) &&
            (identical(other.estimatedWaitMinutes, estimatedWaitMinutes) ||
                other.estimatedWaitMinutes == estimatedWaitMinutes) &&
            const DeepCollectionEquality().equals(other._timeline, _timeline));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    queuePosition,
    urgencyLevel,
    estimatedWaitMinutes,
    const DeepCollectionEquality().hash(_timeline),
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PatientJourneyImplCopyWith<_$PatientJourneyImpl> get copyWith =>
      __$$PatientJourneyImplCopyWithImpl<_$PatientJourneyImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PatientJourneyImplToJson(this);
  }
}

abstract class _PatientJourney implements PatientJourney {
  factory _PatientJourney({
    required final int queuePosition,
    required final String urgencyLevel,
    required final int estimatedWaitMinutes,
    required final List<TimelineStep> timeline,
  }) = _$PatientJourneyImpl;

  factory _PatientJourney.fromJson(Map<String, dynamic> json) =
      _$PatientJourneyImpl.fromJson;

  @override
  int get queuePosition;
  @override
  String get urgencyLevel;
  @override
  int get estimatedWaitMinutes;
  @override
  List<TimelineStep> get timeline;
  @override
  @JsonKey(ignore: true)
  _$$PatientJourneyImplCopyWith<_$PatientJourneyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimelineStep _$TimelineStepFromJson(Map<String, dynamic> json) {
  return _TimelineStep.fromJson(json);
}

/// @nodoc
mixin _$TimelineStep {
  DateTime get time => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TimelineStepCopyWith<TimelineStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimelineStepCopyWith<$Res> {
  factory $TimelineStepCopyWith(
    TimelineStep value,
    $Res Function(TimelineStep) then,
  ) = _$TimelineStepCopyWithImpl<$Res, TimelineStep>;
  @useResult
  $Res call({DateTime time, String description});
}

/// @nodoc
class _$TimelineStepCopyWithImpl<$Res, $Val extends TimelineStep>
    implements $TimelineStepCopyWith<$Res> {
  _$TimelineStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? time = null, Object? description = null}) {
    return _then(
      _value.copyWith(
            time: null == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimelineStepImplCopyWith<$Res>
    implements $TimelineStepCopyWith<$Res> {
  factory _$$TimelineStepImplCopyWith(
    _$TimelineStepImpl value,
    $Res Function(_$TimelineStepImpl) then,
  ) = __$$TimelineStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime time, String description});
}

/// @nodoc
class __$$TimelineStepImplCopyWithImpl<$Res>
    extends _$TimelineStepCopyWithImpl<$Res, _$TimelineStepImpl>
    implements _$$TimelineStepImplCopyWith<$Res> {
  __$$TimelineStepImplCopyWithImpl(
    _$TimelineStepImpl _value,
    $Res Function(_$TimelineStepImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? time = null, Object? description = null}) {
    return _then(
      _$TimelineStepImpl(
        time: null == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimelineStepImpl implements _TimelineStep {
  _$TimelineStepImpl({required this.time, required this.description});

  factory _$TimelineStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimelineStepImplFromJson(json);

  @override
  final DateTime time;
  @override
  final String description;

  @override
  String toString() {
    return 'TimelineStep(time: $time, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimelineStepImpl &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, time, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimelineStepImplCopyWith<_$TimelineStepImpl> get copyWith =>
      __$$TimelineStepImplCopyWithImpl<_$TimelineStepImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimelineStepImplToJson(this);
  }
}

abstract class _TimelineStep implements TimelineStep {
  factory _TimelineStep({
    required final DateTime time,
    required final String description,
  }) = _$TimelineStepImpl;

  factory _TimelineStep.fromJson(Map<String, dynamic> json) =
      _$TimelineStepImpl.fromJson;

  @override
  DateTime get time;
  @override
  String get description;
  @override
  @JsonKey(ignore: true)
  _$$TimelineStepImplCopyWith<_$TimelineStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
