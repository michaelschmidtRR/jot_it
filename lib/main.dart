import 'package:firebase_auth/firebase_auth.dart';
import 'authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState,
        ),
        // StreamProvider.value(
        //   initialData:
        //   initialData: CurrentUser.initial,
        //   value: FirebaseAuth.instance.onAuthStateChanged.map((user) => CurrentUser.create(user)),
        //   child: Consumer<CurrentUser>(
        //     builder: (context, user, _) => MaterialApp(
        //       title: 'Flutter Keep',
        //       home: user.isInitialValue ? Scaffold(body: const Text('Loading...')) : user.data != null ? HomePage() : LogInPage(),
        //     ),
        //   ),
        // )
      ],
      child: MaterialApp(
        title: 'JotIt',
        home: Authenticate(),
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
      ),
    );
  }
}

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return HomePage();
    }
    return LoginPage();
  }
}
