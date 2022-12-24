// ignore_for_file: public_member_api_docs, sort_constructors_first





import 'dart:convert';

import 'package:flutter_clean_architecture_tdd_approach/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
} 




class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;
  NumberTriviaRemoteDataSourceImpl({
    required this.client,
  });


  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) => _getTriviaFromUrl("http://numbersapi.com/$number");


  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => _getTriviaFromUrl("http://numbersapi.com/random");
  
  
  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async{
    final res = await client.get(
      Uri.parse(url), headers: {
      "Content-Type": "application/json"
    });

    if (res.statusCode == 200) {
    return NumberTriviaModel.fromJson(json.decode(res.body));
    }else {
      throw ServerException();
    }
  }



}
 