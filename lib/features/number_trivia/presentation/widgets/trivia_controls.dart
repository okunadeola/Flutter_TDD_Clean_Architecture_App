



import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
    final controller = TextEditingController();
   String inputStr = '';

   void dispatchConcrete(){
    controller.clear();
    final bloc = context.read<NumberTriviaBloc>();
    bloc.add(GetTriviaForConcreteNumber(inputStr));
  }

   void dispatchRandom(){
    controller.clear();
    final bloc = context.read<NumberTriviaBloc>();
    bloc.add(GetTriviaForRandomNumber());
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number'
            ),
          onChanged: ((value) {
            inputStr = value;
          }),
          onSubmitted: (_) {
            dispatchConcrete();
          }
        ),
        const SizedBox(
          height: 20.0,
        ),
        Row(
          children:  [
             Expanded(
                child: ElevatedButton(
                  onPressed: dispatchConcrete,
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(color:Colors.white),
                    backgroundColor: Theme.of(context).colorScheme.secondary ), 
                  child: const Text('Search'),
                  )   ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
                child:  ElevatedButton(
                  onPressed: dispatchRandom,
                  child: const Text('Get random trivia'),
                  )),
          ],
        )
      ],
    );
  }


 

}