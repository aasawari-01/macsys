import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class ApiClient {
  // Google Map Key  AIzaSyCOGis4giHCz4aAEkFfOH5UaDlISRP9i4s
  static bool role = false;
  static bool roleisMSupervisor = false;
  static int drawerFlag = 0;
  static final box = GetStorage();
  static final gs = GetStorage();

  static String splitDate(dateT) {
    final moonLanding = DateTime.parse(dateT);

    return "${moonLanding.day} ${DateFormat.MMM().format(moonLanding)} ${moonLanding.year}";
  }

  static String convertDate(dateT) {
    final moonLanding = DateTime.parse(dateT);
    return "${moonLanding.day} ${DateFormat.MMM().format(moonLanding)} ${moonLanding.year}";
  }

  static String currentDate(dateT) {
    final moonLanding = DateTime.parse(dateT);

    return "${moonLanding.year}-${moonLanding.month}-${moonLanding.day}";
  }

  static String convertCurrDate(dateT) {
    final moonLanding = DateTime.parse(dateT);
    String day =
        moonLanding.day < 10 ? "0${moonLanding.day}" : "${moonLanding.day}";
    String month = moonLanding.month < 10
        ? "0${moonLanding.month}"
        : "${moonLanding.month}";
    return "${moonLanding.year}-$month-$day";
  }

  static String convertTime(dateT) {
    final moonLanding = DateTime.parse(dateT);
    return DateFormat("hh:mm a").format(moonLanding);
  }

  static String TimeDifference(sTime, eTime, int daysAgo) {
    final s = DateTime.parse(sTime.toString());
    final e = DateTime.parse(eTime.toString());
    print("e===$e\n");
    print("e===$s\n");
    if (daysAgo > 0) {
      // Subtract daysAgo days from both start and end times

      s.subtract(Duration(days: daysAgo));
      e.subtract(Duration(days: daysAgo));
      print("object$s");
      print("object$e");
    }
    var format = DateFormat("HH:mm"); // 2023-10-09 16:58:00.000
    var one = format.parse("${DateFormat("HH:mm").format(s)}");
    var two = format.parse("${DateFormat("HH:mm").format(e)}");
    print("HERE::${(two.difference(one))}");
    print("HERE::${(two.difference(two))}");

    final splitted = "${two.difference(one)}".substring(0, 5).split(':');
    // print("$splitted");
    print("HERE@ : $splitted");
    return "${splitted[0]}:${splitted[1]}";
  }

  static bool checkBalance(balance) {
    int amount = int.parse(balance.toString());
    if (amount >= 100) {
      return false;
    } else {
      return true;
    }
  }

  static twoDateDifference(DateTime fromDate, DateTime toDate) {
    Duration diff = toDate.difference(fromDate);
    print("fromDate  :: $fromDate");
    print("toDate  :: $toDate");
    print("diff.inDays  :: ${diff.inDays}");
    print("diff.inDays  :: ${diff.inDays}");
    return diff.inDays;
  }

  static stringDateFormat(stringDate) {
    List<String> substrings = stringDate.split("-");
    // print("substrings  : $substrings");
    //DateTime.parse('10-10-2001 00:00:00')

    return "${substrings[2]}-${substrings[1]}-${substrings[0]}";
  }

  static stringDateFormatT(strDate) {
    var stringDate = strDate.substring(0, 10);
    List<String> substrings = stringDate.split("-");
    // print("substrings  : $substrings");
    //DateTime.parse('10-10-2001 00:00:00')

    return "${substrings[2]}-${substrings[1]}-${substrings[0]}";
  }
}
