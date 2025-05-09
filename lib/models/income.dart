class Income{
  double monthlyIncome;
  double targetSaving;
  Income({
    required this.monthlyIncome,
    required this.targetSaving
  });

  Map<String,dynamic> toJson() =>{
  "monthlyIncome" : monthlyIncome,
  "targetSaving" : targetSaving
  };
}


