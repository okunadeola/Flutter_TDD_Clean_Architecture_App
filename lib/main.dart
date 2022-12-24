import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;
import 'package:flutter_clean_architecture_tdd_approach/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp( BlocProvider(
    create: (_) => sl<NumberTriviaBloc>(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
          primaryColor: Colors.green.shade800,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: Colors.green.shade600)),
      home: const NumberTriviaPage(),
    );
  }
}
