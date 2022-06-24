import 'package:fl_chart/fl_chart.dart';

class WeeklyLineTitle {
  static getTitleData() => FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        // getTextStyles: (value) => const TextStyle(
        //   color: Color(0xff68737d),
        //   fontWeight: FontWeight.bold,
        //   fontSize: 16,
        // ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 0:
              return 'M';
            case 1:
              return 'T';
            case 2:
              return 'W';
            case 3:
              return 'T';
            case 4:
              return 'F';
            case 5:
              return 'S';
            case 6:
              return 'S';
          }
          return '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return '2k';
              case 4:
                return '5k';
              case 6:
                return '10k';
            }
            return '';
          }));
}

class MonthlyLineTitle {
  static getTitleData() => FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        // getTextStyles: (value) => const TextStyle(
        //   color: Color(0xff68737d),
        //   fontWeight: FontWeight.bold,
        //   fontSize: 16,
        // ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 0:
              return 'JAN';
            case 1:
              return '';
            case 2:
              return '';
            case 3:
              return 'APR';
            case 4:
              return '';
            case 5:
              return '';
            case 6:
              return '';
            case 7:
              return 'AUG';
            case 8:
              return '';
            case 9:
              return '';
            case 10:
              return '';
            case 11:
              return 'DEC';
          }
          return '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return '2k';
              case 4:
                return '5k';
              case 6:
                return '10k';
            }
            return '';
          }));
}

class YearlyLineTitle {
  static getTitleData() => FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 22,
        // getTextStyles: (value) => const TextStyle(
        //   color: Color(0xff68737d),
        //   fontWeight: FontWeight.bold,
        //   fontSize: 16,
        // ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 0:
              return '2010';
            case 1:
              return '';
            case 2:
              return '';
            case 3:
              return '2014';
            case 4:
              return '';
            case 5:
              return '';
            case 6:
              return '';
            case 7:
              return '2018';
            case 8:
              return '';
            case 9:
              return '';
            case 10:
              return '';
            case 11:
              return '2022';
          }
          return '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return '2k';
              case 4:
                return '5k';
              case 6:
                return '10k';
            }
            return '';
          }));
}
