part of '../persian.dart';

/// Persian extension utilities for Integers.
extension IntExtensions on int {
  /// Converts an integer into a human-readable text.
  String toPersianString({String separator = ' و '}) {
    return _toPersianString(this, separator);
  }
}

final _tensNames = [
  '',
  'ده',
  'بیست',
  'سی',
  'چهل',
  'پنجاه',
  'شصت',
  'هفتاد',
  'هشتاد',
  'نود'
];

final _numNames = [
  '',
  'یک',
  'دو',
  'سه',
  'چهار',
  'پنج',
  'شش',
  'هفت',
  'هشت',
  'نه',
  'ده',
  'یازده',
  'دوازده',
  'سیزده ',
  'چهارده',
  'پانزده',
  'شانزده',
  'هفده',
  'هجده',
  'نوزده'
];

final _hundredNames = [
  'صد',
  'دویست',
  'سیصد',
  'چهارصد',
  'پانصد',
  'ششصد',
  'هفتصد',
  'هشتصد',
  'نهصد'
];

List<String> _convertLessThanOneThousand(int number) {
  int n = number;
  final parts = <String>[];

  if (n % 100 < 20) {
    final mod = n % 100;
    if (mod != 0) {
      parts.add(_numNames[mod]);
    }
    n ~/= 100;
  } else {
    final mod0 = n % 10;
    if (mod0 != 0) {
      parts.add(_numNames[mod0]);
    }
    n ~/= 10;
    final mod1 = n % 10;
    if (mod1 != 0) {
      parts.add(_tensNames[mod1]);
    }
    n ~/= 10;
  }
  if (n > 0) {
    parts.add(_hundredNames[n - 1]);
  }

  return parts.reversed.toList();
}

String _toPersianString(int number, String separator) {
  if (number == 0) {
    return 'صفر';
  }

  final parts = <String>[];

  final sNumber = number.toString().padLeft(12, '0');
  final billions = int.parse(sNumber.substring(0, 3));
  final millions = int.parse(sNumber.substring(3, 6));
  final hundredThousands = int.parse(sNumber.substring(6, 9));
  final thousands = int.parse(sNumber.substring(9, 12));

  if (billions != 0) {
    final b = _convertLessThanOneThousand(billions).join(separator);
    parts.add('$b میلیارد');
  }

  if (millions > 0) {
    final m = _convertLessThanOneThousand(millions).join(separator);
    parts.add('$m میلیون');
  }

  if (hundredThousands > 0) {
    final t = _convertLessThanOneThousand(hundredThousands).join(separator);
    if (t.isNotEmpty) {
      parts.add('$t هزار');
    }
  }

  final s = _convertLessThanOneThousand(thousands);
  if (s.isNotEmpty) {
    parts.add(s.join(separator));
  }

  final result = parts.join(separator);
  return result;
}
