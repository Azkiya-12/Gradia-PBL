import 'package:flutter_test/flutter_test.dart';
import 'package:dosen/main.dart';

void main() {
  testWidgets('Gradia menampilkan halaman login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GradiaApp());

    expect(find.text('Gradia'), findsOneWidget);
    expect(find.text('Selamat Datang!'), findsOneWidget);
    expect(find.text('Masuk ke Portal Dosen →'), findsOneWidget);
  });
}