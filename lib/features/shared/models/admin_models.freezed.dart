// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SystemOverview _$SystemOverviewFromJson(Map<String, dynamic> json) {
  return _SystemOverview.fromJson(json);
}

/// @nodoc
mixin _$SystemOverview {
  @JsonKey(name: 'total_patients')
  int get totalPatients => throw _privateConstructorUsedError;
  int get waiting => throw _privateConstructorUsedError;
  @JsonKey(name: 'in_progress')
  int get inProgress => throw _privateConstructorUsedError;
  int get completed => throw _privateConstructorUsedError;
  @JsonKey(name: 'critical_cases')
  int get criticalCases => throw _privateConstructorUsedError;

  /// Serializes this SystemOverview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SystemOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SystemOverviewCopyWith<SystemOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemOverviewCopyWith<$Res> {
  factory $SystemOverviewCopyWith(
    SystemOverview value,
    $Res Function(SystemOverview) then,
  ) = _$SystemOverviewCopyWithImpl<$Res, SystemOverview>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_patients') int totalPatients,
    int waiting,
    @JsonKey(name: 'in_progress') int inProgress,
    int completed,
    @JsonKey(name: 'critical_cases') int criticalCases,
  });
}

/// @nodoc
class _$SystemOverviewCopyWithImpl<$Res, $Val extends SystemOverview>
    implements $SystemOverviewCopyWith<$Res> {
  _$SystemOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SystemOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPatients = null,
    Object? waiting = null,
    Object? inProgress = null,
    Object? completed = null,
    Object? criticalCases = null,
  }) {
    return _then(
      _value.copyWith(
            totalPatients: null == totalPatients
                ? _value.totalPatients
                : totalPatients // ignore: cast_nullable_to_non_nullable
                      as int,
            waiting: null == waiting
                ? _value.waiting
                : waiting // ignore: cast_nullable_to_non_nullable
                      as int,
            inProgress: null == inProgress
                ? _value.inProgress
                : inProgress // ignore: cast_nullable_to_non_nullable
                      as int,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as int,
            criticalCases: null == criticalCases
                ? _value.criticalCases
                : criticalCases // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SystemOverviewImplCopyWith<$Res>
    implements $SystemOverviewCopyWith<$Res> {
  factory _$$SystemOverviewImplCopyWith(
    _$SystemOverviewImpl value,
    $Res Function(_$SystemOverviewImpl) then,
  ) = __$$SystemOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_patients') int totalPatients,
    int waiting,
    @JsonKey(name: 'in_progress') int inProgress,
    int completed,
    @JsonKey(name: 'critical_cases') int criticalCases,
  });
}

/// @nodoc
class __$$SystemOverviewImplCopyWithImpl<$Res>
    extends _$SystemOverviewCopyWithImpl<$Res, _$SystemOverviewImpl>
    implements _$$SystemOverviewImplCopyWith<$Res> {
  __$$SystemOverviewImplCopyWithImpl(
    _$SystemOverviewImpl _value,
    $Res Function(_$SystemOverviewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SystemOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPatients = null,
    Object? waiting = null,
    Object? inProgress = null,
    Object? completed = null,
    Object? criticalCases = null,
  }) {
    return _then(
      _$SystemOverviewImpl(
        totalPatients: null == totalPatients
            ? _value.totalPatients
            : totalPatients // ignore: cast_nullable_to_non_nullable
                  as int,
        waiting: null == waiting
            ? _value.waiting
            : waiting // ignore: cast_nullable_to_non_nullable
                  as int,
        inProgress: null == inProgress
            ? _value.inProgress
            : inProgress // ignore: cast_nullable_to_non_nullable
                  as int,
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as int,
        criticalCases: null == criticalCases
            ? _value.criticalCases
            : criticalCases // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SystemOverviewImpl implements _SystemOverview {
  const _$SystemOverviewImpl({
    @JsonKey(name: 'total_patients') required this.totalPatients,
    required this.waiting,
    @JsonKey(name: 'in_progress') required this.inProgress,
    required this.completed,
    @JsonKey(name: 'critical_cases') required this.criticalCases,
  });

  factory _$SystemOverviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$SystemOverviewImplFromJson(json);

  @override
  @JsonKey(name: 'total_patients')
  final int totalPatients;
  @override
  final int waiting;
  @override
  @JsonKey(name: 'in_progress')
  final int inProgress;
  @override
  final int completed;
  @override
  @JsonKey(name: 'critical_cases')
  final int criticalCases;

  @override
  String toString() {
    return 'SystemOverview(totalPatients: $totalPatients, waiting: $waiting, inProgress: $inProgress, completed: $completed, criticalCases: $criticalCases)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemOverviewImpl &&
            (identical(other.totalPatients, totalPatients) ||
                other.totalPatients == totalPatients) &&
            (identical(other.waiting, waiting) || other.waiting == waiting) &&
            (identical(other.inProgress, inProgress) ||
                other.inProgress == inProgress) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.criticalCases, criticalCases) ||
                other.criticalCases == criticalCases));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalPatients,
    waiting,
    inProgress,
    completed,
    criticalCases,
  );

  /// Create a copy of SystemOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemOverviewImplCopyWith<_$SystemOverviewImpl> get copyWith =>
      __$$SystemOverviewImplCopyWithImpl<_$SystemOverviewImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SystemOverviewImplToJson(this);
  }
}

abstract class _SystemOverview implements SystemOverview {
  const factory _SystemOverview({
    @JsonKey(name: 'total_patients') required final int totalPatients,
    required final int waiting,
    @JsonKey(name: 'in_progress') required final int inProgress,
    required final int completed,
    @JsonKey(name: 'critical_cases') required final int criticalCases,
  }) = _$SystemOverviewImpl;

  factory _SystemOverview.fromJson(Map<String, dynamic> json) =
      _$SystemOverviewImpl.fromJson;

  @override
  @JsonKey(name: 'total_patients')
  int get totalPatients;
  @override
  int get waiting;
  @override
  @JsonKey(name: 'in_progress')
  int get inProgress;
  @override
  int get completed;
  @override
  @JsonKey(name: 'critical_cases')
  int get criticalCases;

  /// Create a copy of SystemOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SystemOverviewImplCopyWith<_$SystemOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Analytics _$AnalyticsFromJson(Map<String, dynamic> json) {
  return _Analytics.fromJson(json);
}

/// @nodoc
mixin _$Analytics {
  @JsonKey(name: 'average_wait_minutes')
  double get averageWaitMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_patients')
  int get dailyPatients => throw _privateConstructorUsedError;
  @JsonKey(name: 'resolved_today')
  int get resolvedToday => throw _privateConstructorUsedError;

  /// Serializes this Analytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Analytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsCopyWith<Analytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsCopyWith<$Res> {
  factory $AnalyticsCopyWith(Analytics value, $Res Function(Analytics) then) =
      _$AnalyticsCopyWithImpl<$Res, Analytics>;
  @useResult
  $Res call({
    @JsonKey(name: 'average_wait_minutes') double averageWaitMinutes,
    @JsonKey(name: 'daily_patients') int dailyPatients,
    @JsonKey(name: 'resolved_today') int resolvedToday,
  });
}

/// @nodoc
class _$AnalyticsCopyWithImpl<$Res, $Val extends Analytics>
    implements $AnalyticsCopyWith<$Res> {
  _$AnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Analytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageWaitMinutes = null,
    Object? dailyPatients = null,
    Object? resolvedToday = null,
  }) {
    return _then(
      _value.copyWith(
            averageWaitMinutes: null == averageWaitMinutes
                ? _value.averageWaitMinutes
                : averageWaitMinutes // ignore: cast_nullable_to_non_nullable
                      as double,
            dailyPatients: null == dailyPatients
                ? _value.dailyPatients
                : dailyPatients // ignore: cast_nullable_to_non_nullable
                      as int,
            resolvedToday: null == resolvedToday
                ? _value.resolvedToday
                : resolvedToday // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnalyticsImplCopyWith<$Res>
    implements $AnalyticsCopyWith<$Res> {
  factory _$$AnalyticsImplCopyWith(
    _$AnalyticsImpl value,
    $Res Function(_$AnalyticsImpl) then,
  ) = __$$AnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'average_wait_minutes') double averageWaitMinutes,
    @JsonKey(name: 'daily_patients') int dailyPatients,
    @JsonKey(name: 'resolved_today') int resolvedToday,
  });
}

/// @nodoc
class __$$AnalyticsImplCopyWithImpl<$Res>
    extends _$AnalyticsCopyWithImpl<$Res, _$AnalyticsImpl>
    implements _$$AnalyticsImplCopyWith<$Res> {
  __$$AnalyticsImplCopyWithImpl(
    _$AnalyticsImpl _value,
    $Res Function(_$AnalyticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Analytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageWaitMinutes = null,
    Object? dailyPatients = null,
    Object? resolvedToday = null,
  }) {
    return _then(
      _$AnalyticsImpl(
        averageWaitMinutes: null == averageWaitMinutes
            ? _value.averageWaitMinutes
            : averageWaitMinutes // ignore: cast_nullable_to_non_nullable
                  as double,
        dailyPatients: null == dailyPatients
            ? _value.dailyPatients
            : dailyPatients // ignore: cast_nullable_to_non_nullable
                  as int,
        resolvedToday: null == resolvedToday
            ? _value.resolvedToday
            : resolvedToday // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsImpl implements _Analytics {
  const _$AnalyticsImpl({
    @JsonKey(name: 'average_wait_minutes') required this.averageWaitMinutes,
    @JsonKey(name: 'daily_patients') required this.dailyPatients,
    @JsonKey(name: 'resolved_today') required this.resolvedToday,
  });

  factory _$AnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsImplFromJson(json);

  @override
  @JsonKey(name: 'average_wait_minutes')
  final double averageWaitMinutes;
  @override
  @JsonKey(name: 'daily_patients')
  final int dailyPatients;
  @override
  @JsonKey(name: 'resolved_today')
  final int resolvedToday;

  @override
  String toString() {
    return 'Analytics(averageWaitMinutes: $averageWaitMinutes, dailyPatients: $dailyPatients, resolvedToday: $resolvedToday)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsImpl &&
            (identical(other.averageWaitMinutes, averageWaitMinutes) ||
                other.averageWaitMinutes == averageWaitMinutes) &&
            (identical(other.dailyPatients, dailyPatients) ||
                other.dailyPatients == dailyPatients) &&
            (identical(other.resolvedToday, resolvedToday) ||
                other.resolvedToday == resolvedToday));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    averageWaitMinutes,
    dailyPatients,
    resolvedToday,
  );

  /// Create a copy of Analytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsImplCopyWith<_$AnalyticsImpl> get copyWith =>
      __$$AnalyticsImplCopyWithImpl<_$AnalyticsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsImplToJson(this);
  }
}

abstract class _Analytics implements Analytics {
  const factory _Analytics({
    @JsonKey(name: 'average_wait_minutes')
    required final double averageWaitMinutes,
    @JsonKey(name: 'daily_patients') required final int dailyPatients,
    @JsonKey(name: 'resolved_today') required final int resolvedToday,
  }) = _$AnalyticsImpl;

  factory _Analytics.fromJson(Map<String, dynamic> json) =
      _$AnalyticsImpl.fromJson;

  @override
  @JsonKey(name: 'average_wait_minutes')
  double get averageWaitMinutes;
  @override
  @JsonKey(name: 'daily_patients')
  int get dailyPatients;
  @override
  @JsonKey(name: 'resolved_today')
  int get resolvedToday;

  /// Create a copy of Analytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsImplCopyWith<_$AnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({
    int id,
    String name,
    String email,
    String role,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? role = null,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
    _$UserImpl value,
    $Res Function(_$UserImpl) then,
  ) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String email,
    String role,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
    : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? role = null,
    Object? isActive = null,
  }) {
    return _then(
      _$UserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    @JsonKey(name: 'is_active') required this.isActive,
  });

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String role;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $role, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, email, role, isActive);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(this);
  }
}

abstract class _User implements User {
  const factory _User({
    required final int id,
    required final String name,
    required final String email,
    required final String role,
    @JsonKey(name: 'is_active') required final bool isActive,
  }) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String get role;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
