import 'package:bamboo/utils/toleg_pay.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Toleg response requires every usable payment URL', () {
    expect(TolegPayment.tryParse({'payment_method': 'toleg'}), isNull);
    expect(
      TolegPayment.tryParse({
        'payment_method': 'toleg',
        'payment_url': 'toleg://pay/123',
        'status_url': 'http://example.test/status',
        'refresh_url': 'https://example.test/refresh',
      }),
      isNull,
    );
    expect(TolegPayment.tryParse({'payment_method': 'cash'}), isNull);

    final payment = TolegPayment.tryParse({
      'payment_method': 'toleg',
      'payment_url': 'toleg://pay/123',
      'status_url': 'https://example.test/status',
      'refresh_url': 'https://example.test/refresh',
    });
    expect(payment, isNotNull);
    expect(payment!.paymentUrl, 'toleg://pay/123');
  });
}
