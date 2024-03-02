import '../../../logger.dart';

class AuthData {
  AuthData({
    required this.accessToken,
    required this.tokenType,
    required this.expiresAt,
  });

  final String accessToken;
  final String tokenType;
  final String expiresAt;

  String get finalizedToken => "$tokenType $accessToken";

  bool isTokenExpired() {
    try {
      DateTime parsedTime = DateTime.parse(expiresAt);
      DateTime currentTime = DateTime.now().toUtc();

      return parsedTime.isBefore(currentTime);
    } catch (e) {
      logger.e("Error: $e");
      return false;
    }
  }

  @override
  factory AuthData.fromJson(Map<String, dynamic> data) {
    return AuthData(
      accessToken: data['access_token'],
      tokenType: data['token_type'],
      expiresAt: data['expires_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_at": expiresAt,
      };

  @override
  String toString() {
    return 'AuthResponse{accessToken: $accessToken, tokenType: $tokenType, expiresAt: $expiresAt,}';
  }
}
