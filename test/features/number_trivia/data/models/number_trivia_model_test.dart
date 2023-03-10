
import 'dart:convert';

import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';






void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");



  test('should be a subclass of NumberTrivia entity', () async {
    //arrange

    //act 

    //assert
     expect(tNumberTriviaModel, isA<NumberTriviaModel>());
  });



  group("fromJson", (){

    test("should return a valid model when the JSON number is regarded as integer", () async {
          //arrange
          final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

          //act 
          final result = NumberTriviaModel.fromJson(jsonMap);

          //assert
          expect(result, tNumberTriviaModel);
    });



    test("should return a valid model when the JSON number is regarded as double", () async {
          //arrange
          final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double.json'));

          //act 
          final result = NumberTriviaModel.fromJson(jsonMap);

          //assert
          expect(result, tNumberTriviaModel);
    });

  });





  group("toJson", (){

    test("should return a JSON  map containing the proper data", () async {
          //arrange


          //act 
          final result =  tNumberTriviaModel.toJson();

          final expectedMap =  {"text": "Test Text", "number": 1};

          //assert
          expect(result, expectedMap);

    });





  });


}