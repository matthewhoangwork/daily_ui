import 'package:daily_ui/daily_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ChunkyButton tap goi onPressed', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChunkyButton(onPressed: () => tapped++, label: 'Hoc'),
        ),
      ),
    );
    await tester.tap(find.text('Hoc'));
    expect(tapped, 1);
  });

  testWidgets('ChunkyButton null onPressed = mo, khong bam duoc', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ChunkyButton(onPressed: null, label: 'Khoa')),
      ),
    );
    await tester.tap(find.text('Khoa'));
    expect(find.byType(Opacity), findsOneWidget);
  });

  testWidgets('AppCard + Pill render dung noi dung', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppCard(child: Pill('Bai hom nay')),
        ),
      ),
    );
    expect(find.text('Bai hom nay'), findsOneWidget);
  });
}
