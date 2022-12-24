import 'package:flutter_clean_architecture_tdd_approach/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';




class MockInternetConnectionChecker extends Mock implements InternetConnectionChecker {}





void main() {
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  late NetworkInfoImpl networkInfo;



  setUp((){
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockInternetConnectionChecker);
  });



  group("isConnected", (){
    test("should forward the call to InternetConnectionChecker.hasConnection", ()async{

        // arange 
        final tHasConnectionFuture = Future.value(true);


        when(() => mockInternetConnectionChecker.hasConnection).thenAnswer((_)  => tHasConnectionFuture);
        // act
        final result =  networkInfo.isConnected;
        // assert
        verify(() => mockInternetConnectionChecker.hasConnection);
        expect(result, tHasConnectionFuture);
    });

  });





}