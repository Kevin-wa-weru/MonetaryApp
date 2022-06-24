import 'package:billingapp/constants.dart';
import 'package:billingapp/screens/createbill/createbill.dart';
import 'package:billingapp/screens/createinvoice/createinvoice.dart';
import 'package:billingapp/screens/dashboard/linetitles.dart';
import 'package:billingapp/screens/profile/profile.dart';
import 'package:billingapp/screens/signin/signin.dart';
import 'package:billingapp/screens/viewbills/viewbills.dart';
import 'package:billingapp/screens/viewinvoices/viewinvoice.dart';
import 'package:billingapp/screens/viewpayments/viewpays.dart';
import 'package:billingapp/services/firebaseserivices.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  final inactiveColor = Colors.black54;
  String? name;
  bool appisLoading = false;
  double totalbillsmade = 0;
  double totalPaymentsmade = 0;
  double totalbillsmadepercent = 0;
  double totalPaymentsmadepercent = 0;

  List<Map<dynamic, dynamic>> bills = [];
  List<Map<dynamic, dynamic>> pay = [];
  List<Map<dynamic, dynamic>> invoices = [];

  List<FlSpot> weeklyspots = [];
  List<FlSpot> monthlyspots = [];
  List<FlSpot> yearlyspots = [];

  double totalWeeklybill = 0;
  double totalWeeklypays = 0;
  double totalWeeklyinvoices = 0;
  double totalMonthlybill = 0;
  double totalMonthlypays = 0;
  double totalMonthlyinvoices = 0;
  double totalYearlybill = 0;
  double totalYearlypays = 0;
  double totalYearlyinvoices = 0;

  double totalWeeklybilllength = 0;
  double totalWeeklypayslength = 0;
  double totalWeeklyinvoiceslength = 0;
  double totalMonthlybilllength = 0;
  double totalMonthlypayslength = 0;
  double totalMonthlyinvoiceslength = 0;
  double totalYearlybilllength = 0;
  double totalYearlypayslength = 0;
  double totalYearlyinvoiceslength = 0;

  bool hasNoChartValues = false;

  List<PieChartSectionData> paiChartSelectionDatas = [];

  double scaleFactor = 1.0;

  Widget getBody() {
    List<Widget> pages = [
      DashBoard(
        name: name.toString(),
        weeklyspots: weeklyspots,
        monthlyspots: monthlyspots,
        yearlyspots: yearlyspots,
        totalWeeklyPays: totalWeeklypays.toString(),
        totalWeeklyBills: totalWeeklybill.toString(),
        totalWeeklyInvoices: totalWeeklyinvoices.toString(),
        totalWeeklyPayslength: totalWeeklypayslength.round().toString(),
        totalWeeklyBillslength: totalWeeklybilllength.round().toString(),
        totalWeeklyInvoiceslength: totalWeeklyinvoiceslength.round().toString(),
        totalMonthlyPays: totalMonthlypays.toString(),
        totalMonthlyBills: totalMonthlybill.toString(),
        totalMonthlyInvoices: totalMonthlyinvoices.toString(),
        totalMonthlyPayslength: totalMonthlypayslength.round().toString(),
        totalMonthlyBillslength: totalMonthlybilllength.round().toString(),
        totalMonthlyInvoiceslength:
            totalMonthlyinvoiceslength.round().toString(),
        totalYearlyPays: totalYearlypays.toString(),
        totalYearlyBills: totalYearlybill.toString(),
        totalYearlyInvoices: totalYearlyinvoices.toString(),
        totalYearlyPayslength: totalYearlybilllength.round().toString(),
        totalYearlyBillslength: totalYearlybilllength.round().toString(),
        totalYearlyInvoiceslength: totalYearlyinvoiceslength.round().toString(),
      ),
      const CreateInvoice(),
      const CreateBill(),
      const ViewInvoices(),
      const ViewBills(),
      const Pay(),
    ];
    return IndexedStack(
      index: currentIndex,
      children: pages,
    );
  }

  Future getAllUserDetails() async {
    setState(() {
      appisLoading = true;
    });

    var response = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseServices().getUserId())
        .get();

    setState(() {
      name = response.data()!['name'];
    });

    final CollectionReference paysRef =
        FirebaseFirestore.instance.collection("payments");
    final CollectionReference billsRef =
        FirebaseFirestore.instance.collection("bills");
    final CollectionReference invoicesRef =
        FirebaseFirestore.instance.collection("invoices");

    // ignore: prefer_typing_uninitialized_variables
    var payment;
    // ignore: prefer_typing_uninitialized_variables
    var amount;

    var payments = await paysRef
        .where('userid', isEqualTo: FirebaseServices().getUserId())
        .get();

    var paymentss = payments.docs;

    // ignore: prefer_typing_uninitialized_variables

    for (payment in paymentss) {
      setState(() {
        pay.add(payment.data());
      });
    }

    // ignore: prefer_typing_uninitialized_variables
    var bill;
    var allbills = await billsRef
        .where('userid', isEqualTo: FirebaseServices().getUserId())
        .get();

    for (bill in allbills.docs) {
      setState(() {
        bills.add(bill.data());
      });
    }

    // ignore: prefer_typing_uninitialized_variables
    var invoice;
    var allinvoices = await invoicesRef
        .where('userid', isEqualTo: FirebaseServices().getUserId())
        .get();

    for (invoice in allinvoices.docs) {
      setState(() {
        invoices.add(invoice.data());
      });
    }

    var currentdayname = DateFormat('EEEE').format(DateTime.now());

// IF THAT CURRENT DAY WILL BE MONDAY
    if (currentdayname == 'Monday') {
      var currentMonday =
          '${DateTime.now().day}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var totalPaysMondays =
          pay.where((element) => element['date'] == currentMonday).toList();
      var totalBillsMondays =
          bills.where((element) => element['date'] == currentMonday).toList();

      var totalInvoicesMondays = invoices
          .where((element) => element['date'] == currentMonday)
          .toList();

      var mondayration = 0.00;
      double totalpaysforMonday = 0;
      double totalbillsforMonday = 0;
      double totalinvoicesforMonday = 0;

      for (amount in totalBillsMondays) {
        setState(() {
          totalbillsforMonday = totalbillsforMonday + amount['amount'];
        });
      }

      for (amount in totalInvoicesMondays) {
        setState(() {
          totalinvoicesforMonday = totalinvoicesforMonday + amount['amount'];
        });
      }

      for (amount in totalPaysMondays) {
        setState(() {
          totalpaysforMonday = totalpaysforMonday + amount['amount'];

          mondayration = (totalpaysforMonday * 6 / 10000);
          weeklyspots.add(FlSpot(0, mondayration));
          weeklyspots.add(FlSpot(1, 0));
          weeklyspots.add(FlSpot(2, 0));
          weeklyspots.add(FlSpot(3, 0));
          weeklyspots.add(FlSpot(4, 0));
          weeklyspots.add(FlSpot(5, 0));
          weeklyspots.add(FlSpot(6, 0));
        });
      }

      setState(() {
        totalWeeklypays = totalpaysforMonday;
        totalWeeklybill = totalbillsforMonday;
        totalWeeklyinvoices = totalinvoicesforMonday;
        totalWeeklypayslength = totalPaysMondays.length.toDouble();
        totalWeeklybilllength = totalBillsMondays.length.toDouble();
        totalWeeklyinvoiceslength = totalInvoicesMondays.length.toDouble();
      });
    }

//If That day will be Tuesady
    if (currentdayname == 'Tuesday') {
      var currentTuesday =
          '${DateTime.now().day}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousMonday =
          '${DateTime.now().day - 1}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';

      var totalPaysTuesdays =
          pay.where((element) => element['date'] == currentTuesday).toList();

      var totalBillsTuesday =
          bills.where((element) => element['date'] == currentTuesday).toList();

      var totalInvoicesTuesday = invoices
          .where((element) => element['date'] == currentTuesday)
          .toList();

      var totalPaysMondays =
          pay.where((element) => element['date'] == previousMonday).toList();

      var totalBillsMonday =
          bills.where((element) => element['date'] == previousMonday).toList();
      var totalInvoicesMonday = invoices
          .where((element) => element['date'] == previousMonday)
          .toList();

      double totalPayforTuesday = 0;
      double totalBillsforTuesday = 0;
      double totalInvoicesforTuesday = 0;

      double totalPayforMonday = 0;
      double totalbillsforMonday = 0;
      double totalinvoicesforMonday = 0;

      var tuesdayration = 0.00;
      var mondayration = 0.00;

      for (amount in totalPaysTuesdays) {
        setState(() {
          totalPayforTuesday = totalPayforTuesday + amount['amount'];
          tuesdayration = (totalPayforTuesday * 6 / 10000);
        });
      }

      for (amount in totalBillsTuesday) {
        setState(() {
          totalBillsforTuesday = totalBillsforTuesday + amount['amount'];
        });
      }

      for (amount in totalInvoicesTuesday) {
        setState(() {
          totalInvoicesforTuesday = totalInvoicesforTuesday + amount['amount'];
        });
      }

      for (amount in totalPaysMondays) {
        setState(() {
          totalPayforMonday = totalPayforMonday + amount['amount'];
          mondayration = (totalPayforMonday * 6 / 10000);
        });
      }

      for (amount in totalBillsMonday) {
        setState(() {
          totalbillsforMonday = totalbillsforMonday + amount['amount'];
        });
      }

      for (amount in totalInvoicesMonday) {
        setState(() {
          totalinvoicesforMonday = totalinvoicesforMonday + amount['amount'];
        });
      }

      setState(() {
        totalWeeklypays = totalPayforMonday + totalPayforTuesday;
        totalWeeklybill = totalbillsforMonday + totalBillsforTuesday;
        totalWeeklyinvoices = totalinvoicesforMonday + totalInvoicesforTuesday;
        totalWeeklypayslength = totalPaysMondays.length.toDouble() +
            totalPaysTuesdays.length.toDouble();
        totalWeeklybilllength = totalBillsMonday.length.toDouble() +
            totalBillsTuesday.length.toDouble();
        totalWeeklyinvoiceslength = totalInvoicesMonday.length.toDouble() +
            totalInvoicesTuesday.length.toDouble();
      });

      setState(() {
        weeklyspots.add(FlSpot(0, mondayration));
        weeklyspots.add(FlSpot(1, tuesdayration));
        weeklyspots.add(FlSpot(2, 0));
        weeklyspots.add(FlSpot(3, 0));
        weeklyspots.add(FlSpot(4, 0));
        weeklyspots.add(FlSpot(5, 0));
        weeklyspots.add(FlSpot(6, 0));
      });
    }

// IF THAT DAY WILL WEDNESDAY
    if (currentdayname == 'Wednesday') {
      var currentWednesday =
          '${DateTime.now().day}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousTuesday =
          '${DateTime.now().day - 1}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousMonday =
          '${DateTime.now().day - 2}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';

      var totalPaysWednesday =
          pay.where((element) => element['date'] == currentWednesday).toList();
      var totalBillsWednesday = bills
          .where((element) => element['date'] == currentWednesday)
          .toList();
      var totalInvoicesWednesday = invoices
          .where((element) => element['date'] == currentWednesday)
          .toList();

      var totalPaysTuesdays =
          pay.where((element) => element['date'] == previousTuesday).toList();
      var totalBillsTuesday =
          bills.where((element) => element['date'] == previousTuesday).toList();
      var totalInvoicesTuesday = invoices
          .where((element) => element['date'] == previousTuesday)
          .toList();

      var totalPaysMondays =
          pay.where((element) => element['date'] == previousMonday).toList();
      var totalBillsMonday =
          bills.where((element) => element['date'] == previousMonday).toList();
      var totalInvoicesMonday = invoices
          .where((element) => element['date'] == previousMonday)
          .toList();

      double totalPayforWednesday = 0;
      double totalBillsforWednesday = 0;
      double totalInvoicesforWednesday = 0;

      double totalPayforTuesday = 0;
      double totalBillsforTuesday = 0;
      double totalInvoicesforTuesday = 0;

      double totalPayforMonday = 0;
      double totalbillsforMonday = 0;
      double totalinvoicesforMonday = 0;

      var tuesdayration = 0.00;
      var mondayration = 0.00;
      var wednesdayration = 0.00;

      for (amount in totalPaysWednesday) {
        setState(() {
          totalPayforWednesday = totalPayforWednesday + amount['amount'];
          wednesdayration = (totalPayforWednesday * 6 / 10000);
        });
      }

      for (amount in totalBillsWednesday) {
        setState(() {
          totalBillsforWednesday = totalBillsforWednesday + amount['amount'];
        });
      }

      for (amount in totalInvoicesWednesday) {
        setState(() {
          totalInvoicesforWednesday =
              totalInvoicesforWednesday + amount['amount'];
        });
      }

      for (amount in totalPaysTuesdays) {
        setState(() {
          totalPayforTuesday = totalPayforTuesday + amount['amount'];
          tuesdayration = (totalPayforTuesday * 6 / 10000);
        });
      }

      for (amount in totalBillsTuesday) {
        setState(() {
          totalBillsforTuesday = totalBillsforTuesday + amount['amount'];
        });
      }

      for (amount in totalInvoicesTuesday) {
        setState(() {
          totalInvoicesforTuesday = totalInvoicesforTuesday + amount['amount'];
          totalInvoicesforTuesday = totalInvoicesforTuesday;
        });
      }

      for (amount in totalPaysMondays) {
        setState(() {
          totalPayforMonday = totalPayforMonday + amount['amount'];
          mondayration = (totalPayforMonday * 6 / 10000);
        });
      }

      for (amount in totalBillsMonday) {
        setState(() {
          totalbillsforMonday = totalbillsforMonday + amount['amount'];
        });
      }

      for (amount in totalInvoicesMonday) {
        setState(() {
          totalinvoicesforMonday = totalinvoicesforMonday + amount['amount'];
          totalWeeklyinvoiceslength = totalinvoicesforMonday;
        });
      }

      setState(() {
        totalWeeklypays =
            totalPayforMonday + totalPayforTuesday + totalPayforWednesday;
        totalWeeklybill =
            totalbillsforMonday + totalBillsforTuesday + totalBillsforWednesday;
        totalWeeklyinvoices = totalinvoicesforMonday +
            totalInvoicesforTuesday +
            totalInvoicesforWednesday;

        totalWeeklypayslength = totalPaysMondays.length.toDouble() +
            totalPaysTuesdays.length.toDouble() +
            totalPaysWednesday.length.toDouble();

        totalWeeklybilllength = totalBillsMonday.length.toDouble() +
            totalBillsTuesday.length.toDouble() +
            totalBillsWednesday.length.toDouble();

        totalWeeklyinvoiceslength = totalInvoicesMonday.length.toDouble() +
            totalInvoicesTuesday.length.toDouble() +
            totalInvoicesWednesday.length.toDouble();
      });

      setState(() {
        weeklyspots.add(FlSpot(0, mondayration));
        weeklyspots.add(FlSpot(1, tuesdayration));
        weeklyspots.add(FlSpot(2, wednesdayration));
        weeklyspots.add(FlSpot(3, 0));
        weeklyspots.add(FlSpot(4, 0));
        weeklyspots.add(FlSpot(5, 0));
        weeklyspots.add(FlSpot(6, 0));
      });
    }

//IF THE DAY IS THURSDAY
    if (currentdayname == 'Thursday') {
      var currentThursday =
          '${DateTime.now().day}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousWednesday =
          '${DateTime.now().day - 1}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousTuesday =
          '${DateTime.now().day - 2}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousMonday =
          '${DateTime.now().day - 3}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';

      var totalPaysThursday =
          pay.where((element) => element['date'] == currentThursday).toList();
      var totalBillsThursday =
          bills.where((element) => element['date'] == currentThursday).toList();
      var totalInvoicesThursday = invoices
          .where((element) => element['date'] == currentThursday)
          .toList();

      var totalPaysWednesday =
          pay.where((element) => element['date'] == previousWednesday).toList();
      var totalBillsWednesday = bills
          .where((element) => element['date'] == previousWednesday)
          .toList();
      var totalInvoicesWednesday = invoices
          .where((element) => element['date'] == previousWednesday)
          .toList();

      var totalPaysTuesdays =
          pay.where((element) => element['date'] == previousTuesday).toList();
      var totalBillsTuesday =
          bills.where((element) => element['date'] == previousTuesday).toList();
      var totalInvoicesTuesday = invoices
          .where((element) => element['date'] == previousTuesday)
          .toList();

      var totalPaysMondays =
          pay.where((element) => element['date'] == previousMonday).toList();
      var totalBillsMonday =
          bills.where((element) => element['date'] == previousMonday).toList();
      var totalInvoicesMonday = invoices
          .where((element) => element['date'] == previousMonday)
          .toList();

      double totalPayforThursaday = 0;
      double totalBillsforThursaday = 0;
      double totalInvoicesforThursaday = 0;

      double totalPayforWednesday = 0;
      double totalBillsforWednesday = 0;
      double totalInvoicesforWednesday = 0;

      double totalPayforTuesday = 0;
      double totalBillsforTuesday = 0;
      double totalInvoicesforTuesday = 0;

      double totalPayforMonday = 0;
      double totalbillsforMonday = 0;
      double totalinvoicesforMonday = 0;

      var tuesdayration = 0.00;
      var mondayration = 0.00;
      var wednesdayration = 0.00;
      var thursdayration = 0.00;

      for (amount in totalPaysThursday) {
        setState(() {
          totalPayforThursaday = totalPayforThursaday + amount['amount'];
          thursdayration = (totalPayforThursaday * 6 / 10000);
        });
      }

      for (amount in totalBillsThursday) {
        setState(() {
          totalBillsforThursaday = totalBillsforThursaday + amount['amount'];
        });
      }

      for (amount in totalInvoicesThursday) {
        setState(() {
          totalInvoicesforThursaday =
              totalInvoicesforThursaday + amount['amount'];
        });
      }

      for (amount in totalPaysWednesday) {
        setState(() {
          totalPayforWednesday = totalPayforWednesday + amount['amount'];
          wednesdayration = (totalPayforWednesday * 6 / 10000);
        });
      }

      for (amount in totalBillsWednesday) {
        setState(() {
          totalBillsforWednesday = totalBillsforWednesday + amount['amount'];
        });
      }

      for (amount in totalInvoicesWednesday) {
        setState(() {
          totalInvoicesforWednesday =
              totalInvoicesforWednesday + amount['amount'];
          totalInvoicesforWednesday = totalInvoicesforWednesday;
        });
      }

      for (amount in totalPaysTuesdays) {
        setState(() {
          totalPayforTuesday = totalPayforTuesday + amount['amount'];
          tuesdayration = (totalPayforTuesday * 6 / 10000);
        });
      }

      for (amount in totalBillsTuesday) {
        setState(() {
          totalBillsforTuesday = totalBillsforTuesday + amount['amount'];
        });
      }

      for (amount in totalInvoicesTuesday) {
        setState(() {
          totalInvoicesforTuesday = totalInvoicesforTuesday + amount['amount'];
          totalInvoicesforTuesday = totalInvoicesforTuesday;
        });
      }

      for (amount in totalPaysMondays) {
        setState(() {
          totalPayforMonday = totalPayforMonday + amount['amount'];
          mondayration = (totalPayforMonday * 6 / 10000);
        });
      }

      for (amount in totalBillsMonday) {
        setState(() {
          totalbillsforMonday = totalbillsforMonday + amount['amount'];
        });
      }

      for (amount in totalInvoicesMonday) {
        setState(() {
          totalinvoicesforMonday = totalinvoicesforMonday + amount['amount'];
          totalWeeklyinvoiceslength = totalinvoicesforMonday;
        });
      }

      setState(() {
        totalWeeklypays = totalPayforMonday +
            totalPayforTuesday +
            totalPayforWednesday +
            totalPayforThursaday;
        totalWeeklybill = totalbillsforMonday +
            totalBillsforTuesday +
            totalBillsforWednesday +
            totalBillsforThursaday;
        totalWeeklyinvoices = totalinvoicesforMonday +
            totalInvoicesforTuesday +
            totalInvoicesforWednesday +
            totalInvoicesforThursaday;

        totalWeeklypayslength = totalPaysMondays.length.toDouble() +
            totalPaysTuesdays.length.toDouble() +
            totalPaysWednesday.length.toDouble() +
            totalPaysThursday.length.toDouble();

        totalWeeklybilllength = totalBillsMonday.length.toDouble() +
            totalBillsTuesday.length.toDouble() +
            totalBillsWednesday.length.toDouble() +
            totalBillsThursday.length.toDouble();

        totalWeeklyinvoiceslength = totalInvoicesMonday.length.toDouble() +
            totalInvoicesTuesday.length.toDouble() +
            totalInvoicesWednesday.length.toDouble() +
            totalInvoicesThursday.length.toDouble();
      });

      setState(() {
        weeklyspots.add(FlSpot(0, mondayration));
        weeklyspots.add(FlSpot(1, tuesdayration));
        weeklyspots.add(FlSpot(2, wednesdayration));
        weeklyspots.add(FlSpot(3, thursdayration));
        weeklyspots.add(FlSpot(4, 0));
        weeklyspots.add(FlSpot(5, 0));
        weeklyspots.add(FlSpot(6, 0));
      });
    }

    if (currentdayname == 'Friday') {
      var currentFriday =
          '${DateTime.now().day}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousThursday =
          '${DateTime.now().day - 1}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousWednesday =
          '${DateTime.now().day - 2}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousTuesday =
          '${DateTime.now().day - 3}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousMonday =
          '${DateTime.now().day - 4}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';

      var totalPaysFriday =
          pay.where((element) => element['date'] == currentFriday).toList();
      var totalBillsFriday =
          bills.where((element) => element['date'] == currentFriday).toList();
      var totalInvoicesFriday = invoices
          .where((element) => element['date'] == currentFriday)
          .toList();

      var totalPaysThursday =
          pay.where((element) => element['date'] == previousThursday).toList();
      var totalBillsThursday = bills
          .where((element) => element['date'] == previousThursday)
          .toList();
      var totalInvoicesThursday = invoices
          .where((element) => element['date'] == previousThursday)
          .toList();

      var totalPaysWednesday =
          pay.where((element) => element['date'] == previousWednesday).toList();
      var totalBillsWednesday = bills
          .where((element) => element['date'] == previousWednesday)
          .toList();
      var totalInvoicesWednesday = invoices
          .where((element) => element['date'] == previousWednesday)
          .toList();

      var totalPaysTuesdays =
          pay.where((element) => element['date'] == previousTuesday).toList();
      var totalBillsTuesday =
          bills.where((element) => element['date'] == previousTuesday).toList();
      var totalInvoicesTuesday = invoices
          .where((element) => element['date'] == previousTuesday)
          .toList();

      var totalPaysMondays =
          pay.where((element) => element['date'] == previousMonday).toList();
      var totalBillsMonday =
          bills.where((element) => element['date'] == previousMonday).toList();
      var totalInvoicesMonday = invoices
          .where((element) => element['date'] == previousMonday)
          .toList();

      double totalPayforFriday = 0;
      double totalBillsforFriday = 0;
      double totalInvoicesforFriday = 0;

      double totalPayforThursaday = 0;
      double totalBillsforThursaday = 0;
      double totalInvoicesforThursaday = 0;

      double totalPayforWednesday = 0;
      double totalBillsforWednesday = 0;
      double totalInvoicesforWednesday = 0;

      double totalPayforTuesday = 0;
      double totalBillsforTuesday = 0;
      double totalInvoicesforTuesday = 0;

      double totalPayforMonday = 0;
      double totalbillsforMonday = 0;
      double totalinvoicesforMonday = 0;

      var tuesdayration = 0.00;
      var mondayration = 0.00;
      var wednesdayration = 0.00;
      var thursdayration = 0.00;
      var fridayration = 0.00;

      for (amount in totalPaysFriday) {
        setState(() {
          totalPayforFriday = totalPayforFriday + amount['amount'];
          fridayration = (totalPayforFriday * 6 / 10000);
        });
      }

      for (amount in totalBillsFriday) {
        setState(() {
          totalBillsforFriday = totalBillsforFriday + amount['amount'];
        });
      }

      for (amount in totalInvoicesFriday) {
        setState(() {
          totalInvoicesforFriday = totalInvoicesforFriday + amount['amount'];
        });
      }

      for (amount in totalPaysThursday) {
        setState(() {
          totalPayforThursaday = totalPayforThursaday + amount['amount'];
          thursdayration = (totalPayforThursaday * 6 / 10000);
        });
      }

      for (amount in totalBillsThursday) {
        setState(() {
          totalBillsforThursaday = totalBillsforThursaday + amount['amount'];
        });
      }

      for (amount in totalInvoicesThursday) {
        setState(() {
          totalInvoicesforThursaday =
              totalInvoicesforThursaday + amount['amount'];
        });
      }

      for (amount in totalPaysWednesday) {
        setState(() {
          totalPayforWednesday = totalPayforWednesday + amount['amount'];
          wednesdayration = (totalPayforWednesday * 6 / 10000);
        });
      }

      for (amount in totalBillsWednesday) {
        setState(() {
          totalBillsforWednesday = totalBillsforWednesday + amount['amount'];
        });
      }

      for (amount in totalInvoicesWednesday) {
        setState(() {
          totalInvoicesforWednesday =
              totalInvoicesforWednesday + amount['amount'];
          totalInvoicesforWednesday = totalInvoicesforWednesday;
        });
      }

      for (amount in totalPaysTuesdays) {
        setState(() {
          totalPayforTuesday = totalPayforTuesday + amount['amount'];
          tuesdayration = (totalPayforTuesday * 6 / 10000);
        });
      }

      for (amount in totalBillsTuesday) {
        setState(() {
          totalBillsforTuesday = totalBillsforTuesday + amount['amount'];
        });
      }

      for (amount in totalInvoicesTuesday) {
        setState(() {
          totalInvoicesforTuesday = totalInvoicesforTuesday + amount['amount'];
          totalInvoicesforTuesday = totalInvoicesforTuesday;
        });
      }

      for (amount in totalPaysMondays) {
        setState(() {
          totalPayforMonday = totalPayforMonday + amount['amount'];
          mondayration = (totalPayforMonday * 6 / 10000);
        });
      }

      for (amount in totalBillsMonday) {
        setState(() {
          totalbillsforMonday = totalbillsforMonday + amount['amount'];
        });
      }

      for (amount in totalInvoicesMonday) {
        setState(() {
          totalinvoicesforMonday = totalinvoicesforMonday + amount['amount'];
          totalWeeklyinvoiceslength = totalinvoicesforMonday;
        });
      }

      setState(() {
        totalWeeklypays = totalPayforMonday +
            totalPayforTuesday +
            totalPayforWednesday +
            totalPayforThursaday +
            totalPayforFriday;
        totalWeeklybill = totalbillsforMonday +
            totalBillsforTuesday +
            totalBillsforWednesday +
            totalBillsforThursaday +
            totalBillsforFriday;
        totalWeeklyinvoices = totalinvoicesforMonday +
            totalInvoicesforTuesday +
            totalInvoicesforWednesday +
            totalInvoicesforThursaday +
            totalInvoicesforFriday;

        totalWeeklypayslength = totalPaysMondays.length.toDouble() +
            totalPaysTuesdays.length.toDouble() +
            totalPaysWednesday.length.toDouble() +
            totalPaysThursday.length.toDouble() +
            totalPaysFriday.length.toDouble();

        totalWeeklybilllength = totalBillsMonday.length.toDouble() +
            totalBillsTuesday.length.toDouble() +
            totalBillsWednesday.length.toDouble() +
            totalBillsThursday.length.toDouble() +
            totalBillsFriday.length.toDouble();

        totalWeeklyinvoiceslength = totalInvoicesMonday.length.toDouble() +
            totalInvoicesTuesday.length.toDouble() +
            totalInvoicesWednesday.length.toDouble() +
            totalInvoicesThursday.length.toDouble() +
            totalInvoicesFriday.length.toDouble();
      });

      setState(() {
        weeklyspots.add(FlSpot(0, mondayration));
        weeklyspots.add(FlSpot(1, tuesdayration));
        weeklyspots.add(FlSpot(2, wednesdayration));
        weeklyspots.add(FlSpot(3, thursdayration));
        weeklyspots.add(FlSpot(4, fridayration));
        weeklyspots.add(FlSpot(5, 0));
        weeklyspots.add(FlSpot(6, 0));
      });
    }

// IF CURRENT DAY IS SATURDAY

    if (currentdayname == 'Saturday') {
      var currentSaturday =
          '${DateTime.now().day}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousFriday =
          '${DateTime.now().day - 1}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousThursday =
          '${DateTime.now().day - 2}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousWednesday =
          '${DateTime.now().day - 3}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousTuesday =
          '${DateTime.now().day - 4}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousMonday =
          '${DateTime.now().day - 5}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';

      var totalPaysSaturday =
          pay.where((element) => element['date'] == currentSaturday).toList();
      var totalBillsSaturday =
          bills.where((element) => element['date'] == currentSaturday).toList();
      var totalInvoicesSaturday = invoices
          .where((element) => element['date'] == currentSaturday)
          .toList();

      var totalPaysFriday =
          pay.where((element) => element['date'] == previousFriday).toList();
      var totalBillsFriday =
          bills.where((element) => element['date'] == previousFriday).toList();
      var totalInvoicesFriday = invoices
          .where((element) => element['date'] == previousFriday)
          .toList();

      var totalPaysThursday =
          pay.where((element) => element['date'] == previousThursday).toList();
      var totalBillsThursday = bills
          .where((element) => element['date'] == previousThursday)
          .toList();
      var totalInvoicesThursday = invoices
          .where((element) => element['date'] == previousThursday)
          .toList();

      var totalPaysWednesday =
          pay.where((element) => element['date'] == previousWednesday).toList();
      var totalBillsWednesday = bills
          .where((element) => element['date'] == previousWednesday)
          .toList();
      var totalInvoicesWednesday = invoices
          .where((element) => element['date'] == previousWednesday)
          .toList();

      var totalPaysTuesdays =
          pay.where((element) => element['date'] == previousTuesday).toList();
      var totalBillsTuesday =
          bills.where((element) => element['date'] == previousTuesday).toList();
      var totalInvoicesTuesday = invoices
          .where((element) => element['date'] == previousTuesday)
          .toList();

      var totalPaysMondays =
          pay.where((element) => element['date'] == previousMonday).toList();
      var totalBillsMonday =
          bills.where((element) => element['date'] == previousMonday).toList();
      var totalInvoicesMonday = invoices
          .where((element) => element['date'] == previousMonday)
          .toList();

      double totalPayforSaturday = 0;
      double totalBillsforSaturday = 0;
      double totalInvoicesforSaturday = 0;

      double totalPayforFriday = 0;
      double totalBillsforFriday = 0;
      double totalInvoicesforFriday = 0;

      double totalPayforThursaday = 0;
      double totalBillsforThursaday = 0;
      double totalInvoicesforThursaday = 0;

      double totalPayforWednesday = 0;
      double totalBillsforWednesday = 0;
      double totalInvoicesforWednesday = 0;

      double totalPayforTuesday = 0;
      double totalBillsforTuesday = 0;
      double totalInvoicesforTuesday = 0;

      double totalPayforMonday = 0;
      double totalbillsforMonday = 0;
      double totalinvoicesforMonday = 0;

      var tuesdayration = 0.00;
      var mondayration = 0.00;
      var wednesdayration = 0.00;
      var thursdayration = 0.00;
      var fridayration = 0.00;
      var saturdayration = 0.00;

      for (amount in totalPaysSaturday) {
        setState(() {
          totalPayforSaturday = totalPayforSaturday + amount['amount'];
          saturdayration = (totalPayforFriday * 6 / 10000);
        });
      }

      for (amount in totalBillsSaturday) {
        setState(() {
          totalBillsforSaturday = totalBillsforSaturday + amount['amount'];
        });
      }

      for (amount in totalInvoicesSaturday) {
        setState(() {
          totalInvoicesforSaturday =
              totalInvoicesforSaturday + amount['amount'];
        });
      }

      for (amount in totalPaysFriday) {
        setState(() {
          totalPayforFriday = totalPayforFriday + amount['amount'];
          fridayration = (totalPayforFriday * 6 / 10000);
        });
      }

      for (amount in totalBillsFriday) {
        setState(() {
          totalBillsforFriday = totalBillsforFriday + amount['amount'];
        });
      }

      for (amount in totalInvoicesFriday) {
        setState(() {
          totalInvoicesforFriday = totalInvoicesforFriday + amount['amount'];
        });
      }

      for (amount in totalPaysThursday) {
        setState(() {
          totalPayforThursaday = totalPayforThursaday + amount['amount'];
          thursdayration = (totalPayforThursaday * 6 / 10000);
        });
      }

      for (amount in totalBillsThursday) {
        setState(() {
          totalBillsforThursaday = totalBillsforThursaday + amount['amount'];
        });
      }

      for (amount in totalInvoicesThursday) {
        setState(() {
          totalInvoicesforThursaday =
              totalInvoicesforThursaday + amount['amount'];
        });
      }

      for (amount in totalPaysWednesday) {
        setState(() {
          totalPayforWednesday = totalPayforWednesday + amount['amount'];
          wednesdayration = (totalPayforWednesday * 6 / 10000);
        });
      }

      for (amount in totalBillsWednesday) {
        setState(() {
          totalBillsforWednesday = totalBillsforWednesday + amount['amount'];
        });
      }

      for (amount in totalInvoicesWednesday) {
        setState(() {
          totalInvoicesforWednesday =
              totalInvoicesforWednesday + amount['amount'];
          totalInvoicesforWednesday = totalInvoicesforWednesday;
        });
      }

      for (amount in totalPaysTuesdays) {
        setState(() {
          totalPayforTuesday = totalPayforTuesday + amount['amount'];
          tuesdayration = (totalPayforTuesday * 6 / 10000);
        });
      }

      for (amount in totalBillsTuesday) {
        setState(() {
          totalBillsforTuesday = totalBillsforTuesday + amount['amount'];
        });
      }

      for (amount in totalInvoicesTuesday) {
        setState(() {
          totalInvoicesforTuesday = totalInvoicesforTuesday + amount['amount'];
          totalInvoicesforTuesday = totalInvoicesforTuesday;
        });
      }

      for (amount in totalPaysMondays) {
        setState(() {
          totalPayforMonday = totalPayforMonday + amount['amount'];
          mondayration = (totalPayforMonday * 6 / 10000);
        });
      }

      for (amount in totalBillsMonday) {
        setState(() {
          totalbillsforMonday = totalbillsforMonday + amount['amount'];
        });
      }

      for (amount in totalInvoicesMonday) {
        setState(() {
          totalinvoicesforMonday = totalinvoicesforMonday + amount['amount'];
          totalWeeklyinvoiceslength = totalinvoicesforMonday;
        });
      }

      setState(() {
        totalWeeklypays = totalPayforMonday +
            totalPayforTuesday +
            totalPayforWednesday +
            totalPayforThursaday +
            totalPayforFriday +
            totalPayforSaturday;
        totalWeeklybill = totalbillsforMonday +
            totalBillsforTuesday +
            totalBillsforWednesday +
            totalBillsforThursaday +
            totalBillsforFriday +
            totalBillsforSaturday;
        totalWeeklyinvoices = totalinvoicesforMonday +
            totalInvoicesforTuesday +
            totalInvoicesforWednesday +
            totalInvoicesforThursaday +
            totalInvoicesforFriday +
            totalInvoicesforSaturday;

        totalWeeklypayslength = totalPaysMondays.length.toDouble() +
            totalPaysTuesdays.length.toDouble() +
            totalPaysWednesday.length.toDouble() +
            totalPaysThursday.length.toDouble() +
            totalPaysFriday.length.toDouble() +
            totalPaysSaturday.length.toDouble();

        totalWeeklybilllength = totalBillsMonday.length.toDouble() +
            totalBillsTuesday.length.toDouble() +
            totalBillsWednesday.length.toDouble() +
            totalBillsThursday.length.toDouble() +
            totalBillsFriday.length.toDouble() +
            totalBillsSaturday.length.toDouble();

        totalWeeklyinvoiceslength = totalInvoicesMonday.length.toDouble() +
            totalInvoicesTuesday.length.toDouble() +
            totalInvoicesWednesday.length.toDouble() +
            totalInvoicesThursday.length.toDouble() +
            totalInvoicesFriday.length.toDouble() +
            totalInvoicesSaturday.length.toDouble();
      });
      setState(() {
        weeklyspots.add(FlSpot(0, mondayration));
        weeklyspots.add(FlSpot(1, tuesdayration));
        weeklyspots.add(FlSpot(2, wednesdayration));
        weeklyspots.add(FlSpot(3, thursdayration));
        weeklyspots.add(FlSpot(4, fridayration));
        weeklyspots.add(FlSpot(5, saturdayration));
        weeklyspots.add(FlSpot(6, 0));
      });
    }

//IF CURRENT DAY IS SUNDAY
    if (currentdayname == 'Sunday') {
      var currentSunday =
          '${DateTime.now().day}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousSaturday =
          '${DateTime.now().day - 1}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousFriday =
          '${DateTime.now().day - 2}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousThursday =
          '${DateTime.now().day - 3}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousWednesday =
          '${DateTime.now().day - 4}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousTuesday =
          '${DateTime.now().day - 5}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';
      var previousMonday =
          '${DateTime.now().day - 6}/${DateTime.parse(DateTime.now().toString()).toLocal().month.toString()}/${DateTime.parse(DateTime.now().toString()).toLocal().year.toString()}';

      var totalPaysSunday =
          pay.where((element) => element['date'] == currentSunday).toList();
      var totalBillsSunday =
          bills.where((element) => element['date'] == currentSunday).toList();
      var totalInvoicesSunday = invoices
          .where((element) => element['date'] == currentSunday)
          .toList();

      var totalPaysSaturday =
          pay.where((element) => element['date'] == previousSaturday).toList();
      var totalBillsSaturday = bills
          .where((element) => element['date'] == previousSaturday)
          .toList();
      var totalInvoicesSaturday = invoices
          .where((element) => element['date'] == previousSaturday)
          .toList();

      var totalPaysFriday =
          pay.where((element) => element['date'] == previousFriday).toList();
      var totalBillsFriday =
          bills.where((element) => element['date'] == previousFriday).toList();
      var totalInvoicesFriday = invoices
          .where((element) => element['date'] == previousFriday)
          .toList();

      var totalPaysThursday =
          pay.where((element) => element['date'] == previousThursday).toList();
      var totalBillsThursday = bills
          .where((element) => element['date'] == previousThursday)
          .toList();
      var totalInvoicesThursday = invoices
          .where((element) => element['date'] == previousThursday)
          .toList();

      var totalPaysWednesday =
          pay.where((element) => element['date'] == previousWednesday).toList();
      var totalBillsWednesday = bills
          .where((element) => element['date'] == previousWednesday)
          .toList();
      var totalInvoicesWednesday = invoices
          .where((element) => element['date'] == previousWednesday)
          .toList();

      var totalPaysTuesdays =
          pay.where((element) => element['date'] == previousTuesday).toList();
      var totalBillsTuesday =
          bills.where((element) => element['date'] == previousTuesday).toList();
      var totalInvoicesTuesday = invoices
          .where((element) => element['date'] == previousTuesday)
          .toList();

      var totalPaysMondays =
          pay.where((element) => element['date'] == previousMonday).toList();
      var totalBillsMonday =
          bills.where((element) => element['date'] == previousMonday).toList();
      var totalInvoicesMonday = invoices
          .where((element) => element['date'] == previousMonday)
          .toList();

      double totalPayforSunday = 0;
      double totalBillsforSunday = 0;
      double totalInvoicesforSunday = 0;

      double totalPayforSaturday = 0;
      double totalBillsforSaturday = 0;
      double totalInvoicesforSaturday = 0;

      double totalPayforFriday = 0;
      double totalBillsforFriday = 0;
      double totalInvoicesforFriday = 0;

      double totalPayforThursaday = 0;
      double totalBillsforThursaday = 0;
      double totalInvoicesforThursaday = 0;

      double totalPayforWednesday = 0;
      double totalBillsforWednesday = 0;
      double totalInvoicesforWednesday = 0;

      double totalPayforTuesday = 0;
      double totalBillsforTuesday = 0;
      double totalInvoicesforTuesday = 0;

      double totalPayforMonday = 0;
      double totalbillsforMonday = 0;
      double totalinvoicesforMonday = 0;

      var tuesdayration = 0.00;
      var mondayration = 0.00;
      var wednesdayration = 0.00;
      var thursdayration = 0.00;
      var fridayration = 0.00;
      var saturdayration = 0.00;
      var sundayration = 0.00;

      for (amount in totalPaysSunday) {
        setState(() {
          totalPayforSunday = totalPayforSunday + amount['amount'];
          sundayration = (totalPayforFriday * 6 / 10000);
        });
      }

      for (amount in totalBillsSunday) {
        setState(() {
          totalBillsforSunday = totalBillsforSunday + amount['amount'];
        });
      }

      for (amount in totalInvoicesSunday) {
        setState(() {
          totalInvoicesforSunday = totalInvoicesforSunday + amount['amount'];
        });
      }

      for (amount in totalPaysSaturday) {
        setState(() {
          totalPayforSaturday = totalPayforSaturday + amount['amount'];
          saturdayration = (totalPayforFriday * 6 / 10000);
        });
      }

      for (amount in totalBillsSaturday) {
        setState(() {
          totalBillsforSaturday = totalBillsforSaturday + amount['amount'];
        });
      }

      for (amount in totalInvoicesSaturday) {
        setState(() {
          totalInvoicesforSaturday =
              totalInvoicesforSaturday + amount['amount'];
        });
      }

      for (amount in totalPaysFriday) {
        setState(() {
          totalPayforFriday = totalPayforFriday + amount['amount'];
          fridayration = (totalPayforFriday * 6 / 10000);
        });
      }

      for (amount in totalBillsFriday) {
        setState(() {
          totalBillsforFriday = totalBillsforFriday + amount['amount'];
        });
      }

      for (amount in totalInvoicesFriday) {
        setState(() {
          totalInvoicesforFriday = totalInvoicesforFriday + amount['amount'];
        });
      }

      for (amount in totalPaysThursday) {
        setState(() {
          totalPayforThursaday = totalPayforThursaday + amount['amount'];
          thursdayration = (totalPayforThursaday * 6 / 10000);
        });
      }

      for (amount in totalBillsThursday) {
        setState(() {
          totalBillsforThursaday = totalBillsforThursaday + amount['amount'];
        });
      }

      for (amount in totalInvoicesThursday) {
        setState(() {
          totalInvoicesforThursaday =
              totalInvoicesforThursaday + amount['amount'];
        });
      }

      for (amount in totalPaysWednesday) {
        setState(() {
          totalPayforWednesday = totalPayforWednesday + amount['amount'];
          wednesdayration = (totalPayforWednesday * 6 / 10000);
        });
      }

      for (amount in totalBillsWednesday) {
        setState(() {
          totalBillsforWednesday = totalBillsforWednesday + amount['amount'];
        });
      }

      for (amount in totalInvoicesWednesday) {
        setState(() {
          totalInvoicesforWednesday =
              totalInvoicesforWednesday + amount['amount'];
          totalInvoicesforWednesday = totalInvoicesforWednesday;
        });
      }

      for (amount in totalPaysTuesdays) {
        setState(() {
          totalPayforTuesday = totalPayforTuesday + amount['amount'];
          tuesdayration = (totalPayforTuesday * 6 / 10000);
        });
      }

      for (amount in totalBillsTuesday) {
        setState(() {
          totalBillsforTuesday = totalBillsforTuesday + amount['amount'];
        });
      }

      for (amount in totalInvoicesTuesday) {
        setState(() {
          totalInvoicesforTuesday = totalInvoicesforTuesday + amount['amount'];
          totalInvoicesforTuesday = totalInvoicesforTuesday;
        });
      }

      for (amount in totalPaysMondays) {
        setState(() {
          totalPayforMonday = totalPayforMonday + amount['amount'];
          mondayration = (totalPayforMonday * 6 / 10000);
        });
      }

      for (amount in totalBillsMonday) {
        setState(() {
          totalbillsforMonday = totalbillsforMonday + amount['amount'];
        });
      }

      for (amount in totalInvoicesMonday) {
        setState(() {
          totalinvoicesforMonday = totalinvoicesforMonday + amount['amount'];
          totalWeeklyinvoiceslength = totalinvoicesforMonday;
        });
      }

      setState(() {
        totalWeeklypays = totalPayforMonday +
            totalPayforTuesday +
            totalPayforWednesday +
            totalPayforThursaday +
            totalPayforFriday +
            totalPayforSaturday +
            totalPayforSunday;
        totalWeeklybill = totalbillsforMonday +
            totalBillsforTuesday +
            totalBillsforWednesday +
            totalBillsforThursaday +
            totalBillsforFriday +
            totalBillsforSaturday +
            totalBillsforSunday;
        totalWeeklyinvoices = totalinvoicesforMonday +
            totalInvoicesforTuesday +
            totalInvoicesforWednesday +
            totalInvoicesforThursaday +
            totalInvoicesforFriday +
            totalInvoicesforSaturday +
            totalInvoicesforSunday;

        totalWeeklypayslength = totalPaysMondays.length.toDouble() +
            totalPaysTuesdays.length.toDouble() +
            totalPaysWednesday.length.toDouble() +
            totalPaysThursday.length.toDouble() +
            totalPaysFriday.length.toDouble() +
            totalPaysSaturday.length.toDouble() +
            totalPaysSunday.length.toDouble();

        totalWeeklybilllength = totalBillsMonday.length.toDouble() +
            totalBillsTuesday.length.toDouble() +
            totalBillsWednesday.length.toDouble() +
            totalBillsThursday.length.toDouble() +
            totalBillsFriday.length.toDouble() +
            totalBillsSaturday.length.toDouble() +
            totalBillsSunday.length.toDouble();

        totalWeeklyinvoiceslength = totalInvoicesMonday.length.toDouble() +
            totalInvoicesTuesday.length.toDouble() +
            totalInvoicesWednesday.length.toDouble() +
            totalInvoicesThursday.length.toDouble() +
            totalInvoicesFriday.length.toDouble() +
            totalInvoicesSaturday.length.toDouble() +
            totalInvoicesSunday.length.toDouble();
      });

      setState(() {
        weeklyspots.add(FlSpot(0, mondayration));
        weeklyspots.add(FlSpot(1, tuesdayration));
        weeklyspots.add(FlSpot(2, wednesdayration));
        weeklyspots.add(FlSpot(3, thursdayration));
        weeklyspots.add(FlSpot(4, fridayration));
        weeklyspots.add(FlSpot(5, saturdayration));
        weeklyspots.add(FlSpot(6, sundayration));
      });
    }

// CHANGE ACCORDING TO MONTH
    var currentmonth = DateTime.now().month;
    var currentYear = DateTime.now().year;

    if (currentmonth == 1) {
      var totalforJan = 0.00;
      var januaryration = 0.00;

      List<Map<dynamic, dynamic>>? thismonthpays = [];
      List<Map<dynamic, dynamic>>? thismonthbills = [];
      List<Map<dynamic, dynamic>>? thismonthinvoices = [];

      // ignore: prefer_typing_uninitialized_variables
      var ppay;
      // ignore: prefer_typing_uninitialized_variables
      var bill;
      // ignore: prefer_typing_uninitialized_variables
      var invoice;

      var filteredPays = await paysRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'January')
          .get();

      for (ppay in filteredPays.docs) {
        setState(() {
          thismonthpays.add(ppay.data());
        });
      }

      var filteredBills = await billsRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'January')
          .get();

      for (bill in filteredBills.docs) {
        setState(() {
          thismonthbills.add(bill.data());
        });
      }

      var filteredInvoices = await invoicesRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'January')
          .get();

      for (invoice in filteredInvoices.docs) {
        setState(() {
          thismonthinvoices.add(invoice.data());
        });
      }

      for (amount in thismonthpays) {
        setState(() {
          totalMonthlypays = totalMonthlypays + amount['amount'];
        });
      }

      for (amount in thismonthbills) {
        setState(() {
          totalMonthlybill = totalMonthlybill + amount['amount'];
        });
      }

      for (amount in thismonthinvoices) {
        setState(() {
          totalMonthlyinvoices = totalMonthlyinvoices + amount['amount'];
        });
      }

      setState(() {
        totalMonthlypayslength = thismonthpays.length.toDouble();
        totalMonthlybilllength = thismonthbills.length.toDouble();
        totalMonthlyinvoiceslength = thismonthinvoices.length.toDouble();
      });

      var totalJan = pay.where((element) =>
          element['month'] == 'January' &&
          element['year'] == currentYear.toString());

      for (amount in totalJan) {
        setState(() {
          totalforJan = totalforJan + amount['amount'];
          januaryration = (totalforJan * 6 / 10000);
        });
      }

      setState(() {
        monthlyspots.add(FlSpot(0, januaryration));
        monthlyspots.add(FlSpot(1, 0));
        monthlyspots.add(FlSpot(2, 0));
        monthlyspots.add(FlSpot(3, 0));
        monthlyspots.add(FlSpot(4, 0));
        monthlyspots.add(FlSpot(5, 0));
        monthlyspots.add(FlSpot(6, 0));
        monthlyspots.add(FlSpot(7, 0));
        monthlyspots.add(FlSpot(8, 0));
        monthlyspots.add(FlSpot(9, 0));
        monthlyspots.add(FlSpot(10, 0));
        monthlyspots.add(FlSpot(11, 0));
      });
    }

    if (currentmonth == 2) {
      var totalforJan = 0.00;
      var totalforFeb = 0.00;
      var januaryration = 0.00;
      var februaryration = 0.00;
      List<Map<dynamic, dynamic>>? thismonthpays = [];
      List<Map<dynamic, dynamic>>? thismonthbills = [];
      List<Map<dynamic, dynamic>>? thismonthinvoices = [];

      // ignore: prefer_typing_uninitialized_variables
      var ppay;
      // ignore: prefer_typing_uninitialized_variables
      var bill;
      // ignore: prefer_typing_uninitialized_variables
      var invoice;

      var filteredPays = await paysRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'February')
          .get();

      for (ppay in filteredPays.docs) {
        setState(() {
          thismonthpays.add(ppay.data());
        });
      }

      var filteredBills = await billsRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'February')
          .get();

      for (bill in filteredBills.docs) {
        setState(() {
          thismonthbills.add(bill.data());
        });
      }

      var filteredInvoices = await invoicesRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'February')
          .get();

      for (invoice in filteredInvoices.docs) {
        setState(() {
          thismonthinvoices.add(invoice.data());
        });
      }

      for (amount in thismonthpays) {
        setState(() {
          totalMonthlypays = totalMonthlypays + amount['amount'];
        });
      }

      for (amount in thismonthbills) {
        setState(() {
          totalMonthlybill = totalMonthlybill + amount['amount'];
        });
      }

      for (amount in thismonthinvoices) {
        setState(() {
          totalMonthlyinvoices = totalMonthlyinvoices + amount['amount'];
        });
      }

      setState(() {
        totalMonthlypayslength = thismonthpays.length.toDouble();
        totalMonthlybilllength = thismonthbills.length.toDouble();
        totalMonthlyinvoiceslength = thismonthinvoices.length.toDouble();
      });
      var totalJan = pay.where((element) =>
          element['month'] == 'January' &&
          element['year'] == currentYear.toString());

      var totalFeb = pay.where((element) =>
          element['month'] == 'February' &&
          element['year'] == currentYear.toString());

      for (amount in totalJan) {
        setState(() {
          totalforJan = totalforJan + amount['amount'];
          januaryration = (totalforJan * 6 / 10000);
        });
      }

      for (amount in totalFeb) {
        setState(() {
          totalforFeb = totalforFeb + amount['amount'];
          februaryration = (totalforFeb * 6 / 10000);
        });
      }

      setState(() {
        monthlyspots.add(FlSpot(0, januaryration));
        monthlyspots.add(FlSpot(1, februaryration));
        monthlyspots.add(FlSpot(2, 0));
        monthlyspots.add(FlSpot(3, 0));
        monthlyspots.add(FlSpot(4, 0));
        monthlyspots.add(FlSpot(5, 0));
        monthlyspots.add(FlSpot(6, 0));
        monthlyspots.add(FlSpot(7, 0));
        monthlyspots.add(FlSpot(8, 0));
        monthlyspots.add(FlSpot(9, 0));
        monthlyspots.add(FlSpot(10, 0));
        monthlyspots.add(FlSpot(11, 0));
      });
    }

    if (currentmonth == 3) {
      var totalforJan = 0.00;
      var totalforFeb = 0.00;
      var totalforMarch = 0.00;
      var januaryration = 0.00;
      var februaryration = 0.00;
      var marchration = 0.00;
      List<Map<dynamic, dynamic>>? thismonthpays = [];
      List<Map<dynamic, dynamic>>? thismonthbills = [];
      List<Map<dynamic, dynamic>>? thismonthinvoices = [];

      // ignore: prefer_typing_uninitialized_variables
      var ppay;
      // ignore: prefer_typing_uninitialized_variables
      var bill;
      // ignore: prefer_typing_uninitialized_variables
      var invoice;

      var filteredPays = await paysRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'March')
          .get();

      for (ppay in filteredPays.docs) {
        setState(() {
          thismonthpays.add(ppay.data());
        });
      }

      var filteredBills = await billsRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'March')
          .get();

      for (bill in filteredBills.docs) {
        setState(() {
          thismonthbills.add(bill.data());
        });
      }

      var filteredInvoices = await invoicesRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'March')
          .get();

      for (invoice in filteredInvoices.docs) {
        setState(() {
          thismonthinvoices.add(invoice.data());
        });
      }

      for (amount in thismonthpays) {
        setState(() {
          totalMonthlypays = totalMonthlypays + amount['amount'];
        });
      }

      for (amount in thismonthbills) {
        setState(() {
          totalMonthlybill = totalMonthlybill + amount['amount'];
        });
      }

      for (amount in thismonthinvoices) {
        setState(() {
          totalMonthlyinvoices = totalMonthlyinvoices + amount['amount'];
        });
      }

      setState(() {
        totalMonthlypayslength = thismonthpays.length.toDouble();
        totalMonthlybilllength = thismonthbills.length.toDouble();
        totalMonthlyinvoiceslength = thismonthinvoices.length.toDouble();
      });
      var totalJan = pay.where((element) =>
          element['month'] == 'January' &&
          element['year'] == currentYear.toString());

      var totalFeb = pay.where((element) =>
          element['month'] == 'February' &&
          element['year'] == currentYear.toString());

      var totalMarch = pay.where((element) =>
          element['month'] == 'March' &&
          element['year'] == currentYear.toString());

      for (amount in totalJan) {
        setState(() {
          totalforJan = totalforJan + amount['amount'];
          januaryration = (totalforJan * 6 / 10000);
        });
      }

      for (amount in totalFeb) {
        setState(() {
          totalforFeb = totalforFeb + amount['amount'];
          februaryration = (totalforFeb * 6 / 10000);
        });
      }

      for (amount in totalMarch) {
        setState(() {
          totalforMarch = totalforMarch + amount['amount'];
          marchration = (totalforMarch * 6 / 10000);
        });
      }

      setState(() {
        monthlyspots.add(FlSpot(0, januaryration));
        monthlyspots.add(FlSpot(1, februaryration));
        monthlyspots.add(FlSpot(2, marchration));
        monthlyspots.add(FlSpot(3, 0));
        monthlyspots.add(FlSpot(4, 0));
        monthlyspots.add(FlSpot(5, 0));
        monthlyspots.add(FlSpot(6, 0));
        monthlyspots.add(FlSpot(7, 0));
        monthlyspots.add(FlSpot(8, 0));
        monthlyspots.add(FlSpot(9, 0));
        monthlyspots.add(FlSpot(10, 0));
        monthlyspots.add(FlSpot(11, 0));
      });
    }

    if (currentmonth == 4) {
      var totalforJan = 0.00;
      var totalforFeb = 0.00;
      var totalforMarch = 0.00;
      var totalforApril = 0.00;
      var januaryration = 0.00;
      var februaryration = 0.00;
      var marchration = 0.00;
      var aprilration = 0.00;

      List<Map<dynamic, dynamic>>? thismonthpays = [];
      List<Map<dynamic, dynamic>>? thismonthbills = [];
      List<Map<dynamic, dynamic>>? thismonthinvoices = [];

      // ignore: prefer_typing_uninitialized_variables
      var ppay;
      // ignore: prefer_typing_uninitialized_variables
      var bill;
      // ignore: prefer_typing_uninitialized_variables
      var invoice;

      var filteredPays = await paysRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'April')
          .get();

      for (ppay in filteredPays.docs) {
        setState(() {
          thismonthpays.add(ppay.data());
        });
      }

      var filteredBills = await billsRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'April')
          .get();

      for (bill in filteredBills.docs) {
        setState(() {
          thismonthbills.add(bill.data());
        });
      }

      var filteredInvoices = await invoicesRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'April')
          .get();

      for (invoice in filteredInvoices.docs) {
        setState(() {
          thismonthinvoices.add(invoice.data());
        });
      }

      for (amount in thismonthpays) {
        setState(() {
          totalMonthlypays = totalMonthlypays + amount['amount'];
        });
      }

      for (amount in thismonthbills) {
        setState(() {
          totalMonthlybill = totalMonthlybill + amount['amount'];
        });
      }

      for (amount in thismonthinvoices) {
        setState(() {
          totalMonthlyinvoices = totalMonthlyinvoices + amount['amount'];
        });
      }

      setState(() {
        totalMonthlypayslength = thismonthpays.length.toDouble();
        totalMonthlybilllength = thismonthbills.length.toDouble();
        totalMonthlyinvoiceslength = thismonthinvoices.length.toDouble();
      });

      var totalJan = pay.where((element) =>
          element['month'] == 'January' &&
          element['year'] == currentYear.toString());

      var totalFeb = pay.where((element) =>
          element['month'] == 'February' &&
          element['year'] == currentYear.toString());

      var totalMarch = pay.where((element) =>
          element['month'] == 'March' &&
          element['year'] == currentYear.toString());

      var totalApril = pay.where((element) =>
          element['month'] == 'April' &&
          element['year'] == currentYear.toString());

      for (amount in totalJan) {
        setState(() {
          totalforJan = totalforJan + amount['amount'];
          januaryration = (totalforJan * 6 / 10000);
        });
      }

      for (amount in totalFeb) {
        setState(() {
          totalforFeb = totalforFeb + amount['amount'];
          februaryration = (totalforFeb * 6 / 10000);
        });
      }

      for (amount in totalMarch) {
        setState(() {
          totalforMarch = totalforMarch + amount['amount'];
          marchration = (totalforMarch * 6 / 10000);
        });
      }

      for (amount in totalApril) {
        setState(() {
          totalforApril = totalforApril + amount['amount'];
          aprilration = (totalforApril * 6 / 10000);
        });
      }

      setState(() {
        monthlyspots.add(FlSpot(0, januaryration));
        monthlyspots.add(FlSpot(1, februaryration));
        monthlyspots.add(FlSpot(2, marchration));
        monthlyspots.add(FlSpot(3, aprilration));
        monthlyspots.add(FlSpot(4, 0));
        monthlyspots.add(FlSpot(5, 0));
        monthlyspots.add(FlSpot(6, 0));
        monthlyspots.add(FlSpot(7, 0));
        monthlyspots.add(FlSpot(8, 0));
        monthlyspots.add(FlSpot(9, 0));
        monthlyspots.add(FlSpot(10, 0));
        monthlyspots.add(FlSpot(11, 0));
      });
    }

    if (currentmonth == 5) {
      var totalforJan = 0.00;
      var totalforFeb = 0.00;
      var totalforMarch = 0.00;
      var totalforApril = 0.00;
      var totalforMay = 0.00;
      var januaryration = 0.00;
      var februaryration = 0.00;
      var marchration = 0.00;
      var aprilration = 0.00;
      var mayration = 0.00;

      List<Map<dynamic, dynamic>>? thismonthpays = [];
      List<Map<dynamic, dynamic>>? thismonthbills = [];
      List<Map<dynamic, dynamic>>? thismonthinvoices = [];

      // ignore: prefer_typing_uninitialized_variables
      var ppay;
      // ignore: prefer_typing_uninitialized_variables
      var bill;
      // ignore: prefer_typing_uninitialized_variables
      var invoice;

      var filteredPays = await paysRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'May')
          .get();

      for (ppay in filteredPays.docs) {
        setState(() {
          thismonthpays.add(ppay.data());
        });
      }

      var filteredBills = await billsRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'May')
          .get();

      for (bill in filteredBills.docs) {
        setState(() {
          thismonthbills.add(bill.data());
        });
      }

      var filteredInvoices = await invoicesRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'May')
          .get();

      for (invoice in filteredInvoices.docs) {
        setState(() {
          thismonthinvoices.add(invoice.data());
        });
      }

      for (amount in thismonthpays) {
        setState(() {
          totalMonthlypays = totalMonthlypays + amount['amount'];
        });
      }

      for (amount in thismonthbills) {
        setState(() {
          totalMonthlybill = totalMonthlybill + amount['amount'];
        });
      }

      for (amount in thismonthinvoices) {
        setState(() {
          totalMonthlyinvoices = totalMonthlyinvoices + amount['amount'];
        });
      }

      setState(() {
        totalMonthlypayslength = thismonthpays.length.toDouble();
        totalMonthlybilllength = thismonthbills.length.toDouble();
        totalMonthlyinvoiceslength = thismonthinvoices.length.toDouble();
      });

      var totalJan = pay.where((element) =>
          element['month'] == 'January' &&
          element['year'] == currentYear.toString());

      var totalFeb = pay.where((element) =>
          element['month'] == 'February' &&
          element['year'] == currentYear.toString());

      var totalMarch = pay.where((element) =>
          element['month'] == 'March' &&
          element['year'] == currentYear.toString());

      var totalApril = pay
          .where((element) => element['month'] == 'April')
          .where((element) => element['Year'] == currentYear.toString);

      var totalMay = pay
          .where((element) => element['month'] == 'May')
          .where((element) => element['Year'] == currentYear.toString);

      for (amount in totalJan) {
        setState(() {
          totalforJan = totalforJan + amount['amount'];
          januaryration = (totalforJan * 6 / 10000);
        });
      }

      for (amount in totalFeb) {
        setState(() {
          totalforFeb = totalforFeb + amount['amount'];
          februaryration = (totalforFeb * 6 / 10000);
        });
      }

      for (amount in totalMarch) {
        setState(() {
          totalforMarch = totalforMarch + amount['amount'];
          marchration = (totalforMarch * 6 / 10000);
        });
      }

      for (amount in totalApril) {
        setState(() {
          totalforApril = totalforApril + amount['amount'];
          aprilration = (totalforApril * 6 / 10000);
        });
      }

      for (amount in totalApril) {
        setState(() {
          totalforApril = totalforApril + amount['amount'];
          aprilration = (totalforApril * 6 / 10000);
        });
      }

      for (amount in totalMay) {
        setState(() {
          totalforMay = totalforMay + amount['amount'];
          mayration = (totalforMay * 6 / 10000);
        });
      }

      setState(() {
        monthlyspots.add(FlSpot(0, januaryration));
        monthlyspots.add(FlSpot(1, februaryration));
        monthlyspots.add(FlSpot(2, marchration));
        monthlyspots.add(FlSpot(3, aprilration));
        monthlyspots.add(FlSpot(4, mayration));
        monthlyspots.add(FlSpot(5, 0));
        monthlyspots.add(FlSpot(6, 0));
        monthlyspots.add(FlSpot(7, 0));
        monthlyspots.add(FlSpot(8, 0));
        monthlyspots.add(FlSpot(9, 0));
        monthlyspots.add(FlSpot(10, 0));
        monthlyspots.add(FlSpot(11, 0));
      });
    }

    if (currentmonth == 6) {
      var totalforJan = 0.00;
      var totalforFeb = 0.00;
      var totalforMarch = 0.00;
      var totalforApril = 0.00;
      var totalforMay = 0.00;
      var totalforJune = 0.00;
      List<Map<dynamic, dynamic>>? thismonthpays = [];
      List<Map<dynamic, dynamic>>? thismonthbills = [];
      List<Map<dynamic, dynamic>>? thismonthinvoices = [];

      // ignore: prefer_typing_uninitialized_variables
      var ppay;
      // ignore: prefer_typing_uninitialized_variables
      var bill;
      // ignore: prefer_typing_uninitialized_variables
      var invoice;

      var filteredPays = await paysRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'June')
          .get();

      for (ppay in filteredPays.docs) {
        setState(() {
          thismonthpays.add(ppay.data());
        });
      }

      var filteredBills = await billsRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'June')
          .get();

      for (bill in filteredBills.docs) {
        setState(() {
          thismonthbills.add(bill.data());
        });
      }

      var filteredInvoices = await invoicesRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'June')
          .get();

      for (invoice in filteredInvoices.docs) {
        setState(() {
          thismonthinvoices.add(invoice.data());
        });
      }

      for (amount in thismonthpays) {
        setState(() {
          totalMonthlypays = totalMonthlypays + amount['amount'];
        });
      }

      for (amount in thismonthbills) {
        setState(() {
          totalMonthlybill = totalMonthlybill + amount['amount'];
        });
      }

      for (amount in thismonthinvoices) {
        setState(() {
          totalMonthlyinvoices = totalMonthlyinvoices + amount['amount'];
        });
      }

      setState(() {
        totalMonthlypayslength = thismonthpays.length.toDouble();
        totalMonthlybilllength = thismonthbills.length.toDouble();
        totalMonthlyinvoiceslength = thismonthinvoices.length.toDouble();
      });

      var januaryration = 0.00;
      var februaryration = 0.00;
      var marchration = 0.00;
      var aprilration = 0.00;
      var mayration = 0.00;
      var juneration = 0.00;

      var totalJan = pay.where((element) =>
          element['month'] == 'January' &&
          element['year'] == currentYear.toString());

      var totalFeb = pay.where((element) =>
          element['month'] == 'February' &&
          element['year'] == currentYear.toString());

      var totalMarch = pay.where((element) =>
          element['month'] == 'March' &&
          element['year'] == currentYear.toString());

      var totalApril = pay.where((element) =>
          element['month'] == 'April' &&
          element['year'] == currentYear.toString());

      var totalMay = pay.where((element) =>
          element['month'] == 'May' &&
          element['year'] == currentYear.toString());

      var totalJune = pay.where((element) =>
          element['month'] == 'June' &&
          element['year'] == currentYear.toString());

      for (amount in totalJan) {
        setState(() {
          totalforJan = totalforJan + amount['amount'];
          januaryration = (totalforJan * 6 / 10000);
        });
      }

      for (amount in totalFeb) {
        setState(() {
          totalforFeb = totalforFeb + amount['amount'];
          februaryration = (totalforFeb * 6 / 10000);
        });
      }

      for (amount in totalMarch) {
        setState(() {
          totalforMarch = totalforMarch + amount['amount'];
          marchration = (totalforMarch * 6 / 10000);
        });
      }

      for (amount in totalApril) {
        setState(() {
          totalforApril = totalforApril + amount['amount'];
          aprilration = (totalforApril * 6 / 10000);
        });
      }

      for (amount in totalMay) {
        setState(() {
          totalforMay = totalforMay + amount['amount'];
          mayration = (totalforMay * 6 / 10000);
        });
      }

      for (amount in totalJune) {
        setState(() {
          totalforJune = totalforJune + amount['amount'];
          juneration = (totalforJune * 6 / 10000);
        });
      }

      setState(() {
        monthlyspots.add(FlSpot(0, januaryration));
        monthlyspots.add(FlSpot(1, februaryration));
        monthlyspots.add(FlSpot(2, marchration));
        monthlyspots.add(FlSpot(3, aprilration));
        monthlyspots.add(FlSpot(4, mayration));
        monthlyspots.add(FlSpot(5, juneration));
        monthlyspots.add(FlSpot(6, 0));
        monthlyspots.add(FlSpot(7, 0));
        monthlyspots.add(FlSpot(8, 0));
        monthlyspots.add(FlSpot(9, 0));
        monthlyspots.add(FlSpot(10, 0));
        monthlyspots.add(FlSpot(11, 0));
      });
    }

    if (currentmonth == 7) {
      var totalforJan = 0.00;
      var totalforFeb = 0.00;
      var totalforMarch = 0.00;
      var totalforApril = 0.00;
      var totalforMay = 0.00;
      var totalforJune = 0.00;
      var totalforJuly = 0.00;
      List<Map<dynamic, dynamic>>? thismonthpays = [];
      List<Map<dynamic, dynamic>>? thismonthbills = [];
      List<Map<dynamic, dynamic>>? thismonthinvoices = [];

      // ignore: prefer_typing_uninitialized_variables
      var ppay;
      // ignore: prefer_typing_uninitialized_variables
      var bill;
      // ignore: prefer_typing_uninitialized_variables
      var invoice;

      var filteredPays = await paysRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'July')
          .get();

      for (ppay in filteredPays.docs) {
        setState(() {
          thismonthpays.add(ppay.data());
        });
      }

      var filteredBills = await billsRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'July')
          .get();

      for (bill in filteredBills.docs) {
        setState(() {
          thismonthbills.add(bill.data());
        });
      }

      var filteredInvoices = await invoicesRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'July')
          .get();

      for (invoice in filteredInvoices.docs) {
        setState(() {
          thismonthinvoices.add(invoice.data());
        });
      }

      for (amount in thismonthpays) {
        setState(() {
          totalMonthlypays = totalMonthlypays + amount['amount'];
        });
      }

      for (amount in thismonthbills) {
        setState(() {
          totalMonthlybill = totalMonthlybill + amount['amount'];
        });
      }

      for (amount in thismonthinvoices) {
        setState(() {
          totalMonthlyinvoices = totalMonthlyinvoices + amount['amount'];
        });
      }

      setState(() {
        totalMonthlypayslength = thismonthpays.length.toDouble();
        totalMonthlybilllength = thismonthbills.length.toDouble();
        totalMonthlyinvoiceslength = thismonthinvoices.length.toDouble();
      });

      var januaryration = 0.00;
      var februaryration = 0.00;
      var marchration = 0.00;
      var aprilration = 0.00;
      var mayration = 0.00;
      var juneration = 0.00;
      var julyration = 0.00;

      var totalJan = pay.where((element) =>
          element['month'] == 'January' &&
          element['year'] == currentYear.toString());

      var totalFeb = pay.where((element) =>
          element['month'] == 'February' &&
          element['year'] == currentYear.toString());

      var totalMarch = pay.where((element) =>
          element['month'] == 'March' &&
          element['year'] == currentYear.toString());

      var totalApril = pay.where((element) =>
          element['month'] == 'April' &&
          element['year'] == currentYear.toString());

      var totalMay = pay.where((element) =>
          element['month'] == 'May' &&
          element['year'] == currentYear.toString());

      var totalJune = pay.where((element) =>
          element['month'] == 'June' &&
          element['year'] == currentYear.toString());

      var totalJuly = pay.where((element) =>
          element['month'] == 'July' &&
          element['year'] == currentYear.toString());

      for (amount in totalJan) {
        setState(() {
          totalforJan = totalforJan + amount['amount'];
          januaryration = (totalforJan * 6 / 10000);
        });
      }

      for (amount in totalFeb) {
        setState(() {
          totalforFeb = totalforFeb + amount['amount'];
          februaryration = (totalforFeb * 6 / 10000);
        });
      }

      for (amount in totalMarch) {
        setState(() {
          totalforMarch = totalforMarch + amount['amount'];
          marchration = (totalforMarch * 6 / 10000);
        });
      }

      for (amount in totalApril) {
        setState(() {
          totalforApril = totalforApril + amount['amount'];
          aprilration = (totalforApril * 6 / 10000);
        });
      }

      for (amount in totalApril) {
        setState(() {
          totalforApril = totalforApril + amount['amount'];
          aprilration = (totalforApril * 6 / 10000);
        });
      }

      for (amount in totalMay) {
        setState(() {
          totalforMay = totalforMay + amount['amount'];
          mayration = (totalforMay * 6 / 10000);
        });
      }

      for (amount in totalJune) {
        setState(() {
          totalforJune = totalforJune + amount['amount'];
          juneration = (totalforJune * 6 / 10000);
        });
      }

      for (amount in totalJuly) {
        setState(() {
          totalforJuly = totalforJuly + amount['amount'];
          julyration = (totalforJuly * 6 / 10000);
        });
      }

      setState(() {
        monthlyspots.add(FlSpot(0, januaryration));
        monthlyspots.add(FlSpot(1, februaryration));
        monthlyspots.add(FlSpot(2, marchration));
        monthlyspots.add(FlSpot(3, aprilration));
        monthlyspots.add(FlSpot(4, mayration));
        monthlyspots.add(FlSpot(5, juneration));
        monthlyspots.add(FlSpot(6, julyration));
        monthlyspots.add(FlSpot(7, 0));
        monthlyspots.add(FlSpot(8, 0));
        monthlyspots.add(FlSpot(9, 0));
        monthlyspots.add(FlSpot(10, 0));
        monthlyspots.add(FlSpot(11, 0));
      });
    }

    if (currentmonth == 8) {
      var totalforJan = 0.00;
      var totalforFeb = 0.00;
      var totalforMarch = 0.00;
      var totalforApril = 0.00;
      var totalforMay = 0.00;
      var totalforJune = 0.00;
      var totalforJuly = 0.00;
      var totalforAugust = 0.00;

      List<Map<dynamic, dynamic>>? thismonthpays = [];
      List<Map<dynamic, dynamic>>? thismonthbills = [];
      List<Map<dynamic, dynamic>>? thismonthinvoices = [];

      // ignore: prefer_typing_uninitialized_variables
      var ppay;
      // ignore: prefer_typing_uninitialized_variables
      var bill;
      // ignore: prefer_typing_uninitialized_variables
      var invoice;

      var filteredPays = await paysRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'August')
          .get();

      for (ppay in filteredPays.docs) {
        setState(() {
          thismonthpays.add(ppay.data());
        });
      }

      var filteredBills = await billsRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'August')
          .get();

      for (bill in filteredBills.docs) {
        setState(() {
          thismonthbills.add(bill.data());
        });
      }

      var filteredInvoices = await invoicesRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'August')
          .get();

      for (invoice in filteredInvoices.docs) {
        setState(() {
          thismonthinvoices.add(invoice.data());
        });
      }

      for (amount in thismonthpays) {
        setState(() {
          totalMonthlypays = totalMonthlypays + amount['amount'];
        });
      }

      for (amount in thismonthbills) {
        setState(() {
          totalMonthlybill = totalMonthlybill + amount['amount'];
        });
      }

      for (amount in thismonthinvoices) {
        setState(() {
          totalMonthlyinvoices = totalMonthlyinvoices + amount['amount'];
        });
      }

      setState(() {
        totalMonthlypayslength = thismonthpays.length.toDouble();
        totalMonthlybilllength = thismonthbills.length.toDouble();
        totalMonthlyinvoiceslength = thismonthinvoices.length.toDouble();
      });

      var januaryration = 0.00;
      var februaryration = 0.00;
      var marchration = 0.00;
      var aprilration = 0.00;
      var mayration = 0.00;
      var juneration = 0.00;
      var julyration = 0.00;
      var augustration = 0.00;

      var totalJan = pay.where((element) =>
          element['month'] == 'January' &&
          element['year'] == currentYear.toString());

      var totalFeb = pay.where((element) =>
          element['month'] == 'February' &&
          element['year'] == currentYear.toString());

      var totalMarch = pay.where((element) =>
          element['month'] == 'March' &&
          element['year'] == currentYear.toString());

      var totalApril = pay.where((element) =>
          element['month'] == 'April' &&
          element['year'] == currentYear.toString());

      var totalMay = pay.where((element) =>
          element['month'] == 'May' &&
          element['year'] == currentYear.toString());

      var totalJune = pay.where((element) =>
          element['month'] == 'June' &&
          element['year'] == currentYear.toString());

      var totalJuly = pay.where((element) =>
          element['month'] == 'July' &&
          element['year'] == currentYear.toString());

      var totalAugust = pay.where((element) =>
          element['month'] == 'August' &&
          element['year'] == currentYear.toString());

      for (amount in totalJan) {
        setState(() {
          totalforJan = totalforJan + amount['amount'];
          januaryration = (totalforJan * 6 / 10000);
        });
      }

      for (amount in totalFeb) {
        setState(() {
          totalforFeb = totalforFeb + amount['amount'];
          februaryration = (totalforFeb * 6 / 10000);
        });
      }

      for (amount in totalMarch) {
        setState(() {
          totalforMarch = totalforMarch + amount['amount'];
          marchration = (totalforMarch * 6 / 10000);
        });
      }

      for (amount in totalApril) {
        setState(() {
          totalforApril = totalforApril + amount['amount'];
          aprilration = (totalforApril * 6 / 10000);
        });
      }

      for (amount in totalApril) {
        setState(() {
          totalforApril = totalforApril + amount['amount'];
          aprilration = (totalforApril * 6 / 10000);
        });
      }

      for (amount in totalMay) {
        setState(() {
          totalforMay = totalforMay + amount['amount'];
          mayration = (totalforMay * 6 / 10000);
        });
      }

      for (amount in totalJune) {
        setState(() {
          totalforJune = totalforJune + amount['amount'];
          juneration = (totalforJune * 6 / 10000);
        });
      }

      for (amount in totalJuly) {
        setState(() {
          totalforJuly = totalforJuly + amount['amount'];
          julyration = (totalforJuly * 6 / 10000);
        });
      }

      for (amount in totalAugust) {
        setState(() {
          totalforAugust = totalforAugust + amount['amount'];
          augustration = (totalforAugust * 6 / 10000);
        });
      }

      setState(() {
        monthlyspots.add(FlSpot(0, januaryration));
        monthlyspots.add(FlSpot(1, februaryration));
        monthlyspots.add(FlSpot(2, marchration));
        monthlyspots.add(FlSpot(3, aprilration));
        monthlyspots.add(FlSpot(4, mayration));
        monthlyspots.add(FlSpot(5, juneration));
        monthlyspots.add(FlSpot(6, julyration));
        monthlyspots.add(FlSpot(7, augustration));
        monthlyspots.add(FlSpot(8, 0));
        monthlyspots.add(FlSpot(9, 0));
        monthlyspots.add(FlSpot(10, 0));
        monthlyspots.add(FlSpot(11, 0));
      });
    }

    if (currentmonth == 9) {
      var totalforJan = 0.00;
      var totalforFeb = 0.00;
      var totalforMarch = 0.00;
      var totalforApril = 0.00;
      var totalforMay = 0.00;
      var totalforJune = 0.00;
      var totalforJuly = 0.00;
      var totalforAugust = 0.00;
      var totalforSeptember = 0.00;

      List<Map<dynamic, dynamic>>? thismonthpays = [];
      List<Map<dynamic, dynamic>>? thismonthbills = [];
      List<Map<dynamic, dynamic>>? thismonthinvoices = [];

      // ignore: prefer_typing_uninitialized_variables
      var ppay;
      // ignore: prefer_typing_uninitialized_variables
      var bill;
      // ignore: prefer_typing_uninitialized_variables
      var invoice;

      var filteredPays = await paysRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'September')
          .get();

      for (ppay in filteredPays.docs) {
        setState(() {
          thismonthpays.add(ppay.data());
        });
      }

      var filteredBills = await billsRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'September')
          .get();

      for (bill in filteredBills.docs) {
        setState(() {
          thismonthbills.add(bill.data());
        });
      }

      var filteredInvoices = await invoicesRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'September')
          .get();

      for (invoice in filteredInvoices.docs) {
        setState(() {
          thismonthinvoices.add(invoice.data());
        });
      }

      for (amount in thismonthpays) {
        setState(() {
          totalMonthlypays = totalMonthlypays + amount['amount'];
        });
      }

      for (amount in thismonthbills) {
        setState(() {
          totalMonthlybill = totalMonthlybill + amount['amount'];
        });
      }

      for (amount in thismonthinvoices) {
        setState(() {
          totalMonthlyinvoices = totalMonthlyinvoices + amount['amount'];
        });
      }

      setState(() {
        totalMonthlypayslength = thismonthpays.length.toDouble();
        totalMonthlybilllength = thismonthbills.length.toDouble();
        totalMonthlyinvoiceslength = thismonthinvoices.length.toDouble();
      });

      var januaryration = 0.00;
      var februaryration = 0.00;
      var marchration = 0.00;
      var aprilration = 0.00;
      var mayration = 0.00;
      var juneration = 0.00;
      var julyration = 0.00;
      var augustration = 0.00;
      var septemberration = 0.00;

      var totalJan = pay.where((element) =>
          element['month'] == 'January' &&
          element['year'] == currentYear.toString());

      var totalFeb = pay.where((element) =>
          element['month'] == 'February' &&
          element['year'] == currentYear.toString());

      var totalMarch = pay.where((element) =>
          element['month'] == 'March' &&
          element['year'] == currentYear.toString());

      var totalApril = pay.where((element) =>
          element['month'] == 'April' &&
          element['year'] == currentYear.toString());

      var totalMay = pay.where((element) =>
          element['month'] == 'May' &&
          element['year'] == currentYear.toString());

      var totalJune = pay.where((element) =>
          element['month'] == 'June' &&
          element['year'] == currentYear.toString());

      var totalJuly = pay.where((element) =>
          element['month'] == 'July' &&
          element['year'] == currentYear.toString());

      var totalAugust = pay.where((element) =>
          element['month'] == 'August' &&
          element['year'] == currentYear.toString());

      var totalSeptember = pay.where((element) =>
          element['month'] == 'September' &&
          element['year'] == currentYear.toString());

      for (amount in totalJan) {
        setState(() {
          totalforJan = totalforJan + amount['amount'];
          januaryration = (totalforJan * 6 / 10000);
        });
      }

      for (amount in totalFeb) {
        setState(() {
          totalforFeb = totalforFeb + amount['amount'];
          februaryration = (totalforFeb * 6 / 10000);
        });
      }

      for (amount in totalMarch) {
        setState(() {
          totalforMarch = totalforMarch + amount['amount'];
          marchration = (totalforMarch * 6 / 10000);
        });
      }

      for (amount in totalApril) {
        setState(() {
          totalforApril = totalforApril + amount['amount'];
          aprilration = (totalforApril * 6 / 10000);
        });
      }

      for (amount in totalApril) {
        setState(() {
          totalforApril = totalforApril + amount['amount'];
          aprilration = (totalforApril * 6 / 10000);
        });
      }

      for (amount in totalMay) {
        setState(() {
          totalforMay = totalforMay + amount['amount'];
          mayration = (totalforMay * 6 / 10000);
        });
      }

      for (amount in totalJune) {
        setState(() {
          totalforJune = totalforJune + amount['amount'];
          juneration = (totalforJune * 6 / 10000);
        });
      }

      for (amount in totalJuly) {
        setState(() {
          totalforJuly = totalforJuly + amount['amount'];
          julyration = (totalforJuly * 6 / 10000);
        });
      }

      for (amount in totalAugust) {
        setState(() {
          totalforAugust = totalforAugust + amount['amount'];
          augustration = (totalforAugust * 6 / 10000);
        });
      }

      for (amount in totalSeptember) {
        setState(() {
          totalforSeptember = totalforSeptember + amount['amount'];
          septemberration = (totalforSeptember * 6 / 10000);
        });
      }

      setState(() {
        monthlyspots.add(FlSpot(0, januaryration));
        monthlyspots.add(FlSpot(1, februaryration));
        monthlyspots.add(FlSpot(2, marchration));
        monthlyspots.add(FlSpot(3, aprilration));
        monthlyspots.add(FlSpot(4, mayration));
        monthlyspots.add(FlSpot(5, juneration));
        monthlyspots.add(FlSpot(6, julyration));
        monthlyspots.add(FlSpot(7, augustration));
        monthlyspots.add(FlSpot(8, septemberration));
        monthlyspots.add(FlSpot(9, 0));
        monthlyspots.add(FlSpot(10, 0));
        monthlyspots.add(FlSpot(11, 0));
      });
    }

    if (currentmonth == 10) {
      var totalforJan = 0.00;
      var totalforFeb = 0.00;
      var totalforMarch = 0.00;
      var totalforApril = 0.00;
      var totalforMay = 0.00;
      var totalforJune = 0.00;
      var totalforJuly = 0.00;
      var totalforAugust = 0.00;
      var totalforSeptember = 0.00;
      var totalforOctober = 0.00;

      List<Map<dynamic, dynamic>>? thismonthpays = [];
      List<Map<dynamic, dynamic>>? thismonthbills = [];
      List<Map<dynamic, dynamic>>? thismonthinvoices = [];

      // ignore: prefer_typing_uninitialized_variables
      var ppay;
      // ignore: prefer_typing_uninitialized_variables
      var bill;
      // ignore: prefer_typing_uninitialized_variables
      var invoice;

      var filteredPays = await paysRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'October')
          .get();

      for (ppay in filteredPays.docs) {
        setState(() {
          thismonthpays.add(ppay.data());
        });
      }

      var filteredBills = await billsRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'October')
          .get();

      for (bill in filteredBills.docs) {
        setState(() {
          thismonthbills.add(bill.data());
        });
      }

      var filteredInvoices = await invoicesRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'October')
          .get();

      for (invoice in filteredInvoices.docs) {
        setState(() {
          thismonthinvoices.add(invoice.data());
        });
      }

      for (amount in thismonthpays) {
        setState(() {
          totalMonthlypays = totalMonthlypays + amount['amount'];
        });
      }

      for (amount in thismonthbills) {
        setState(() {
          totalMonthlybill = totalMonthlybill + amount['amount'];
        });
      }

      for (amount in thismonthinvoices) {
        setState(() {
          totalMonthlyinvoices = totalMonthlyinvoices + amount['amount'];
        });
      }

      setState(() {
        totalMonthlypayslength = thismonthpays.length.toDouble();
        totalMonthlybilllength = thismonthbills.length.toDouble();
        totalMonthlyinvoiceslength = thismonthinvoices.length.toDouble();
      });

      var januaryration = 0.00;
      var februaryration = 0.00;
      var marchration = 0.00;
      var aprilration = 0.00;
      var mayration = 0.00;
      var juneration = 0.00;
      var julyration = 0.00;
      var augustration = 0.00;
      var septemberration = 0.00;
      var octoberration = 0.00;

      var totalJan = pay.where((element) =>
          element['month'] == 'January' &&
          element['year'] == currentYear.toString());

      var totalFeb = pay.where((element) =>
          element['month'] == 'February' &&
          element['year'] == currentYear.toString());

      var totalMarch = pay.where((element) =>
          element['month'] == 'March' &&
          element['year'] == currentYear.toString());

      var totalApril = pay.where((element) =>
          element['month'] == 'April' &&
          element['year'] == currentYear.toString());

      var totalMay = pay.where((element) =>
          element['month'] == 'May' &&
          element['year'] == currentYear.toString());

      var totalJune = pay.where((element) =>
          element['month'] == 'June' &&
          element['year'] == currentYear.toString());

      var totalJuly = pay.where((element) =>
          element['month'] == 'July' &&
          element['year'] == currentYear.toString());

      var totalAugust = pay.where((element) =>
          element['month'] == 'August' &&
          element['year'] == currentYear.toString());

      var totalSeptember = pay.where((element) =>
          element['month'] == 'September' &&
          element['year'] == currentYear.toString());

      var totalOctober = pay.where((element) =>
          element['month'] == 'October' &&
          element['year'] == currentYear.toString());

      for (amount in totalJan) {
        setState(() {
          totalforJan = totalforJan + amount['amount'];
          januaryration = (totalforJan * 6 / 10000);
        });
      }

      for (amount in totalFeb) {
        setState(() {
          totalforFeb = totalforFeb + amount['amount'];
          februaryration = (totalforFeb * 6 / 10000);
        });
      }

      for (amount in totalMarch) {
        setState(() {
          totalforMarch = totalforMarch + amount['amount'];
          marchration = (totalforMarch * 6 / 10000);
        });
      }

      for (amount in totalApril) {
        setState(() {
          totalforApril = totalforApril + amount['amount'];
          aprilration = (totalforApril * 6 / 10000);
        });
      }

      for (amount in totalApril) {
        setState(() {
          totalforApril = totalforApril + amount['amount'];
          aprilration = (totalforApril * 6 / 10000);
        });
      }

      for (amount in totalMay) {
        setState(() {
          totalforMay = totalforMay + amount['amount'];
          mayration = (totalforMay * 6 / 10000);
        });
      }

      for (amount in totalJune) {
        setState(() {
          totalforJune = totalforJune + amount['amount'];
          juneration = (totalforJune * 6 / 10000);
        });
      }

      for (amount in totalJuly) {
        setState(() {
          totalforJuly = totalforJuly + amount['amount'];
          julyration = (totalforJuly * 6 / 10000);
        });
      }

      for (amount in totalAugust) {
        setState(() {
          totalforAugust = totalforAugust + amount['amount'];
          augustration = (totalforAugust * 6 / 10000);
        });
      }

      for (amount in totalSeptember) {
        setState(() {
          totalforSeptember = totalforSeptember + amount['amount'];
          septemberration = (totalforSeptember * 6 / 10000);
        });
      }

      for (amount in totalOctober) {
        setState(() {
          totalforOctober = totalforOctober + amount['amount'];
          octoberration = (totalforOctober * 6 / 10000);
        });
      }

      setState(() {
        monthlyspots.add(FlSpot(0, januaryration));
        monthlyspots.add(FlSpot(1, februaryration));
        monthlyspots.add(FlSpot(2, marchration));
        monthlyspots.add(FlSpot(3, aprilration));
        monthlyspots.add(FlSpot(4, mayration));
        monthlyspots.add(FlSpot(5, juneration));
        monthlyspots.add(FlSpot(6, julyration));
        monthlyspots.add(FlSpot(7, augustration));
        monthlyspots.add(FlSpot(8, septemberration));
        monthlyspots.add(FlSpot(9, octoberration));
        monthlyspots.add(FlSpot(10, 0));
        monthlyspots.add(FlSpot(11, 0));
      });
    }

    if (currentmonth == 11) {
      var totalforJan = 0.00;
      var totalforFeb = 0.00;
      var totalforMarch = 0.00;
      var totalforApril = 0.00;
      var totalforMay = 0.00;
      var totalforJune = 0.00;
      var totalforJuly = 0.00;
      var totalforAugust = 0.00;
      var totalforSeptember = 0.00;
      var totalforOctober = 0.00;
      var totalforNovember = 0.00;

      List<Map<dynamic, dynamic>>? thismonthpays = [];
      List<Map<dynamic, dynamic>>? thismonthbills = [];
      List<Map<dynamic, dynamic>>? thismonthinvoices = [];

      // ignore: prefer_typing_uninitialized_variables
      var ppay;
      // ignore: prefer_typing_uninitialized_variables
      var bill;
      // ignore: prefer_typing_uninitialized_variables
      var invoice;

      var filteredPays = await paysRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'November')
          .get();

      for (ppay in filteredPays.docs) {
        setState(() {
          thismonthpays.add(ppay.data());
        });
      }

      var filteredBills = await billsRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'November')
          .get();

      for (bill in filteredBills.docs) {
        setState(() {
          thismonthbills.add(bill.data());
        });
      }

      var filteredInvoices = await invoicesRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'November')
          .get();

      for (invoice in filteredInvoices.docs) {
        setState(() {
          thismonthinvoices.add(invoice.data());
        });
      }

      for (amount in thismonthpays) {
        setState(() {
          totalMonthlypays = totalMonthlypays + amount['amount'];
        });
      }

      for (amount in thismonthbills) {
        setState(() {
          totalMonthlybill = totalMonthlybill + amount['amount'];
        });
      }

      for (amount in thismonthinvoices) {
        setState(() {
          totalMonthlyinvoices = totalMonthlyinvoices + amount['amount'];
        });
      }

      setState(() {
        totalMonthlypayslength = thismonthpays.length.toDouble();
        totalMonthlybilllength = thismonthbills.length.toDouble();
        totalMonthlyinvoiceslength = thismonthinvoices.length.toDouble();
      });

      var januaryration = 0.00;
      var februaryration = 0.00;
      var marchration = 0.00;
      var aprilration = 0.00;
      var mayration = 0.00;
      var juneration = 0.00;
      var julyration = 0.00;
      var augustration = 0.00;
      var septemberration = 0.00;
      var octoberration = 0.00;
      var novemberration = 0.00;

      var totalJan = pay.where((element) =>
          element['month'] == 'January' &&
          element['year'] == currentYear.toString());

      var totalFeb = pay.where((element) =>
          element['month'] == 'February' &&
          element['year'] == currentYear.toString());

      var totalMarch = pay.where((element) =>
          element['month'] == 'March' &&
          element['year'] == currentYear.toString());

      var totalApril = pay.where((element) =>
          element['month'] == 'April' &&
          element['year'] == currentYear.toString());

      var totalMay = pay.where((element) =>
          element['month'] == 'May' &&
          element['year'] == currentYear.toString());

      var totalJune = pay.where((element) =>
          element['month'] == 'June' &&
          element['year'] == currentYear.toString());

      var totalJuly = pay.where((element) =>
          element['month'] == 'July' &&
          element['year'] == currentYear.toString());

      var totalAugust = pay.where((element) =>
          element['month'] == 'August' &&
          element['year'] == currentYear.toString());

      var totalSeptember = pay.where((element) =>
          element['month'] == 'September' &&
          element['year'] == currentYear.toString());

      var totalOctober = pay.where((element) =>
          element['month'] == 'October' &&
          element['year'] == currentYear.toString());

      var totalNovember = pay.where((element) =>
          element['month'] == 'November' &&
          element['year'] == currentYear.toString());

      for (amount in totalJan) {
        setState(() {
          totalforJan = totalforJan + amount['amount'];
          januaryration = (totalforJan * 6 / 10000);
        });
      }

      for (amount in totalFeb) {
        setState(() {
          totalforFeb = totalforFeb + amount['amount'];
          februaryration = (totalforFeb * 6 / 10000);
        });
      }

      for (amount in totalMarch) {
        setState(() {
          totalforMarch = totalforMarch + amount['amount'];
          marchration = (totalforMarch * 6 / 10000);
        });
      }

      for (amount in totalApril) {
        setState(() {
          totalforApril = totalforApril + amount['amount'];
          aprilration = (totalforApril * 6 / 10000);
        });
      }

      for (amount in totalApril) {
        setState(() {
          totalforApril = totalforApril + amount['amount'];
          aprilration = (totalforApril * 6 / 10000);
        });
      }

      for (amount in totalMay) {
        setState(() {
          totalforMay = totalforMay + amount['amount'];
          mayration = (totalforMay * 6 / 10000);
        });
      }

      for (amount in totalJune) {
        setState(() {
          totalforJune = totalforJune + amount['amount'];
          juneration = (totalforJune * 6 / 10000);
        });
      }

      for (amount in totalJuly) {
        setState(() {
          totalforJuly = totalforJuly + amount['amount'];
          julyration = (totalforJuly * 6 / 10000);
        });
      }

      for (amount in totalAugust) {
        setState(() {
          totalforAugust = totalforAugust + amount['amount'];
          augustration = (totalforAugust * 6 / 10000);
        });
      }

      for (amount in totalSeptember) {
        setState(() {
          totalforSeptember = totalforSeptember + amount['amount'];
          septemberration = (totalforSeptember * 6 / 10000);
        });
      }

      for (amount in totalOctober) {
        setState(() {
          totalforOctober = totalforOctober + amount['amount'];
          octoberration = (totalforOctober * 6 / 10000);
        });
      }

      for (amount in totalNovember) {
        setState(() {
          totalforNovember = totalforNovember + amount['amount'];
          novemberration = (totalforNovember * 6 / 10000);
        });
      }

      setState(() {
        monthlyspots.add(FlSpot(0, januaryration));
        monthlyspots.add(FlSpot(1, februaryration));
        monthlyspots.add(FlSpot(2, marchration));
        monthlyspots.add(FlSpot(3, aprilration));
        monthlyspots.add(FlSpot(4, mayration));
        monthlyspots.add(FlSpot(5, juneration));
        monthlyspots.add(FlSpot(6, julyration));
        monthlyspots.add(FlSpot(7, augustration));
        monthlyspots.add(FlSpot(8, septemberration));
        monthlyspots.add(FlSpot(9, octoberration));
        monthlyspots.add(FlSpot(10, novemberration));
        monthlyspots.add(FlSpot(11, 0));
      });
    }

    if (currentmonth == 12) {
      var totalforJan = 0.00;
      var totalforFeb = 0.00;
      var totalforMarch = 0.00;
      var totalforApril = 0.00;
      var totalforMay = 0.00;
      var totalforJune = 0.00;
      var totalforJuly = 0.00;
      var totalforAugust = 0.00;
      var totalforSeptember = 0.00;
      var totalforOctober = 0.00;
      var totalforNovember = 0.00;
      var totalforDecember = 0.00;
      List<Map<dynamic, dynamic>>? thismonthpays = [];
      List<Map<dynamic, dynamic>>? thismonthbills = [];
      List<Map<dynamic, dynamic>>? thismonthinvoices = [];

      // ignore: prefer_typing_uninitialized_variables
      var ppay;
      // ignore: prefer_typing_uninitialized_variables
      var bill;
      // ignore: prefer_typing_uninitialized_variables
      var invoice;

      var filteredPays = await paysRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'December')
          .get();

      for (ppay in filteredPays.docs) {
        setState(() {
          thismonthpays.add(ppay.data());
        });
      }

      var filteredBills = await billsRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'December')
          .get();

      for (bill in filteredBills.docs) {
        setState(() {
          thismonthbills.add(bill.data());
        });
      }

      var filteredInvoices = await invoicesRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .where('month', isEqualTo: 'December')
          .get();

      for (invoice in filteredInvoices.docs) {
        setState(() {
          thismonthinvoices.add(invoice.data());
        });
      }

      for (amount in thismonthpays) {
        setState(() {
          totalMonthlypays = totalMonthlypays + amount['amount'];
        });
      }

      for (amount in thismonthbills) {
        setState(() {
          totalMonthlybill = totalMonthlybill + amount['amount'];
        });
      }

      for (amount in thismonthinvoices) {
        setState(() {
          totalMonthlyinvoices = totalMonthlyinvoices + amount['amount'];
        });
      }

      setState(() {
        totalMonthlypayslength = thismonthpays.length.toDouble();
        totalMonthlybilllength = thismonthbills.length.toDouble();
        totalMonthlyinvoiceslength = thismonthinvoices.length.toDouble();
      });
      var januaryration = 0.00;
      var februaryration = 0.00;
      var marchration = 0.00;
      var aprilration = 0.00;
      var mayration = 0.00;
      var juneration = 0.00;
      var julyration = 0.00;
      var augustration = 0.00;
      var septemberration = 0.00;
      var octoberration = 0.00;
      var novemberration = 0.00;
      var decemberration = 0.00;

      var totalJan = pay.where((element) =>
          element['month'] == 'January' &&
          element['year'] == currentYear.toString());

      var totalFeb = pay.where((element) =>
          element['month'] == 'February' &&
          element['year'] == currentYear.toString());

      var totalMarch = pay.where((element) =>
          element['month'] == 'March' &&
          element['year'] == currentYear.toString());

      var totalApril = pay.where((element) =>
          element['month'] == 'April' &&
          element['year'] == currentYear.toString());

      var totalMay = pay.where((element) =>
          element['month'] == 'May' &&
          element['year'] == currentYear.toString());

      var totalJune = pay.where((element) =>
          element['month'] == 'June' &&
          element['year'] == currentYear.toString());

      var totalJuly = pay.where((element) =>
          element['month'] == 'July' &&
          element['year'] == currentYear.toString());

      var totalAugust = pay.where((element) =>
          element['month'] == 'August' &&
          element['year'] == currentYear.toString());

      var totalSeptember = pay.where((element) =>
          element['month'] == 'September' &&
          element['year'] == currentYear.toString());

      var totalOctober = pay.where((element) =>
          element['month'] == 'October' &&
          element['year'] == currentYear.toString());

      var totalNovember = pay.where((element) =>
          element['month'] == 'November' &&
          element['year'] == currentYear.toString());

      var totalDecember = pay.where((element) =>
          element['month'] == 'December' &&
          element['year'] == currentYear.toString());

      for (amount in totalJan) {
        setState(() {
          totalforJan = totalforJan + amount['amount'];
          januaryration = (totalforJan * 6 / 10000);
        });
      }

      for (amount in totalFeb) {
        setState(() {
          totalforFeb = totalforFeb + amount['amount'];
          februaryration = (totalforFeb * 6 / 10000);
        });
      }

      for (amount in totalMarch) {
        setState(() {
          totalforMarch = totalforMarch + amount['amount'];
          marchration = (totalforMarch * 6 / 10000);
        });
      }

      for (amount in totalApril) {
        setState(() {
          totalforApril = totalforApril + amount['amount'];
          aprilration = (totalforApril * 6 / 10000);
        });
      }

      for (amount in totalApril) {
        setState(() {
          totalforApril = totalforApril + amount['amount'];
          aprilration = (totalforApril * 6 / 10000);
        });
      }

      for (amount in totalMay) {
        setState(() {
          totalforMay = totalforMay + amount['amount'];
          mayration = (totalforMay * 6 / 10000);
        });
      }

      for (amount in totalJune) {
        setState(() {
          totalforJune = totalforJune + amount['amount'];
          juneration = (totalforJune * 6 / 10000);
        });
      }

      for (amount in totalJuly) {
        setState(() {
          totalforJuly = totalforJuly + amount['amount'];
          julyration = (totalforJuly * 6 / 10000);
        });
      }

      for (amount in totalAugust) {
        setState(() {
          totalforAugust = totalforAugust + amount['amount'];
          augustration = (totalforAugust * 6 / 10000);
        });
      }

      for (amount in totalSeptember) {
        setState(() {
          totalforSeptember = totalforSeptember + amount['amount'];
          septemberration = (totalforSeptember * 6 / 10000);
        });
      }

      for (amount in totalOctober) {
        setState(() {
          totalforOctober = totalforOctober + amount['amount'];
          octoberration = (totalforOctober * 6 / 10000);
        });
      }

      for (amount in totalNovember) {
        setState(() {
          totalforNovember = totalforNovember + amount['amount'];
          novemberration = (totalforNovember * 6 / 10000);
        });
      }

      for (amount in totalDecember) {
        setState(() {
          totalforDecember = totalforDecember + amount['amount'];
          decemberration = (totalforDecember * 6 / 10000);
        });
      }

      setState(() {
        monthlyspots.add(FlSpot(0, januaryration));
        monthlyspots.add(FlSpot(1, februaryration));
        monthlyspots.add(FlSpot(2, marchration));
        monthlyspots.add(FlSpot(3, aprilration));
        monthlyspots.add(FlSpot(4, mayration));
        monthlyspots.add(FlSpot(5, juneration));
        monthlyspots.add(FlSpot(6, julyration));
        monthlyspots.add(FlSpot(7, augustration));
        monthlyspots.add(FlSpot(8, septemberration));
        monthlyspots.add(FlSpot(9, octoberration));
        monthlyspots.add(FlSpot(10, novemberration));
        monthlyspots.add(FlSpot(11, decemberration));
      });
    }

    for (amount in pay) {
      setState(() {
        totalPaymentsmade = totalPaymentsmade + amount['amount'];
      });
    }

    if (currentYear == 2022) {
      var totalforCurrentYear = 0.00;
      var currentyearration = 0.00;
      var totalCurrentYear =
          pay.where((element) => element['year'] == currentYear.toString());

      List<Map<dynamic, dynamic>>? thisyearspays = [];
      List<Map<dynamic, dynamic>>? thisyearsbills = [];
      List<Map<dynamic, dynamic>>? thisyearsinvoices = [];

      // ignore: prefer_typing_uninitialized_variables
      var ppay;
      // ignore: prefer_typing_uninitialized_variables
      var bill;
      // ignore: prefer_typing_uninitialized_variables
      var invoice;

      var filteredPays = await paysRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .get();

      for (ppay in filteredPays.docs) {
        setState(() {
          thisyearspays.add(ppay.data());
        });
      }

      var filteredBills = await billsRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .get();

      for (bill in filteredBills.docs) {
        setState(() {
          thisyearsbills.add(bill.data());
        });
      }

      var filteredInvoices = await invoicesRef
          .where('userid', isEqualTo: FirebaseServices().getUserId())
          .where('year', isEqualTo: currentYear.toString())
          .get();

      for (invoice in filteredInvoices.docs) {
        setState(() {
          thisyearsinvoices.add(invoice.data());
        });
      }

      for (amount in thisyearspays) {
        setState(() {
          totalYearlypays = totalYearlypays + amount['amount'];
        });
      }

      for (amount in thisyearsbills) {
        setState(() {
          totalYearlybill = totalYearlybill + amount['amount'];
        });
      }

      for (amount in thisyearsinvoices) {
        setState(() {
          totalYearlyinvoices = totalYearlyinvoices + amount['amount'];
        });
      }

      setState(() {
        totalYearlypayslength = thisyearspays.length.toDouble();
        totalYearlybilllength = thisyearsbills.length.toDouble();
        totalYearlyinvoiceslength = thisyearsinvoices.length.toDouble();
      });

      for (amount in totalCurrentYear) {
        setState(() {
          totalforCurrentYear = totalforCurrentYear + amount['amount'];
          currentyearration = (totalforCurrentYear * 6 / 10000);
        });
      }

      setState(() {
        yearlyspots.add(FlSpot(0, 0));
        yearlyspots.add(FlSpot(1, 0));
        yearlyspots.add(FlSpot(2, 0));
        yearlyspots.add(FlSpot(3, 0));
        yearlyspots.add(FlSpot(4, 0));
        yearlyspots.add(FlSpot(5, 0));
        yearlyspots.add(FlSpot(6, 0));
        yearlyspots.add(FlSpot(7, 0));
        yearlyspots.add(FlSpot(8, 0));
        yearlyspots.add(FlSpot(9, 0));
        yearlyspots.add(FlSpot(10, 0));
        yearlyspots.add(FlSpot(11, currentyearration));
      });
    }

    setState(() {
      totalPaymentsmadepercent =
          (totalPaymentsmade * 100) / (totalPaymentsmade + totalbillsmade);
      totalbillsmadepercent =
          (totalbillsmade * 100) / (totalbillsmade + totalPaymentsmade);

      if (totalPaymentsmade < 1 && totalbillsmade < 1) {
        setState(() {
          hasNoChartValues = true;
        });
        paiChartSelectionDatas.add(
          PieChartSectionData(
              color: primaryTwo,
              value: 100,
              radius: 25,
              titlePositionPercentageOffset: 2.0,
              titleStyle: const TextStyle(
                  fontSize: 1,
                  color: primaryTwo,
                  fontFamily: 'AvenirNext',
                  fontWeight: FontWeight.w600)),
        );

        paiChartSelectionDatas.add(
          PieChartSectionData(
              color: secondaryColor,
              value: 0.0,
              radius: 22,
              titlePositionPercentageOffset: 2.0,
              titleStyle: const TextStyle(
                  color: secondaryColor,
                  fontFamily: 'AvenirNext',
                  fontWeight: FontWeight.w600)),
        );
      } else {
        paiChartSelectionDatas.add(
          PieChartSectionData(
              color: primaryTwo,
              value: totalPaymentsmadepercent.round().toDouble(),
              title: '${totalPaymentsmadepercent.round().toString()} %',
              showTitle: true,
              radius: 25,
              titlePositionPercentageOffset: 2.0,
              titleStyle: const TextStyle(
                  color: primaryTwo,
                  fontFamily: 'AvenirNext',
                  fontWeight: FontWeight.w600)),
        );

        paiChartSelectionDatas.add(
          PieChartSectionData(
              color: secondaryColor,
              value: totalbillsmadepercent.round().toDouble(),
              showTitle: true,
              title: '${totalbillsmadepercent.round().toString()} %',
              radius: 22,
              titlePositionPercentageOffset: 2.0,
              titleStyle: const TextStyle(
                  color: secondaryColor,
                  fontFamily: 'AvenirNext',
                  fontWeight: FontWeight.w600)),
        );
      }
    });

    setState(() {});

    setState(() {
      appisLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return appisLoading == false
        ? Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedLabelStyle: const TextStyle(
                  fontSize: 10,
                  fontFamily: 'AvenirNext',
                  fontWeight: FontWeight.w600,
                  color: primaryThree),
              unselectedLabelStyle: const TextStyle(
                  fontSize: 10,
                  fontFamily: 'AvenirNext',
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
              unselectedItemColor: Colors.black,
              selectedItemColor: primaryThree,
              showUnselectedLabels: true,
              onTap: (index) => setState(() => currentIndex = index),
              currentIndex: currentIndex,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: currentIndex == 0
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/home.svg',
                                color: primaryThree,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/home.svg',
                                color: secondaryColorfaded,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: currentIndex == 1
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/invoice.svg',
                                color: primaryThree,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/invoice.svg',
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        ),
                  label: 'New Invoice',
                ),
                BottomNavigationBarItem(
                  icon: currentIndex == 2
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/bill.svg',
                                color: primaryThree,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/bill.svg',
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        ),
                  label: 'New Bill',
                ),
                BottomNavigationBarItem(
                  icon: currentIndex == 3
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/invoicess.svg',
                                color: primaryThree,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/invoicess.svg',
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        ),
                  label: 'Invoices',
                ),
                BottomNavigationBarItem(
                  icon: currentIndex == 4
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/viewinvoice.svg',
                                color: primaryThree,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/viewinvoice.svg',
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        ),
                  label: 'View bills',
                ),
                BottomNavigationBarItem(
                  icon: currentIndex == 5
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/pay.svg',
                                color: primaryThree,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                'assets/icons/pay.svg',
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4)
                          ],
                        ),
                  label: 'Payments',
                ),
              ],
            ),
            body: getBody(),
          )
        : const Scaffold(
            body: Center(
              child: Center(
                child: CircularProgressIndicator(
                  color: primaryThree,
                  strokeWidth: 2,
                ),
              ),
            ),
          );
  }
}

class DashBoard extends StatefulWidget {
  const DashBoard(
      {Key? key,
      required this.name,
      required this.weeklyspots,
      required this.monthlyspots,
      required this.yearlyspots,
      required this.totalWeeklyBills,
      required this.totalWeeklyPays,
      required this.totalWeeklyInvoices,
      required this.totalWeeklyBillslength,
      required this.totalWeeklyPayslength,
      required this.totalWeeklyInvoiceslength,
      required this.totalMonthlyBills,
      required this.totalMonthlyPays,
      required this.totalMonthlyInvoices,
      required this.totalMonthlyBillslength,
      required this.totalMonthlyPayslength,
      required this.totalMonthlyInvoiceslength,
      required this.totalYearlyBills,
      required this.totalYearlyPays,
      required this.totalYearlyInvoices,
      required this.totalYearlyBillslength,
      required this.totalYearlyPayslength,
      required this.totalYearlyInvoiceslength})
      : super(key: key);
  final String name;
  final List<FlSpot> weeklyspots;
  final List<FlSpot> monthlyspots;
  final List<FlSpot> yearlyspots;
  final String totalWeeklyBills;
  final String totalWeeklyPays;
  final String totalWeeklyInvoices;
  final String totalWeeklyBillslength;
  final String totalWeeklyPayslength;
  final String totalWeeklyInvoiceslength;
  final String totalMonthlyBills;
  final String totalMonthlyPays;
  final String totalMonthlyInvoices;
  final String totalMonthlyBillslength;
  final String totalMonthlyPayslength;
  final String totalMonthlyInvoiceslength;
  final String totalYearlyBills;
  final String totalYearlyPays;
  final String totalYearlyInvoices;
  final String totalYearlyBillslength;
  final String totalYearlyPayslength;
  final String totalYearlyInvoiceslength;

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with TickerProviderStateMixin {
  final List<Color> gradientColors = [
    const Color(0xFF5BD271),
    const Color(0xFF5BD2AC)
  ];
  final List<Color> gradient2Colors = [
    const Color(0xFF5BD271),
    const Color(0xFFFFFFFF)
  ];
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 3, vsync: this);
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            BouncingWidget(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              },
              child: SizedBox(
                height: 35,
                width: 35,
                child: SvgPicture.asset(
                  'assets/icons/person.svg',
                ),
              ),
            ),
            SizedBox(
              width: width / 4,
            ),
            const Text(
              'Dashboard',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'AvenirNext',
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: <Widget>[
          PopupMenuButton(
            elevation: 2,
            icon: SizedBox(
              height: 25,
              width: 25,
              child: SvgPicture.asset(
                'assets/icons/threedots.svg',
                color: Colors.black,
              ),
            ),
            itemBuilder: (ctx) => [
              buildPopupMenuItem(context, 'Logout'),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              "Hello",
              style: TextStyle(
                color: Colors.black45,
                fontSize: 15,
                fontFamily: 'AvenirNext',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              widget.name,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontFamily: 'AvenirNext',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TabBar(
                labelColor: Colors.black,
                labelPadding: const EdgeInsets.only(left: 20, right: 20),
                isScrollable: true,
                unselectedLabelColor: Colors.grey,
                controller: tabController,
                indicator: const BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: primaryThree, width: 5)),
                ),
                tabs: const [
                  Tab(text: 'Week'),
                  Tab(text: 'Month'),
                  Tab(text: 'Year'),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: TabBarView(
              controller: tabController,
              children: [
                WeeklyAnalytics(
                  gradientColors: gradientColors,
                  width: width,
                  spots: widget.weeklyspots,
                  totalWeeklyBills: widget.totalWeeklyBills,
                  totalWeeklyBillslength: widget.totalWeeklyBillslength,
                  totalWeeklyInvoices: widget.totalWeeklyInvoices,
                  totalWeeklyInvoiceslength: widget.totalWeeklyInvoiceslength,
                  totalWeeklyPays: widget.totalWeeklyPays,
                  totalWeeklyPayslength: widget.totalWeeklyPayslength,
                ),
                MonthlyAnalytics(
                  gradientColors: gradientColors,
                  width: width,
                  monthlySpots: widget.monthlyspots,
                  totalMonthlyBills: widget.totalMonthlyBills,
                  totalMonthlyBillslength: widget.totalMonthlyBillslength,
                  totalMonthlyInvoices: widget.totalMonthlyInvoices,
                  totalMonthlyInvoiceslength: widget.totalMonthlyInvoiceslength,
                  totalMonthlyPays: widget.totalMonthlyPays,
                  totalMonthlyPayslength: widget.totalMonthlyPayslength,
                ),
                YearlyAnalytics(
                  gradientColors: gradientColors,
                  width: width,
                  yearlySpots: widget.yearlyspots,
                  totalYearlyBills: widget.totalYearlyBills,
                  totalYearlyBillslength: widget.totalYearlyBillslength,
                  totalYearlyInvoices: widget.totalYearlyInvoices,
                  totalYearlyInvoiceslength: widget.totalYearlyInvoiceslength,
                  totalYearlyPays: widget.totalYearlyPays,
                  totalYearlyPayslength: widget.totalYearlyPayslength,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WeeklyAnalytics extends StatelessWidget {
  const WeeklyAnalytics({
    Key? key,
    required this.gradientColors,
    required this.width,
    required this.spots,
    required this.totalWeeklyPays,
    required this.totalWeeklyBills,
    required this.totalWeeklyInvoices,
    required this.totalWeeklyPayslength,
    required this.totalWeeklyBillslength,
    required this.totalWeeklyInvoiceslength,
  }) : super(key: key);

  final List<Color> gradientColors;
  final double width;
  final List<FlSpot> spots;

  final String totalWeeklyPays;
  final String totalWeeklyBills;
  final String totalWeeklyInvoices;
  final String totalWeeklyPayslength;
  final String totalWeeklyBillslength;
  final String totalWeeklyInvoiceslength;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Transform.translate(
              offset: const Offset(-5.0, 10.0),
              child: LineChart(LineChartData(
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 6,
                  titlesData: WeeklyLineTitle.getTitleData(),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.transparent,
                          strokeWidth: 0,
                        );
                      },
                      drawVerticalLine: true,
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.black12,
                          strokeWidth: 1.5,
                        );
                      }),
                  lineBarsData: [
                    LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        colors: gradientColors,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                            show: true,
                            colors: gradientColors
                                .map((color) => color.withOpacity(0.1))
                                .toList())),
                  ])),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Total paid',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: Text(
                      'Ksh $totalWeeklyPays',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'BIlls',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: Text(
                      'Ksh $totalWeeklyBills',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Invoices',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: Text(
                      'Ksh $totalWeeklyInvoices',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Total paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 30,
                                      startDegreeOffset: -90,
                                      sections: int.parse(
                                                  totalWeeklyPayslength) ==
                                              0
                                          ? [
                                              PieChartSectionData(
                                                color: const Color(0xFF565AC9),
                                                value: 0.0,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                showTitle: false,
                                                value: 100.0,
                                                radius: 5,
                                              ),
                                            ]
                                          : [
                                              PieChartSectionData(
                                                color: const Color(0xFF565AC9),
                                                value: int.parse(
                                                        totalWeeklyPayslength) *
                                                    100 /
                                                    50,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                showTitle: false,
                                                value: 100 -
                                                    int.parse(
                                                            totalWeeklyPayslength) *
                                                        100 /
                                                        50,
                                                radius: 5,
                                              ),
                                            ]),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 2),
                                      Text(
                                        totalWeeklyPayslength,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Bills paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 30,
                                      startDegreeOffset: -90,
                                      sections: int.parse(
                                                  totalWeeklyBillslength) ==
                                              0
                                          ? [
                                              PieChartSectionData(
                                                color: const Color(0xFF4FA6C2),
                                                showTitle: false,
                                                value: 0.0,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                value: 100.0,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                            ]
                                          : [
                                              PieChartSectionData(
                                                color: const Color(0xFF4FA6C2),
                                                showTitle: false,
                                                value: int.parse(
                                                        totalWeeklyBillslength) *
                                                    100 /
                                                    50,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                value: 100 -
                                                    int.parse(
                                                            totalWeeklyBillslength) *
                                                        100 /
                                                        50,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                            ]),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 2),
                                      Text(
                                        totalWeeklyBillslength,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Invoice paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 30,
                                      startDegreeOffset: -90,
                                      sections: int.parse(
                                                  totalWeeklyInvoiceslength) ==
                                              0
                                          ? [
                                              PieChartSectionData(
                                                color: const Color(0xFF4FA6C2),
                                                showTitle: false,
                                                value: 0.00,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                value: 100.0,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                            ]
                                          : [
                                              PieChartSectionData(
                                                color: primaryThree,
                                                showTitle: false,
                                                value: int.parse(
                                                        totalWeeklyInvoiceslength) *
                                                    100 /
                                                    50,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                value: 100 -
                                                    int.parse(
                                                            totalWeeklyInvoiceslength) *
                                                        100 /
                                                        50,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                            ]),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 2),
                                      Text(
                                        totalWeeklyInvoiceslength,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MonthlyAnalytics extends StatelessWidget {
  const MonthlyAnalytics({
    Key? key,
    required this.gradientColors,
    required this.width,
    required this.monthlySpots,
    required this.totalMonthlyPays,
    required this.totalMonthlyBills,
    required this.totalMonthlyInvoices,
    required this.totalMonthlyPayslength,
    required this.totalMonthlyBillslength,
    required this.totalMonthlyInvoiceslength,
  }) : super(key: key);

  final List<Color> gradientColors;
  final double width;
  final List<FlSpot> monthlySpots;

  final String totalMonthlyPays;
  final String totalMonthlyBills;
  final String totalMonthlyInvoices;
  final String totalMonthlyPayslength;
  final String totalMonthlyBillslength;
  final String totalMonthlyInvoiceslength;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Transform.translate(
              offset: const Offset(-10.0, 2.0),
              child: LineChart(LineChartData(
                  minX: 0,
                  maxX: 12,
                  minY: 0,
                  maxY: 6,
                  titlesData: MonthlyLineTitle.getTitleData(),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.transparent,
                          strokeWidth: 0,
                        );
                      },
                      drawVerticalLine: true,
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.black12,
                          strokeWidth: 1.5,
                        );
                      }),
                  lineBarsData: [
                    LineChartBarData(
                        spots: monthlySpots,
                        isCurved: true,
                        colors: gradientColors,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                            show: true,
                            colors: gradientColors
                                .map((color) => color.withOpacity(0.1))
                                .toList())),
                  ])),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Total paid',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: Text(
                      'Ksh $totalMonthlyPays',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'BIlls',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: Text(
                      'Ksh $totalMonthlyBills',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Invoices',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: Text(
                      'Ksh $totalMonthlyInvoices',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Total paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 30,
                                      startDegreeOffset: -90,
                                      sections: int.parse(
                                                  totalMonthlyPayslength) ==
                                              0
                                          ? [
                                              PieChartSectionData(
                                                color: const Color(0xFF565AC9),
                                                value: 0.0,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                showTitle: false,
                                                value: 100.0,
                                                radius: 5,
                                              ),
                                            ]
                                          : [
                                              PieChartSectionData(
                                                color: const Color(0xFF565AC9),
                                                value: int.parse(
                                                        totalMonthlyPayslength) *
                                                    100 /
                                                    50,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                showTitle: false,
                                                value: 100 -
                                                    int.parse(
                                                            totalMonthlyPayslength) *
                                                        100 /
                                                        50,
                                                radius: 5,
                                              ),
                                            ]),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 2),
                                      Text(
                                        totalMonthlyPayslength,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Bills paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 30,
                                      startDegreeOffset: -90,
                                      sections: int.parse(
                                                  totalMonthlyBillslength) ==
                                              0
                                          ? [
                                              PieChartSectionData(
                                                color: const Color(0xFF4FA6C2),
                                                showTitle: false,
                                                value: 0.0,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                value: 100.0,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                            ]
                                          : [
                                              PieChartSectionData(
                                                color: const Color(0xFF4FA6C2),
                                                showTitle: false,
                                                value: int.parse(
                                                        totalMonthlyBillslength) *
                                                    100 /
                                                    50,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                value: 100 -
                                                    int.parse(
                                                            totalMonthlyBillslength) *
                                                        100 /
                                                        50,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                            ]),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 2),
                                      Text(
                                        totalMonthlyBillslength,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Invoice paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 30,
                                      startDegreeOffset: -90,
                                      sections: int.parse(
                                                  totalMonthlyInvoiceslength) ==
                                              0
                                          ? [
                                              PieChartSectionData(
                                                color: const Color(0xFF4FA6C2),
                                                showTitle: false,
                                                value: 0.00,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                value: 100.0,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                            ]
                                          : [
                                              PieChartSectionData(
                                                color: primaryThree,
                                                showTitle: false,
                                                value: int.parse(
                                                        totalMonthlyInvoiceslength) *
                                                    100 /
                                                    50,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                value: 100 -
                                                    int.parse(
                                                            totalMonthlyInvoiceslength) *
                                                        100 /
                                                        50,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                            ]),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 2),
                                      Text(
                                        totalMonthlyInvoiceslength,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class YearlyAnalytics extends StatelessWidget {
  const YearlyAnalytics({
    Key? key,
    required this.gradientColors,
    required this.width,
    required this.yearlySpots,
    required this.totalYearlyPays,
    required this.totalYearlyBills,
    required this.totalYearlyInvoices,
    required this.totalYearlyPayslength,
    required this.totalYearlyBillslength,
    required this.totalYearlyInvoiceslength,
  }) : super(key: key);

  final List<Color> gradientColors;
  final double width;
  final List<FlSpot> yearlySpots;

  final String totalYearlyPays;
  final String totalYearlyBills;
  final String totalYearlyInvoices;
  final String totalYearlyPayslength;
  final String totalYearlyBillslength;
  final String totalYearlyInvoiceslength;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Transform.translate(
              offset: const Offset(0.0, 2.0),
              child: LineChart(LineChartData(
                  minX: 0,
                  maxX: 12,
                  minY: 0,
                  maxY: 6,
                  titlesData: YearlyLineTitle.getTitleData(),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                      show: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.transparent,
                          strokeWidth: 0,
                        );
                      },
                      drawVerticalLine: true,
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.black12,
                          strokeWidth: 1.5,
                        );
                      }),
                  lineBarsData: [
                    LineChartBarData(
                        spots: yearlySpots,
                        isCurved: true,
                        colors: gradientColors,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                            show: true,
                            colors: gradientColors
                                .map((color) => color.withOpacity(0.1))
                                .toList())),
                  ])),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Total paid',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: Text(
                      'Ksh $totalYearlyPays',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'BIlls',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: Text(
                      'Ksh $totalYearlyBills',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: const Text(
                      'Invoices',
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    color: Colors.transparent,
                    width: 100,
                    child: Text(
                      'Ksh $totalYearlyInvoices',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'AvenirNext',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Total paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 30,
                                      startDegreeOffset: -90,
                                      sections: int.parse(
                                                  totalYearlyPayslength) ==
                                              0
                                          ? [
                                              PieChartSectionData(
                                                color: const Color(0xFF565AC9),
                                                value: 0.0,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                showTitle: false,
                                                value: 100.0,
                                                radius: 5,
                                              ),
                                            ]
                                          : [
                                              PieChartSectionData(
                                                color: const Color(0xFF565AC9),
                                                value: int.parse(
                                                        totalYearlyPayslength) *
                                                    100 /
                                                    50,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                showTitle: false,
                                                value: 100 -
                                                    int.parse(
                                                            totalYearlyPayslength) *
                                                        100 /
                                                        50,
                                                radius: 5,
                                              ),
                                            ]),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 2),
                                      Text(
                                        totalYearlyPayslength,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Bills paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 30,
                                      startDegreeOffset: -90,
                                      sections: int.parse(
                                                  totalYearlyBillslength) ==
                                              0
                                          ? [
                                              PieChartSectionData(
                                                color: const Color(0xFF4FA6C2),
                                                showTitle: false,
                                                value: 0.0,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                value: 100.0,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                            ]
                                          : [
                                              PieChartSectionData(
                                                color: const Color(0xFF4FA6C2),
                                                showTitle: false,
                                                value: int.parse(
                                                        totalYearlyBillslength) *
                                                    100 /
                                                    50,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                value: 100 -
                                                    int.parse(
                                                            totalYearlyBillslength) *
                                                        100 /
                                                        50,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                            ]),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 2),
                                      Text(
                                        totalYearlyBillslength,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BouncingWidget(
                onPressed: () {},
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        width: 100,
                        child: const Center(
                          child: Text(
                            'Invoice paid',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'AvenirNext',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Center(
                        child: SizedBox(
                          width: 80,
                          child: SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PieChart(
                                  PieChartData(
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 30,
                                      startDegreeOffset: -90,
                                      sections: int.parse(
                                                  totalYearlyInvoiceslength) ==
                                              0
                                          ? [
                                              PieChartSectionData(
                                                color: const Color(0xFF4FA6C2),
                                                showTitle: false,
                                                value: 0.00,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                value: 100.0,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                            ]
                                          : [
                                              PieChartSectionData(
                                                color: primaryThree,
                                                showTitle: false,
                                                value: int.parse(
                                                        totalYearlyInvoiceslength) *
                                                    100 /
                                                    50,
                                                radius: 5,
                                              ),
                                              PieChartSectionData(
                                                color: const Color(0xFFE2F2E7),
                                                value: 100 -
                                                    int.parse(
                                                            totalYearlyInvoiceslength) *
                                                        100 /
                                                        50,
                                                showTitle: false,
                                                radius: 5,
                                              ),
                                            ]),
                                ),
                                Positioned.fill(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 2),
                                      Text(
                                        totalYearlyInvoiceslength,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontFamily: 'AvenirNext',
                                            fontWeight: FontWeight.w900),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DataItem {
  int x;
  double y1;
  double y2;
  double y3;
  DataItem(
      {required this.x, required this.y1, required this.y2, required this.y3});
}

PopupMenuItem buildPopupMenuItem(context, String title) {
  return PopupMenuItem(
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      },
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: secondaryColor,
              fontFamily: 'AvenirNext',
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    ),
  );
}
