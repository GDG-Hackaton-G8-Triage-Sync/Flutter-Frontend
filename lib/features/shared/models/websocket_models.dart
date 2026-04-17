import 'package:freezed_annotation/freezed_annotation.dart';

part 'websocket_models.freezed.dart';
part 'websocket_models.g.dart';

@freezed
class PatientUpdateData with _$PatientUpdateData {
  factory PatientUpdateData({
    required int id,
    required String status,
    required int priority,
  }) = _PatientUpdateData;

  factory PatientUpdateData.fromJson(Map<String, dynamic> json) =>
      _$PatientUpdateDataFromJson(json);
}
