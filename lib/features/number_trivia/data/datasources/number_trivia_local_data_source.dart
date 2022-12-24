// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'dart:convert';

import 'package:flutter_clean_architecture_tdd_approach/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
/// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);

}

const CACHED_NUMBER_TRIVIA = "CACHED_NUMBER_TRIVIA";



class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
    final SharedPreferences sharedPreferences;
  NumberTriviaLocalDataSourceImpl({
    required this.sharedPreferences,
  });




  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
       return sharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, 
          json.encode(
            triviaToCache.toJson()
            ));
  }


  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
    return Future.value(NumberTriviaModel.fromJson( json.decode(jsonString)));
      
    }else{
      throw CacheException();
    }

  }






}
