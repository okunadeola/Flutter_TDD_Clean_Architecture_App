

import 'dart:convert';

import 'package:flutter_clean_architecture_tdd_approach/core/error/exceptions.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/data/datasources/number_trivia_remote_data_sources.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}


void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

setUp((){
  mockHttpClient = MockHttpClient();
  dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  registerFallbackValue(Uri.parse("https://numbersapi.com/1"));
});


void setUpMockHttpClientSuccess200(){
  when(() => mockHttpClient.get(any(), headers:  any(named: "headers"))).thenAnswer((_) async=> http.Response(fixture("trivia.json"), 200));
}
void setUpMockHttpClientFailyre404(){
  when(() => mockHttpClient.get(any(), headers:  any(named: "headers"))).thenAnswer((_) async=> http.Response("something went wrong", 404));
}


  group("getConcreteNumberTrivia", (){
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));


    test("should perform a GET request on a URL with number being the endpoint and  with apllication/json header", (){

        // arrange
          setUpMockHttpClientSuccess200();
        // act
        dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockHttpClient.get(
          Uri.parse('https://numbersapi.com/$tNumber'), headers: {
          "Content-Type": "application/json"
        }),);
    });





    test("should return NumberTrivia when the response code is 200 (success)", () async{

        // arrange
          setUpMockHttpClientSuccess200();
        // act
       final result = await dataSource.getConcreteNumberTrivia(tNumber);
        // assert

      expect(result, equals(tNumberTriviaModel));

    });




    test("should throw a ServerException when the esponse code is 404 or other", () async{

        // arrange
          setUpMockHttpClientFailyre404();
        // act
       final call =  dataSource.getConcreteNumberTrivia;
        // assert

      expect(()=> call(tNumber), throwsA(const TypeMatcher<ServerException>()));
     
    });

  });










  group("getRandomNumberTrivia", (){
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));


    test("should perform a GET request on a URL with number being the endpoint and  with apllication/json header", (){

        // arrange
          setUpMockHttpClientSuccess200();
        // act
        dataSource.getRandomNumberTrivia();
        // assert
        verify(() => mockHttpClient.get(
          Uri.parse('https://numbersapi.com/random'), headers: {
          "Content-Type": "application/json"
        }),);
    });



    test("should return NumberTrivia when the response code is 200 (success)", () async{

        // arrange
          setUpMockHttpClientSuccess200();
        // act
       final result = await dataSource.getRandomNumberTrivia();
        // assert

      expect(result, equals(tNumberTriviaModel));

    });




    test("should throw a ServerException when the esponse code is 404 or other", () async{

        // arrange
          setUpMockHttpClientFailyre404();
        // act
       final call =  dataSource.getRandomNumberTrivia;
        // assert

      expect(()=> call(), throwsA(const TypeMatcher<ServerException>()));
     
    });
  });


}