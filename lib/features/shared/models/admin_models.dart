import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_models.freezed.dart';
part 'admin_models.g.dart';

@freezed
class SystemOverview with _$SystemOverview {
  factory SystemOverview({
    required int totalPatients,
    required int waiting,
    required int inProgress,
    required int completed,
    required int criticalCases,
  }) = _SystemOverview;

  factory SystemOverview.fromJson(Map<String, dynamic> json) =>
      _$SystemOverviewFromJson(json);
}
