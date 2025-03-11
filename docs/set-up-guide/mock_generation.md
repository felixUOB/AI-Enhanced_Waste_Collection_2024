Create a Test File & Define Mocks
In your test file (mocks.dart), import the necessary packages and use the @GenerateMocks annotation:

import 'auth_service_test.mocks.dart'; // Import the generated file
@GenerateMocks([AuthService]) tells Mockito to generate a mock class for AuthService.
The generated mocks will be placed in a file named mocks.mocks.dart.

As we already have a mocks.dart file set up, just add the required classes to the @GenerateMocks annotation and run:

    flutter pub run build_runner build

if the funciton has already been mocked and needs updating, run:
    
    flutter pub run build_runner watch

if these fail you can use this command to rebuild mocks from scratch: 

    flutter pub run build_runner build --delete-conflicting-outputs


For example in the code:

    testWidgets("Auto Login Success Functions as Expected", (WidgetTester tester) async {

      when(getIt<AuthService>().loadUserCredentials()).thenAnswer((_) async => <String, String?>{
        "username": "mockUsername",
        "password": "mockPassword",
      });

      print("MOCKING LOGIN");


      when(getIt<AuthService>().login("mockUsername", "mockPassword"))
        .thenAnswer((_) async {});

      await tester.pumpWidget(
        MaterialApp(
          home: SplashPage(authService: getIt<AuthService>(), isTesting: true,),
          
        ),
      );


      // Verify that the CircularProgressIndicator is displayed initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the auto-login process to complete
      await tester.pumpAndSettle();


      // Verify that the auto-login process was called
      verify(getIt<AuthService>().loadUserCredentials()).called(1);
      verify(getIt<AuthService>().login("mockUsername", "mockPassword")).called(1);


      // Verify that the CircularProgressIndicator is no longer displayed
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Verify that the user is navigated to the main page after auto-login success
      expect(find.byType(MainNavigationBar), findsOneWidget);
    });

you define what the outputs of the mocked functions will be to ensure you have deterministic outputs
and can test functionality well 
