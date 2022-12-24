// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_clean_architecture_tdd_approach/core/error/exceptions.dart';
import 'package:flutter_clean_architecture_tdd_approach/core/error/failures.dart';
import 'package:flutter_clean_architecture_tdd_approach/core/usecases/usecase.dart';

import 'package:flutter_clean_architecture_tdd_approach/core/utils/input_converter.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';


const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHED_FAILURE_MESSAGE = 'Cached Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input - The number must be a positive integer or zero';





class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  
  NumberTriviaBloc({
   required  this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
   required  this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>(getConcreteTrivia);
    on<GetTriviaForRandomNumber>(getRandomTrivia);
  }

  FutureOr<void> getRandomTrivia(GetTriviaForRandomNumber event, Emitter<NumberTriviaState> emit) async {
      emit(Loading());
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      _eitherLoadedOrErrorState(failureOrTrivia, emit);
  }






  FutureOr<void> getConcreteTrivia(GetTriviaForConcreteNumber event, Emitter<NumberTriviaState> emit) async {
    final inputEither =  inputConverter.stringToUnsignedInteger(event.numberString);


   await inputEither.fold(
      (l) async  => emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE)), 
      (r) async{
      emit(Loading());
      final failureOrTrivia = await getConcreteNumberTrivia(Params(number:r));
      await _eitherLoadedOrErrorState(failureOrTrivia, emit);
    });
  }




   FutureOr<void> _eitherLoadedOrErrorState(Either<Failure, NumberTrivia> failureOrTrivia, Emitter<NumberTriviaState> emit) async {
   await failureOrTrivia.fold((failure) async =>  emit( 
      Error(message:  _mapFailureToMessage(failure))
      ), (trivia) async => emit(Loaded(trivia: trivia)));
  }

  String _mapFailureToMessage(Failure failure){
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MESSAGE;
      default:
      return "Unexpected error";
    }
  }



}
