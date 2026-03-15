import 'package:swf_app/src/api/api_client.dart';
import 'package:swf_app/src/api/api_result.dart';

class ProfileRepository {
  const ProfileRepository({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<ApiResult<SubscriberStats>> getSubscriberStats() {
    return _apiClient.get<SubscriberStats>(
      '/api/subscribers/count',
      fromJson: (json) =>
          SubscriberStats.fromJson(json as Map<String, Object?>),
    );
  }
}

class SubscriberStats {
  const SubscriberStats({
    required this.total,
    required this.confirmed,
    required this.unsubscribed,
    required this.active,
    this.authorName,
  });

  final int total;
  final int confirmed;
  final int unsubscribed;
  final int active;
  final String? authorName;

  factory SubscriberStats.fromJson(Map<String, Object?> json) {
    return SubscriberStats(
      total: (json['count'] as num?)?.toInt() ?? 0,
      confirmed: (json['confirmed'] as num?)?.toInt() ?? 0,
      unsubscribed: (json['unsubscribed'] as num?)?.toInt() ?? 0,
      active: (json['active'] as num?)?.toInt() ?? 0,
      authorName: json['authorName'] as String?,
    );
  }
}
