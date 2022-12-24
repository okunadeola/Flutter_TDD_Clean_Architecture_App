// ignore_for_file: prefer_const_declarations

import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_tdd_approach/core/error/failures.dart';
import 'package:flutter_clean_architecture_tdd_approach/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture_tdd_approach/core/utils/input_converter.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();

    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();

    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test("Initial state should be Empty", () {
    expect(bloc.state, equals(Empty()));
  });

  group("GetTriviaForConcreteNumber", () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: "test trivia", number: 1);
    final expected = [
      Empty(),
      const Error(message: INVALID_INPUT_FAILURE_MESSAGE)
    ];

    void setUpMockInputConverterSuccess() =>
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(Right(tNumberParsed));

    test(
        "Should call the InputConverter to validate and convert the string to an unsigned interger",
        () async* {
      // arr
      setUpMockInputConverterSuccess();

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(
          () => mockInputConverter.stringToUnsignedInteger(any()));

      // assert
      verify(() => mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test("Should emit [Error] when the input is invalid", () async* {
      // arr
      when(() => mockInputConverter.stringToUnsignedInteger(any()))
          .thenReturn(Left(InvalidInputFailure()));

      // assert later

      expectLater(bloc.state, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test("Should get data from the concrete use case", () async* {
      // arr
      setUpMockInputConverterSuccess();
      // arr
      when(() => mockGetConcreteNumberTrivia(any()))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(() => mockGetConcreteNumberTrivia(any()));

      //assert
      verify(() => mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test("Should emit [Loading, Loaded] when data is gotten successfully",
        () async* {
      // arr
      setUpMockInputConverterSuccess();
      // arr
      when(() => mockGetConcreteNumberTrivia(any()))
          .thenAnswer((_) async => Right(tNumberTrivia));

      final expectedList = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];

      //assert
      expectLater(bloc.state, emitsInOrder(expectedList));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test("Should emit [Loading, Error] when getting data failed", () async* {
      // arr
      setUpMockInputConverterSuccess();
      // arr
      when(() => mockGetConcreteNumberTrivia(any()))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expectedList = [
        Empty(),
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE),
      ];

      //assert
      expectLater(bloc.state, emitsInOrder(expectedList));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        "Should emit [Loading, Error] with a proper message for the error when getting data failed",
        () async* {
      // arr
      setUpMockInputConverterSuccess();
      // arr
      when(() => mockGetConcreteNumberTrivia(any()))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expectedList = [
        Empty(),
        Loading(),
        const Error(message: CACHED_FAILURE_MESSAGE),
      ];

      //assert
      expectLater(bloc.state, emitsInOrder(expectedList));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });



















  group("GetTriviaForRandomNumber", () {

    final tNumberTrivia = NumberTrivia(text: "test trivia", number: 1);
    final expected = [
      Empty(),
      const Error(message: INVALID_INPUT_FAILURE_MESSAGE)
    ];



    test("Should get data from the random use case", () async* {
      // arr

      // arr
      when(() => mockGetRandomNumberTrivia(any()))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(() => mockGetRandomNumberTrivia(any()));

      //assert
      verify(() => mockGetRandomNumberTrivia(NoParams()));
    });


    test("Should emit [Loading, Loaded] when data is gotten successfully",
        () async* {

      // arr
        when(() => mockGetRandomNumberTrivia(any()))
          .thenAnswer((_) async => Right(tNumberTrivia));

      final expectedList = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];

      //assert
      expectLater(bloc.state, emitsInOrder(expectedList));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });



    test("Should emit [Loading, Error] when getting data failed", () async* {

      // arr
        when(() => mockGetRandomNumberTrivia(any()))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expectedList = [
        Empty(),
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE),
      ];

      //assert
      expectLater(bloc.state, emitsInOrder(expectedList));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        "Should emit [Loading, Error] with a proper message for the error when getting data failed",
        () async* {

      // arr
        when(() => mockGetRandomNumberTrivia(any()))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expectedList = [
        Empty(),
        Loading(),
        const Error(message: CACHED_FAILURE_MESSAGE),
      ];

      //assert
      expectLater(bloc.state, emitsInOrder(expectedList));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
