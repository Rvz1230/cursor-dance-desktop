import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'package:cursor_dance_desktop/widgets/controls/control_slider.dart';

void main() {
  testWidgets('ControlSlider renders label and slider', (tester) async {
    double value = 42;

    await tester.pumpWidget(
      MaterialApp(
        home: ShadApp(
          home: Scaffold(
            body: ControlSlider(
              label: '测试滑块',
              value: value,
              min: 0,
              max: 100,
              onChanged: (v) => value = v,
            ),
          ),
        ),
      ),
    );

    // Check label is rendered
    expect(find.text('测试滑块'), findsOneWidget);
  });

  testWidgets('ControlSlider displays suffix', (tester) async {
    double value = 50;

    await tester.pumpWidget(
      MaterialApp(
        home: ShadApp(
          home: Scaffold(
            body: ControlSlider(
              label: '尺寸',
              value: value,
              min: 0,
              max: 200,
              suffix: 'px',
              onChanged: (v) => value = v,
            ),
          ),
        ),
      ),
    );

    expect(find.text('px'), findsOneWidget);
  });
}
