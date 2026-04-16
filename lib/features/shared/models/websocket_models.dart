import 'package:freezed_annotation/freezed_annotation.dart';

part 'websocket_models.freezed.dart';
part 'websocket_models.g.dart';

@freezed
class WebSocketMessage with _$WebSocketMessage {
  const factory WebSocketMessage({
    required String type,
    Map<String, dynamic>? data,
  }) = _WebSocketMessage;

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) =>
      _$WebSocketMessageFromJson(json);
}

@freezed
class PatientUpdateData with _$PatientUpdateData {
  const factory PatientUpdateData({
    required int id,
    required String status,
    required int priority,
    @JsonKey(name: 'urgency_score') required int urgencyScore,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _PatientUpdateData;

  factory PatientUpdateData.fromJson(Map<String, dynamic> json) =>
      _$PatientUpdateDataFromJson(json);
}
