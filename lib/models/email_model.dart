class EmailOtp {
  final String email;
  final String otp;

  EmailOtp({required this.email, required this.otp});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}
