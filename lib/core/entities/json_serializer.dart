import 'dart:convert';

/// JSON Serializer for encoding/decoding JSON data
class JsonSerializer {
  const JsonSerializer();

  /// Encodes an object to JSON string
  String encode(Object? data) {
    return jsonEncode(data);
  }

  /// Decodes a JSON string to a Map or List
  dynamic decode(String source) {
    return jsonDecode(source);
  }

  /// Serializes a Map to JSON string
  String serialize(Map<String, dynamic> data) {
    return jsonEncode(data);
  }

  /// Deserializes a JSON string to Map
  Map<String, dynamic> deserialize(String source) {
    final decoded = jsonDecode(source);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    throw FormatException('Invalid JSON format: expected a Map');
  }

  /// Safely deserializes JSON string, returns null if invalid
  Map<String, dynamic>? tryDeserialize(String source) {
    try {
      final decoded = jsonDecode(source);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
