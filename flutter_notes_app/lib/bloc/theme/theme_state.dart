part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeData? themeData;

  const ThemeState({this.themeData});

  @override
  List<Object?> get props => [themeData];

  @override
  String toString() => 'ThemeState { themeData: $themeData }';
}
