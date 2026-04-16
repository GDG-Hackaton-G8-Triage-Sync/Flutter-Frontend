import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_frontend/app.dart';

void main() {
  testWidgets('Theme preview renders', (WidgetTester tester) async {
    await tester.pumpWidget(const FrontendApp());
    await tester.pumpAndSettle();

    expect(find.text('Design System Ready'), findsOneWidget);
    expect(find.text('Theme tokens applied.'), findsOneWidget);
  });
}
