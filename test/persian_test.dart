import 'package:test/test.dart';
import 'package:persian/persian.dart';

void main() {
  test('Conversion Tests.', () {
    final p0 = PersianDate.fromDateTime(DateTime(2021, 5, 8));
    expect(p0.year, 1400);
    expect(p0.month, 2);
    expect(p0.day, 18);

    final p1 = PersianDate.fromDateTime(DateTime(2025, 10, 17));

    expect(p1.year, 1404);
    expect(p1.month, 7);
    expect(p1.day, 25);

    final p2 = PersianDate.fromDateTime(DateTime(1986, 3, 31));
    expect(p2.year, 1365);
    expect(p2.month, 1);
    expect(p2.day, 11);

    final p3 = PersianDate.fromDateTime(DateTime(2025, 10, 22));
    expect(p3.year, 1404);
    expect(p3.month, 7);
    expect(p3.day, 30);

    final p4 = p3.toDateTime();
    expect(p4.year, 2025);
    expect(p4.month, 10);
    expect(p4.day, 22);
  });
}
