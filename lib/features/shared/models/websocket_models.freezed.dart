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

WebSocketMessage _$WebSocketMessageFromJson(Map<String, dynamic> json) {
  return _WebSocketMessage.fromJson(json);
}

/// @nodoc
mixin _$WebSocketMessage {
  String get type => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;

  /// Serializes this WebSocketMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WebSocketMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WebSocketMessageCopyWith<WebSocketMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebSocketMessageCopyWith<$Res> {
  factory $WebSocketMessageCopyWith(
    WebSocketMessage value,
    $Res Function(WebSocketMessage) then,
  ) = _$WebSocketMessageCopyWithImpl<$Res, WebSocketMessage>;
  @useResult
  $Res call({String type, Map<String, dynamic>? data});
}

/// @nodoc
class _$WebSocketMessageCopyWithImpl<$Res, $Val extends WebSocketMessage>
    implements $WebSocketMessageCopyWith<$Res> {
  _$WebSocketMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WebSocketMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? data = freezed}) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WebSocketMessageImplCopyWith<$Res>
    implements $WebSocketMessageCopyWith<$Res> {
  factory _$$WebSocketMessageImplCopyWith(
    _$WebSocketMessageImpl value,
    $Res Function(_$WebSocketMessageImpl) then,
  ) = __$$WebSocketMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, Map<String, dynamic>? data});
}

/// @nodoc
class __$$WebSocketMessageImplCopyWithImpl<$Res>
    extends _$WebSocketMessageCopyWithImpl<$Res, _$WebSocketMessageImpl>
    implements _$$WebSocketMessageImplCopyWith<$Res> {
  __$$WebSocketMessageImplCopyWithImpl(
    _$WebSocketMessageImpl _value,
    $Res Function(_$WebSocketMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WebSocketMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? data = freezed}) {
    return _then(
      _$WebSocketMessageImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        data: freezed == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WebSocketMessageImpl implements _WebSocketMessage {
  const _$WebSocketMessageImpl({
    required this.type,
    final Map<String, dynamic>? data,
  }) : _data = data;

  factory _$WebSocketMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$WebSocketMessageImplFromJson(json);

  @override
  final String type;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'WebSocketMessage(type: $type, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WebSocketMessageImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    const DeepCollectionEquality().hash(_data),
  );

  /// Create a copy of WebSocketMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WebSocketMessageImplCopyWith<_$WebSocketMessageImpl> get copyWith =>
      __$$WebSocketMessageImplCopyWithImpl<_$WebSocketMessageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WebSocketMessageImplToJson(this);
  }
}

abstract class _WebSocketMessage implements WebSocketMessage {
  const factory _WebSocketMessage({
    required final String type,
    final Map<String, dynamic>? data,
  }) = _$WebSocketMessageImpl;

  factory _WebSocketMessage.fromJson(Map<String, dynamic> json) =
      _$WebSocketMessageImpl.fromJson;

  @override
  String get type;
  @override
  Map<String, dynamic>? get data;

  /// Create a copy of WebSocketMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WebSocketMessageImplCopyWith<_$WebSocketMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PatientUpdateData _$PatientUpdateDataFromJson(Map<String, dynamic> json) {
  return _PatientUpdateData.fromJson(json);
}

/// @nodoc
mixin _$PatientUpdateData {
  int get id => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  @JsonKey(name: 'urgency_score')
  int get urgencyScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PatientUpdateData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PatientUpdateData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
  $Res call({
    int id,
    String status,
    int priority,
    @JsonKey(name: 'urgency_score') int urgencyScore,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$PatientUpdateDataCopyWithImpl<$Res, $Val extends PatientUpdateData>
    implements $PatientUpdateDataCopyWith<$Res> {
  _$PatientUpdateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PatientUpdateData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? priority = null,
    Object? urgencyScore = null,
    Object? updatedAt = null,
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
            urgencyScore: null == urgencyScore
                ? _value.urgencyScore
                : urgencyScore // ignore: cast_nullable_to_non_nullable
                      as int,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
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
  $Res call({
    int id,
    String status,
    int priority,
    @JsonKey(name: 'urgency_score') int urgencyScore,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$PatientUpdateDataImplCopyWithImpl<$Res>
    extends _$PatientUpdateDataCopyWithImpl<$Res, _$PatientUpdateDataImpl>
    implements _$$PatientUpdateDataImplCopyWith<$Res> {
  __$$PatientUpdateDataImplCopyWithImpl(
    _$PatientUpdateDataImpl _value,
    $Res Function(_$PatientUpdateDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PatientUpdateData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? priority = null,
    Object? urgencyScore = null,
    Object? updatedAt = null,
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
        urgencyScore: null == urgencyScore
            ? _value.urgencyScore
            : urgencyScore // ignore: cast_nullable_to_non_nullable
                  as int,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PatientUpdateDataImpl implements _PatientUpdateData {
  const _$PatientUpdateDataImpl({
    required this.id,
    required this.status,
    required this.priority,
    @JsonKey(name: 'urgency_score') required this.urgencyScore,
    @JsonKey(name: 'updated_at') required this.updatedAt,
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
  @JsonKey(name: 'urgency_score')
  final int urgencyScore;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PatientUpdateData(id: $id, status: $status, priority: $priority, urgencyScore: $urgencyScore, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatientUpdateDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.urgencyScore, urgencyScore) ||
                other.urgencyScore == urgencyScore) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, status, priority, urgencyScore, updatedAt);

  /// Create a copy of PatientUpdateData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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
  const factory _PatientUpdateData({
    required final int id,
    required final String status,
    required final int priority,
    @JsonKey(name: 'urgency_score') required final int urgencyScore,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
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
  @JsonKey(name: 'urgency_score')
  int get urgencyScore;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of PatientUpdateData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PatientUpdateDataImplCopyWith<_$PatientUpdateDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
