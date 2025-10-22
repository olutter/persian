part of '../persian.dart';

/// An instant in Persian calendar, such as Farvardin 11, 1365.
class PersianDate {
  /// Creates a [PersianDate] from the Persian year, month and day.
  ///
  /// Example: PersianDate(1400, 12, 29);
  const PersianDate(this.year, this.month, this.day);

  /// Creates a [PersianDate] from the equivalent [DateTime].
  factory PersianDate.fromDateTime(DateTime date) {
    return toPersian(date.year, date.month, date.day);
  }

  /// Constructs a new [PersianDate] instance
  /// with the given [millisecondsSinceEpoch].
  ///
  /// If [isUtc] is false then the date is in the local time zone.
  ///
  /// The constructed [PersianDate] represents
  /// 1970-01-01T00:00:00Z + [millisecondsSinceEpoch] ms in the given
  /// time zone (local or UTC).
  ///
  factory PersianDate.fromMillisecondsSinceEpoch(
    int millisecondsSinceEpoch, {
    bool isUtc = false,
  }) =>
      PersianDate.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch,
            isUtc: isUtc),
      );

  /// Constructs a new [PersianDate] instance
  /// with the given [microsecondsSinceEpoch].
  ///
  /// If [isUtc] is false then the date is in the local time zone.
  ///
  /// The constructed [PersianDate] represents
  /// 1970-01-01T00:00:00Z + [microsecondsSinceEpoch] us in the given
  /// time zone (local or UTC).
  factory PersianDate.fromMicrosecondsSinceEpoch(
    int microsecondsSinceEpoch, {
    bool isUtc = false,
  }) =>
      PersianDate.fromDateTime(
        DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch,
            isUtc: isUtc),
      );

  /// The Year.
  final int year;

  /// The Month.
  final int month;

  /// The Day.
  final int day;

  /// Converts this [PersianDate] instance to a [DateTime].
  DateTime toDateTime() {
    return toGregorian(year, month, day);
  }

  /// Checks whether a Persian date is valid or not.
  static bool isValidPersianDate(
      int persianYear, int persianMonth, int persianDay) {
    return persianYear >= -61 &&
        persianYear <= 3177 &&
        persianMonth >= 1 &&
        persianMonth <= 12 &&
        persianDay >= 1 &&
        persianDay <= getDaysInPersianMonth(persianYear, persianMonth);
  }

  /// Get the number of days in a Persian year.
  static int getDaysInPersianYear(int persianYear) {
    if (isLeapPersianYear(persianYear)) {
      return 366;
    }

    return 365;
  }

  /// Number of days in a given month in a Persian year.
  static int getDaysInPersianMonth(int persianYear, int persianMonth) {
    if (persianMonth < 7) {
      return 31;
    }
    if (persianMonth < 12) {
      return 30;
    }
    if (isLeapPersianYear(persianYear)) {
      return 30;
    }

    return 29;
  }

  /// Is this a leap year or not?
  static bool isLeapPersianYear(int persianYear) {
    return persianCalendar(persianYear)!.leap == 0;
  }

  @override
  String toString() {
    return '$year/${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}'
        .withPersianNumbers();
  }
}
