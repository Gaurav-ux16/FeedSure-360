import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feedsure360_app/main.dart';

void main() {
  testWidgets('FeedSure 360 App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: FeedSure360App(),
      ),
    );

    expect(find.text('FeedSure 360'), findsWidgets);
  });
}
