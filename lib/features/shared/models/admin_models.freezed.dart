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
  int get totalPatients => throw _privateConstructorUsedError;
  int get waiting => throw _privateConstructorUsedError;
  int get inProgress => throw _privateConstructorUsedError;
  int get completed => throw _privateConstructorUsedError;
  int get criticalCases => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
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
    int totalPatients,
    int waiting,
    int inProgress,
    int completed,
    int criticalCases,
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
    int totalPatients,
    int waiting,
    int inProgress,
    int completed,
    int criticalCases,
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
  _$SystemOverviewImpl({
    required this.totalPatients,
    required this.waiting,
    required this.inProgress,
    required this.completed,
    required this.criticalCases,
  });

  factory _$SystemOverviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$SystemOverviewImplFromJson(json);

  @override
  final int totalPatients;
  @override
  final int waiting;
  @override
  final int inProgress;
  @override
  final int completed;
  @override
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalPatients,
    waiting,
    inProgress,
    completed,
    criticalCases,
  );

  @JsonKey(ignore: true)
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
  factory _SystemOverview({
    required final int totalPatients,
    required final int waiting,
    required final int inProgress,
    required final int completed,
    required final int criticalCases,
  }) = _$SystemOverviewImpl;

  factory _SystemOverview.fromJson(Map<String, dynamic> json) =
      _$SystemOverviewImpl.fromJson;

  @override
  int get totalPatients;
  @override
  int get waiting;
  @override
  int get inProgress;
  @override
  int get completed;
  @override
  int get criticalCases;
  @override
  @JsonKey(ignore: true)
  _$$SystemOverviewImplCopyWith<_$SystemOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
