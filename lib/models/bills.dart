class Bills {
  final String userid,
      clientname,
      billcode,
      description,
      phone,
      sheduletype,
      schedulestart,
      status;
  final int amount;
  Bills(
      this.description,
      this.amount,
      this.billcode,
      this.userid,
      this.clientname,
      this.phone,
      this.sheduletype,
      this.schedulestart,
      this.status);
}
