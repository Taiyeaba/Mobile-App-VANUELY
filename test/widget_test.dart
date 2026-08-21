import 'package:flutter_test/flutter_test.dart';

import 'package:venuely_app/main.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    await tester.pumpWidget(const VenuelyApp());
    expect(find.byType(VenuelyApp), findsOneWidget);
  });
}
