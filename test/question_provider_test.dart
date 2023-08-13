// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:quizapp/main.dart';
import 'package:quizapp/providers/questions_provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  QuestionsProvider questionsProvider=QuestionsProvider();


  setUp(() {
    questionsProvider = QuestionsProvider();
  });

  group('increase points', () {


    test('dont increase points ', () {
      expect(0, questionsProvider.points);
    });

    test('increase points 4 times', () {
      questionsProvider.increasePoints();
      questionsProvider.increasePoints();
      questionsProvider.increasePoints();
      questionsProvider.increasePoints();
      expect(4, questionsProvider.points);
    });
  });

  group('timer tests', () {

    test('Starting the timer', () {
      questionsProvider.startTimer();
      expect(true, questionsProvider.timer!.isActive);
    });


    test('timer count 10  seconds', () async {
      questionsProvider.startTimer();

      await Future.delayed(const Duration(seconds: 11));
      expect(0.0, questionsProvider.percent);
    });
  });



}
