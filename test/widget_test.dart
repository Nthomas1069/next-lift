import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:next_lift/app/app_shell.dart';

void main() {
  testWidgets('App shell renders onboarding title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: NextLiftAppShell(),
      ),
    );

    expect(find.text('Welcome'), findsOneWidget);
  });
}
