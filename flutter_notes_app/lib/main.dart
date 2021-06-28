import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_app/bloc/blocs.dart';
import 'package:flutter_notes_app/config/themes.dart';
import 'package:flutter_notes_app/repositories/repositories.dart';

import 'package:flutter_notes_app/screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocDelegate();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc()..add(LoadTheme()),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            authRepository: AuthRepository(),
          )..add(AppStarted()),
        ),
        BlocProvider<NotesBloc>(
          create: (_) => NotesBloc(
            authRepository: AuthRepository(),
            notesRepository: NotesRepository(),
          ),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Firebase Bloc Notes',
            debugShowCheckedModeBanner: false,
            theme: state.themeData,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
