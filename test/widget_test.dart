// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// Flutter imports:

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // // Build our app and trigger a frame.
    // await tester.pumpWidget(const MyApp());

    // // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);

    int space1 = 5;
    int space2 = 0;
    int space3 = 5;
    int space4 = 5;
    int space5 = 0;
    int space6 = 5;
    for (var i = 0; i < 17; i++) {
      String lineContent = "";
      lineContent += " " * space1;
      lineContent += "#";
      lineContent += " " * space2;
      if (space3 + space4 >= 0) {
        lineContent += "#";
        lineContent += " " * space3;
        lineContent += " " * space4;
        lineContent += "#";
      }
      lineContent += " " * space5;
      lineContent += "#";
      lineContent += " " * space6;
      if (space3 + space4 == 0) {
        space2++;
        space5++;
      }
      if (space3 + space4 > 0) {
        space1--;
        space2 += 2;
        space3--;
        space4--;
        space5 += 2;
        space6--;
      } else {
        space1++;
        space2--;
        space3--;
        space4--;
        space5--;
        space6++;
      }
      print(lineContent);
    }
  });
}
