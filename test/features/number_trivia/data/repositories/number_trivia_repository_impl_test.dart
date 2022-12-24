



import 'dart:async';
import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_tdd_approach/core/error/exceptions.dart';
import 'package:flutter_clean_architecture_tdd_approach/core/error/failures.dart';
import 'package:flutter_clean_architecture_tdd_approach/core/network/network_info.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/data/datasources/number_trivia_remote_data_sources.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';




class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}


class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}


class MockNetworkInfo extends Mock implements NetworkInfo {}


void main() {
  late NumberTriviaRepositoryImpl repository;

  late MockRemoteDataSource mockRemoteDataSource;

  late MockLocalDataSource mockLocalDataSource;

  late MockNetworkInfo mockNetworkInfo;


  setUp((){
      mockRemoteDataSource = MockRemoteDataSource();

      mockLocalDataSource = MockLocalDataSource();

      mockNetworkInfo =  MockNetworkInfo();

      repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource : mockLocalDataSource,
        networkInfo : mockNetworkInfo
      );
  });





  void runTestOnline(Function body){
            group("device is online", (){
          setUp((){
            when(() =>mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          });
        
            body();
        });
  }


  
  void runTestOffline(Function body){
            group("device is offline", (){
          setUp((){
            when(() =>mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          });
        
            body();
        });
  }
















  group('getConcreteNumberTrivia', (){

      const tNumber = 1;
      const tNumberTriviaModel = NumberTriviaModel(text: 'test trivia', number: tNumber);

       NumberTrivia tNumberTrivia = tNumberTriviaModel;


       void whenCall(){
          when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async =>  {});

          when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenAnswer((_) async => tNumberTriviaModel);
        }

       void whenCallError(){
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)).thenThrow(ServerException());


        }



      test("should check if the device is online",  ()async {

          // arrange
          when(()=>mockNetworkInfo.isConnected).thenAnswer((_) async => true);

          // arrange
          whenCall();

          // act
           await repository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(()=>mockNetworkInfo.isConnected);
      });



// online
      runTestOnline((){
        test("should return data when the call to remote data source is successful", ()async{
          // arrange

          // arrange
          whenCall();

          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // assert 
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));

        });





        test("should cache the data locally when the call to remote data source is successful", ()async{

          // arrange
          whenCall();

          // act
           await repository.getConcreteNumberTrivia(tNumber);

          // assert 
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));


        });



        test("should return server failure when the call to remote data source is unsuccessful", ()async{

          // arrange
          whenCallError();

          // act
          final result =  await repository.getConcreteNumberTrivia(tNumber);

          // assert 
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result,  equals(Left(ServerFailure())));

        });

      });






// offline
      runTestOffline((){
        test("should return last locally cached data when the cached data is present", ()async{

          // arrange
          when(() => mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

          // act
          final result =  await repository.getConcreteNumberTrivia(tNumber);

          // assert 
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result,  equals(Right(tNumberTrivia)));

        });




        test("should return return CachedFailure when there is no cached data  present", ()async{

          // arrange
          when(() => mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());

          // act
          final result =  await repository.getConcreteNumberTrivia(tNumber);

          // assert 
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result,  equals(Left(CacheFailure())));

        });








      });




  });









// random 
group('getRandomNumberTrivia', (){

      const tNumberTriviaModel = NumberTriviaModel(text: 'test trivia', number: 123);

       NumberTrivia tNumberTrivia = tNumberTriviaModel;

       void whenRCall(){
          when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel)).thenAnswer((_) async =>  {});

          when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);
        }

       void whenRCallError(){
          when(() => mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException());


        }



      test("should check if the device is online",  ()async {

          // arrange
          when(()=>mockNetworkInfo.isConnected).thenAnswer((_) async => true);

          // arrange
          whenRCall();

          // act
           await repository.getRandomNumberTrivia();

          // assert
          verify(()=>mockNetworkInfo.isConnected);
      });



// online
      runTestOnline((){
        test("should return data when the call to remote data source is successful", ()async{
          // arrange

          // arrange
          whenRCall();

          // act
          final result = await repository.getRandomNumberTrivia();

          // assert 
          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));

        });





        test("should cache the data locally when the call to remote data source is successful", ()async{

          // arrange
          whenRCall();

          // act
           await repository.getRandomNumberTrivia();

          // assert 
          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));


        });



        test("should return server failure when the call to remote data source is unsuccessful", ()async{

          // arrange
          whenRCallError();

          // act
          final result =  await repository.getRandomNumberTrivia();

          // assert 
          verify(() => mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result,  equals(Left(ServerFailure())));

        });

      });


            




// offline
      runTestOffline((){
        test("should return last locally cached data when the cached data is present", ()async{

          // arrange
          when(() => mockLocalDataSource.getLastNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

          // act
          final result =  await repository.getRandomNumberTrivia();

          // assert 
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result,  equals(Right(tNumberTrivia)));

        });




        test("should return return CachedFailure when there is no cached data  present", ()async{

          // arrange
          when(() => mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException());

          // act
          final result =  await repository.getRandomNumberTrivia();

          // assert 
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result,  equals(Left(CacheFailure())));

        });
      });
  });

}