import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blue_cute_calculator/main.dart';

void main() {
  testWidgets('计算器：1+1 等于 2', (WidgetTester tester) async {
    await tester.pumpWidget(const BlueCalculatorApp());

    await tester.tap(find.text('1'));
    await tester.pump();
    await tester.tap(find.text('+'));
    await tester.pump();
    await tester.tap(find.text('1'));
    await tester.pump();
    await tester.tap(find.text('等于'));
    await tester.pump();

    final display = tester.widget<Text>(
      find.byKey(const ValueKey<String>('calc_display')),
    );
    expect(display.data, '2');
  });
}
