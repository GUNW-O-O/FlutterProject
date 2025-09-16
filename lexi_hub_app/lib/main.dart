
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/note_provider.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, NoteProvider>(
          create: (context) => NoteProvider(Provider.of<AuthProvider>(context, listen: false)),
          update: (context, auth, previousNotes) => NoteProvider(auth),
        ),
      ],
      child: MaterialApp(
        title: 'LexiHub',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MainScreen(),
      ),
    );
  }
}
