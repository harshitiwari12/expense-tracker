class EmailOtpModel {
  final String email;
  final String otp;

  EmailOtpModel({required this.email, required this.otp});

  factory EmailOtpModel.fromJson(Map<String, dynamic> json) {
    return EmailOtpModel(
      email: json['email'] ?? '',
      otp: json['otp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}
