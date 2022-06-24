class Biller {
  String date;
  String amount;
  String phone;
  String name;
  String description;
  String cycle;
  String userid;
  String invoicenumber;

  Biller(
      {required this.date,
      required this.amount,
      required this.phone,
      required this.name,
      required this.description,
      required this.cycle,
      required this.userid,
      required this.invoicenumber});

  factory Biller.fromJson(Map<dynamic, dynamic> json) => Biller(
      amount: '',
      cycle: '',
      date: '',
      description: '',
      invoicenumber: '',
      name: '',
      phone: '',
      userid: '');
}
