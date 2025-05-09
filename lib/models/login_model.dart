class LoginRequest {
  final String mobileNo;
  LoginRequest({required this.mobileNo});

  Map<String, dynamic> toJson() => {
    "mobileNo": mobileNo,
  };
}
