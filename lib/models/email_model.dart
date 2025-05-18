
class EmailVerificationRequest {
  final String email;
  final String? otp;

  EmailVerificationRequest({
    required this.email,
    this.otp,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    if (otp != null) 'otp': otp,
  };
}

class EmailVerificationResponse {
  final bool success;
  final String message;
  final String? otp;

  EmailVerificationResponse({
    required this.success,
    required this.message,
    this.otp,
  });

  factory EmailVerificationResponse.fromJson(Map<String, dynamic> json) {
    return EmailVerificationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      otp: json['otp'],
    );
  }
}