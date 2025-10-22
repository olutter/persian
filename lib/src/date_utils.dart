import '../persian.dart';

/// Converts a Gregorian date to Persian.
PersianDate toPersian(int gregorianYear, int gregorianMonth, int gregorianDay) {
  return d2J(g2D(gregorianYear, gregorianMonth, gregorianDay));
}

/// Converts a [PersianDate] to Gregorian.
DateTime toGregorian(int persianYear, int persianMonth, int persianDay) {
  return d2G(j2D(persianYear, persianMonth, persianDay));
}

/// EMP.
class EMP {
  /// Constructor.
  const EMP(this.leap, this.gregorianYear, this.march);

  /// Leap.
  final int leap;

  /// Year.
  final int gregorianYear;

  /// March.
  final int march;
}

/// This function determines if the Persian (Persian) year is
/// leap (366-day long) or is the common year (365 days), and
/// finds the day in march (Gregorian calendar) of the first
/// day of the Persian year (persianYear).
/*
     @param persianYear Persian calendar year (-61 to 3177)
     @return
     leap: number of years since the last leap year (0 to 4)
     gregorianYear: Gregorian year of the beginning of Persian year
     march: the march day of Farvardin the 1st (1st day of persianYear)
     @see: http://www.astro.uni.torun.pl/~kb/Papers/EMP/PersianC-EMP.htm
     @see: http://www.fourmilab.ch/documents/calendar/
     */
EMP? persianCalendar(int persianYear) {
  // Persian years starting the 33-year rule.
  const breaks = [
    -61,
    9,
    38,
    199,
    426,
    686,
    756,
    818,
    1111,
    1181,
    1210,
    1635,
    2060,
    2097,
    2192,
    2262,
    2324,
    2394,
    2456,
    3178,
  ];
  final bl = breaks.length;
  final gregorianYear = persianYear + 621;
  int leapJ = -14;

  int jp = breaks[0];
  int jump = 1;

  // persianMonth: number,
  // leap: number,
  // n: number,
  // i: number;

  if (persianYear < jp || persianYear >= breaks[bl - 1]) {
    return null;
  }

  // Find the limiting years for the Persian year persianYear.
  for (int i = 1; i < bl; i += 1) {
    final persianMonth = breaks[i];
    final jump = persianMonth - jp;

    if (persianYear < persianMonth) {
      break;
    }

    leapJ = leapJ + div(jump, 33) * 8 + div(mod(jump, 33), 4);
    jp = persianMonth;
  }
  var n = persianYear - jp;

  // Find the number of leap years from AD 621 to the beginning
  // of the current Persian year in the Persian calendar.
  leapJ = leapJ + div(n, 33) * 8 + div(mod(n, 33) + 3, 4);
  if (mod(jump, 33) == 4 && jump - n == 4) {
    leapJ += 1;
  }

  // And the same in the Gregorian calendar (until the year gregorianYear).
  final leapG =
      div(gregorianYear, 4) - div((div(gregorianYear, 100) + 1) * 3, 4) - 150;

  // Determine the Gregorian date of Farvardin the 1st.
  final march = 20 + leapJ - leapG;

  // Find how many years have passed since the last leap year.
  if (jump - n < 6) {
    n = n - jump + div(jump + 4, 33) * 33;
  }
  var leap = mod(mod(n + 1, 33) - 1, 4);
  if (leap == -1) leap = 4;

  return EMP(leap, gregorianYear, march);
}

/// Converts a date of the Persian calendar to the Julian day number.
/*
 
     @param persianYear Persian year (1 to 3100)
     @param persianMonth Persian month (1 to 12)
     @param persianDay Persian day (1 to 29/31)
     @return Julian day number
     */
int j2D(int persianYear, int persianMonth, int persianDay) {
  final r = persianCalendar(persianYear)!;

  return g2D(r.gregorianYear, 3, r.march) +
      (persianMonth - 1) * 31 -
      div(persianMonth, 7) * (persianMonth - 7) +
      persianDay -
      1;
}

/*
 
     @param jdn Julian day number
     @return
     persianYear: Persian year (1 to 3100)
     persianMonth: Persian month (1 to 12)
     persianDay: Persian day (1 to 29/31)
     */
/// Converts the Julian day number to a date in the Persian calendar.
PersianDate d2J(int jdn) {
  final gregorianYear = d2G(jdn).year;
  var persianYear = gregorianYear - 621;
  final r = persianCalendar(persianYear)!;
  final jdn1F = g2D(gregorianYear, 3, r.march);

  // Find number of days that passed since 1 Farvardin.
  var k = jdn - jdn1F;
  if (k >= 0) {
    if (k <= 185) {
      // The first 6 months.
      final persianMonth = 1 + div(k, 31);
      final persianDay = mod(k, 31) + 1;
      return PersianDate(persianYear, persianMonth, persianDay);
    } else {
      // The remaining months.
      k -= 186;
    }
  } else {
    // Previous Persian year.
    persianYear -= 1;
    k += 179;
    if (r.leap == 1) k += 1;
  }
  final persianMonth = 7 + div(k, 30);
  final persianDay = mod(k, 30) + 1;
  return PersianDate(persianYear, persianMonth, persianDay);
}

/// Converts the Julian day number from Gregorian or Julian
/// calendar dates. This integer number corresponds to the noon of
/// the date (i.e. 12 hours of Universal Time).
/// The procedure was tested to be good since 1 march, -100100 (of both
/// calendars) up to a few million years into the future.

/*
     @param gregorianYear Calendar year (years BC numbered 0, -1, -2, ...)
     @param gregorianMonth Calendar month (1 to 12)
     @param gregorianDay Calendar day of the month (1 to 28/29/30/31)
     @return Julian day number
     */
int g2D(int gregorianYear, int gregorianMonth, int gregorianDay) {
  final d1 =
      div((gregorianYear + div(gregorianMonth - 8, 6) + 100100) * 1461, 4) +
          div(153 * mod(gregorianMonth + 9, 12) + 2, 5) +
          gregorianDay -
          34840408;

  final d2 = div(
    div(gregorianYear + 100100 + div(gregorianMonth - 8, 6), 100) * 3,
    4,
  );

  return d1 - d2 + 752;
}

/*
 
     @param jdn Julian day number
     @return
     gregorianYear: Calendar year (years BC numbered 0, -1, -2, ...)
     gregorianMonth: Calendar month (1 to 12)
     gregorianDay: Calendar day of the month M (1 to 28/29/30/31)
     */

/// Converts Gregorian and Julian calendar dates from the Julian day number
/// (jdn) for the period since jdn=-34839655 (i.e. the year -100100 of both
/// calendars) to some millions years ahead of the present.
DateTime d2G(int jdn) {
  var j = 4 * jdn + 139361631;
  j = j + div(div(4 * jdn + 183187720, 146097) * 3, 4) * 4 - 3908;
  final i = div(mod(j, 1461), 4) * 5 + 308;

  final gregorianDay = div(mod(i, 153), 5) + 1;
  final gregorianMonth = mod(div(i, 153), 12) + 1;
  final gregorianYear = div(j, 1461) - 100100 + div(8 - gregorianMonth, 6);

  return DateTime(gregorianYear, gregorianMonth, gregorianDay);
}

/*
     Utility helper functions.
     */

/// Divide.
int div(int a, int b) {
  return a ~/ b;
}

/// Mod.
int mod(int a, int b) {
  return a % b;
}
