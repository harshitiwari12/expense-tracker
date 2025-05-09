class User{
  String name;
  String email;
  String password;
  String bank;
  String mobile;
  User({required this.name, required this.email,required this.password,required this.bank,required this.mobile});

  Map<String, dynamic> toJson() => {
    'name' : name,
    'email' : email,
    'password' : password,
    'bank' : bank,
    'mobileNo' : mobile
  };

}
