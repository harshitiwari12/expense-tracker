class User{
  String name;
  String email;
  String bank;
  String mobile;
  User({required this.name, required this.email,required this.bank,required this.mobile});

  Map<String, dynamic> toJson() => {
    'name' : name,
    'email' : email,
    'bank' : bank,
    'mobileNo' : mobile
  };

}
