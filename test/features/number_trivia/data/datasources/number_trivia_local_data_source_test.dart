

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_tdd_approach/core/error/exceptions.dart';
import 'package:flutter_clean_architecture_tdd_approach/core/error/failures.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPerences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPerences mockSharedPerences;


  setUp((){
    mockSharedPerences = MockSharedPerences();
    dataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPerences);
   });




   group("getLastNumberTrivia", (){

    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture("trivia_cached.json")));


    test("should return NumberTrivia from SharedPrefernces when there is one in the cache ", ()async{
      // arr
      when(() => mockSharedPerences.getString(any())).thenReturn(fixture("trivia_cached.json"));

      // act
      final result = await dataSource.getLastNumberTrivia();

      // assert
      verify(() => mockSharedPerences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test("should throw a CachedExemption when there is no cached value", ()async{
      // arr
      when(() => mockSharedPerences.getString(any())).thenReturn(null);

      // act
      final call =  dataSource.getLastNumberTrivia;

      // assert
      expect(()=> call(), throwsA(const TypeMatcher<CacheException>()));
    });


   });



    // group("cacheNumberTrivia", (){
    //     final tNumberTriviaModel = NumberTriviaModel(text: "text trivia", number: 1);
    //   test("should call SharedPreferences to cache the data", () {
        
    //       // act
    //         dataSource.cacheNumberTrivia(tNumberTriviaModel);
    //       // assert
    //       final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
    //       verify(() => mockSharedPerences.setString(CACHED_NUMBER_TRIVIA,expectedJsonString));
    //   });

    // });
}