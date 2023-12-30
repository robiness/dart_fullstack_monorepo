class SharedModel {
  SharedModel({
    required this.value,
  });

  String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SharedModel && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;

  Map<String, dynamic> toJson() {
    return {
      'value': value,
    };
  }

  factory SharedModel.fromJson(Map<String, dynamic> map) {
    return SharedModel(
      value: map['value'] as String,
    );
  }
}
