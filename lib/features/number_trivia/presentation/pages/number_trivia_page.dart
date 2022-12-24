import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';


import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            const SizedBox(
              height: 10.0,
            ),
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {

                if (state is Loaded){
                  return TriviaDisplay(numberTrivia: state.trivia);
                }
                else if (state is Loading){
                  return const LoadingWidget();
                }
                else if (state is Error){
                  return MessageDisplay(message: state.message);
                }
                else if(state is Empty){
                  return const MessageDisplay(message: "Start searching",);
                }else {
                  return const SizedBox.shrink();
                }
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            const TriviaControls()
          ]),
        ));
  }
}








