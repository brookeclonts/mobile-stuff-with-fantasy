/// Persisted configuration for a user's composed sigil / heraldic crest.
class SigilConfig {
  const SigilConfig({
    required this.shieldId,
    required this.fieldId,
    required this.chargeId,
    required this.borderId,
  });

  final String shieldId;
  final String fieldId;
  final String chargeId;
  final String borderId;

  factory SigilConfig.fromJson(Map<String, dynamic> json) {
    return SigilConfig(
      shieldId: json['shieldId'] as String,
      fieldId: json['fieldId'] as String,
      chargeId: json['chargeId'] as String,
      borderId: json['borderId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'shieldId': shieldId,
        'fieldId': fieldId,
        'chargeId': chargeId,
        'borderId': borderId,
      };

  SigilConfig copyWith({
    String? shieldId,
    String? fieldId,
    String? chargeId,
    String? borderId,
  }) {
    return SigilConfig(
      shieldId: shieldId ?? this.shieldId,
      fieldId: fieldId ?? this.fieldId,
      chargeId: chargeId ?? this.chargeId,
      borderId: borderId ?? this.borderId,
    );
  }
}
