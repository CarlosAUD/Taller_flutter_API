import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemonapi/main.dart';  

void main() {
  testWidgets('Smoke test del contador', (WidgetTester tester) async {
    // Construir la aplicación y disparar un frame
    await tester.pumpWidget(const MyApp());

    // Verificar que el texto 'Hello, world!' se encuentra en la pantalla
    expect(find.text('Hello, world!'), findsOneWidget);
    expect(find.text('Counter: 0'), findsNothing);  // Solo si tienes un contador

    // Agregar más interacciones o verificaciones si es necesario
  });
}
