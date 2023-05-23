String fromTimeToString(DateTime time) {
  return '${hTOhh_24hTrue(time.hour)}:${mTOmm(time.minute)}';
}

String fromWeekdayToString(int weekday) {
  switch (weekday) {
    case 1:
      return 'Senin';
    case 2:
      return 'Selasa';
    case 3:
      return 'Rabu';
    case 4:
      return 'Kamis';
    case 5:
      return 'Jumat';
    case 6:
      return 'Sabtu';
    case 7:
      return 'Minggu';
    default:
      return '';
  }
}

String fromWeekdayToStringShort(int weekday) {
  switch (weekday) {
    case 1:
      return 'Sen';
    case 2:
      return 'Sel';
    case 3:
      return 'Rab';
    case 4:
      return 'Kam';
    case 5:
      return 'Jum';
    case 6:
      return 'Sab';
    case 7:
      return 'Min';
    default:
      return '';
  }
}

String hTOhh_24hTrue(int hour) {
  late String sHour;
  if (hour < 10) {
    sHour = '0$hour';
  } else {
    sHour = '$hour';
  }
  return sHour;
}

List<String> hTOhh_24hFalse(int hour) {
  late String sHour;
  late String h12State;
  final times = <String>[];
  if (hour < 10) {
    sHour = '0$hour';
    h12State = 'AM';
  } else if (hour > 9 && hour < 13) {
    sHour = '$hour';
    h12State = 'AM';
  } else if (hour > 12 && hour < 22) {
    sHour = '0${hour % 12}';
    h12State = 'PM';
  } else if (hour > 21) {
    sHour = '${hour % 12}';
    h12State = 'PM';
  }
  times.add(sHour);
  times.add(h12State);
  return times;
}

String mTOmm(int minute) {
  late String sMinute;
  if (minute < 10) {
    sMinute = '0$minute';
  } else {
    sMinute = '$minute';
  }
  return sMinute;
}

String sTOss(int second) {
  late String sSecond;
  if (second < 10) {
    sSecond = '0$second';
  } else {
    sSecond = '$second';
  }
  return sSecond;
}
