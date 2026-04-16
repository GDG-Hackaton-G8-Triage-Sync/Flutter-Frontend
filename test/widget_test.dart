import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_frontend/app.dart';

void main() {
  testWidgets('App starts at login route', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TriageSyncApp()));
    await tester.pumpAndSettle();

    expect(find.text('Login Screen'), findsOneWidget);
  });
}
