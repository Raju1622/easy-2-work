import 'package:flutter_test/flutter_test.dart';

import 'package:easy2work/main.dart';

void main() {
  testWidgets('App loads and shows Easy 2 Work title', (WidgetTester tester) async {
    await tester.pumpWidget(const Easy2WorkApp());

    expect(find.text('Easy 2 Work'), findsAtLeastNWidgets(1));
  });
}
