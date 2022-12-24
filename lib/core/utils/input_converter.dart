
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_tdd_approach/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str){

    try {
      final integer = int.parse(str);
      if (integer < 0) {
        throw const FormatException();
      }
    return Right(integer);
      
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}



class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}