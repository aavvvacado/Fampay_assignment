// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:fampay_assignment/main.dart';
import 'package:dio/dio.dart';
import 'package:fampay_assignment/core/repository/cards_repository.dart';
import 'package:fampay_assignment/core/models/api_response.dart';
import 'package:fampay_assignment/core/models/card_group.dart';
import 'package:fampay_assignment/core/models/card_model.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    
    
    

  await tester.pumpWidget(MyApp(repository: FakeRepository()));
    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}


class FakeRepository extends CardsRepository {
  FakeRepository() : super(Dio());

  @override
  Future<ApiResponse> fetchCards() async {
    // Return dummy data for testing
    return ApiResponse(hcGroups: [
      CardGroup(
        id: 1,
        designType: 'test',
        cards: [
          CardModel(id: 1),
        ],
        isScrollable: false,
        height: 100.0,
      ),
    ]);
  }
}
