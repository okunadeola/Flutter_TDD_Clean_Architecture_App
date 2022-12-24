

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_clean_architecture_tdd_approach/core/error/failures.dart';
import 'package:flutter_clean_architecture_tdd_approach/core/usecases/usecase.dart';

import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {

  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(
     NoParams params
  ) async {
    return await repository.getRandomNumberTrivia();
  }


}




