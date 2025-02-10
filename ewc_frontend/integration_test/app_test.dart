import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:ewc/main.dart' as ewc_app;
import 'package:ewc/screens/login/login.dart';
import 'package:ewc/screens/login/forgot_password.dart';
import 'package:ewc/services/auth_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration Tests', () {
    testWidgets('1) App starts and shows SplashPage', (WidgetTester tester) async {
      ewc_app.main();
      await tester.pumpAndSettle();

      // SplashPage 코드에서 "Splash Screen" 텍스트가 노출된다고 가정
      expect(find.text('Splash Screen'), findsOneWidget);

      // 여기서 Splash → Login 자동 전환 로직이 없다면,
      // 실제 앱 코드에 전환을 구현해야 이 테스트가 더 진행될 수 있습니다.
      // ex) await tester.pump(const Duration(seconds: 3));
      //     expect(find.text('Welcome Back!'), findsOneWidget);
    });

    testWidgets('2) Login → Forgot Password flow', (WidgetTester tester) async {
      // 로그인 화면만 따로 띄우기 위해, runApp 으로 직접 MaterialApp 래핑
      final authService = AuthService();
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(authService: authService),
        ),
      );

      // 모든 프레임 빌드
      await tester.pumpAndSettle();

      // 로그인 페이지에서 "Welcome Back!" 텍스트가 보이는지 검사
      expect(find.text("Welcome Back!"), findsOneWidget);

      // "Forgot Password?" 링크 찾고 탭
      final forgotLinkFinder = find.text("Forgot Password?");
      expect(forgotLinkFinder, findsOneWidget);

      await tester.tap(forgotLinkFinder);
      await tester.pumpAndSettle();

      // ForgotPassword 화면에 진입했을 때 "Reset your password!" 텍스트 확인
      expect(find.text("Reset your password!"), findsOneWidget);

      // 비밀번호 필드가 보이지 않다가 "Reset Password" 버튼 누르면
      // setState로 isVisible = true 가 되도록 되어 있음
      // initial: isVisible = false -> passwordField가 안 보임
      // "Reset Password" 버튼(로그 상 "Reset Password" 텍스트가 있는 LoginButton)
      final resetButtonFinder = find.text("Reset Password");
      expect(resetButtonFinder, findsOneWidget);

      // 탭하면 setState -> password 필드가 보이는지 확인
      await tester.tap(resetButtonFinder);
      await tester.pumpAndSettle();

      // 이제 passwordField가 등장했는지 (hintText: "Password")
      expect(find.byKey(const Key("passwordField")), findsOneWidget);
    });
  });
}