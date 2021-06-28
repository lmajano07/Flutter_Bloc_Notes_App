import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_app/bloc/blocs.dart';
import 'package:flutter_notes_app/config/themes.dart';
import 'package:flutter_notes_app/repositories/repositories.dart';
import 'package:flutter_notes_app/screens/screens.dart';
import 'package:flutter_notes_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Fetch notes
        context.read<NotesBloc>().add(FetchNotes());
      },
      builder: (context, authState) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider<NoteDetailBloc>(
                  create: (_) => NoteDetailBloc(
                    authBloc: context.read<AuthBloc>(),
                    notesRepository: NotesRepository(),
                  ),
                  child: NoteDetailScreen(),
                ),
              ),
            ),
          ),
          body: BlocBuilder<NotesBloc, NotesState>(
            builder: (context, noteState) {
              return _buildBody(context, authState, noteState);
            },
          ),
        );
      },
    );
  }

  Stack _buildBody(
      BuildContext context, AuthState authState, NotesState notesState) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Your Notes'),
              ),
              leading: IconButton(
                icon: authState is Authenticated
                    ? Icon(Icons.exit_to_app)
                    : Icon(Icons.account_circle),
                iconSize: 28.0,
                onPressed: () => authState is Authenticated?
                    ? context.read<AuthBloc>().add(Logout())
                    : Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider<LoginBloc>(
                            create: (_) => LoginBloc(
                              authBloc: context.read<AuthBloc>(),
                              authRepository: AuthRepository(),
                            ),
                            child: LoginScreen(),
                          ),
                        ),
                      ),
              ),
              actions: [
                _buildThemeIconButton(context),
              ],
            ),
            notesState is NotesLoaded
                ? NotesGrid(
                    notes: notesState.notes,
                    onTap: (note) => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider<NoteDetailBloc>(
                          create: (_) => NoteDetailBloc(
                            authBloc: context.read<AuthBloc>(),
                            notesRepository: NotesRepository(),
                          )..add(NoteLoaded(note: note)),
                          child: NoteDetailScreen(note: note),
                        ),
                      ),
                    ),
                  )
                : const SliverPadding(padding: EdgeInsets.zero)
          ],
        ),
        notesState is NotesLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox.shrink(),
        notesState is NotesError
            ? Center(
                child: Text(
                  'Somenthing went wrong!\nPlease check your internet connection.',
                  textAlign: TextAlign.center,
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }

  IconButton _buildThemeIconButton(BuildContext context) {
    final bool isLightTheme = context.read<ThemeBloc>().state.themeData ==
        Themes.themeData[AppTheme.LightTheme];
    return IconButton(
      icon: isLightTheme ? Icon(Icons.brightness_4) : Icon(Icons.brightness_5),
      iconSize: 28.0,
      onPressed: () => context.read<ThemeBloc>().add(UpdateTheme()),
    );
  }
}
