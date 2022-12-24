import 'package:flutter_clean_architecture_tdd_approach/core/network/network_info.dart';
import 'package:flutter_clean_architecture_tdd_approach/core/utils/input_converter.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/data/datasources/number_trivia_remote_data_sources.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_architecture_tdd_approach/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async{
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDataSource: sl(),
           localDataSource: sl(), 
           networkInfo: sl()));
    
  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(() => NumberTriviaRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(() => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));




  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPrefereces = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPrefereces );
  sl.registerLazySingleton(() => http.Client() );
  sl.registerLazySingleton(() => InternetConnectionChecker() );
}


// registerLazySingleton() => register object when call
// registerSingleton() => register object immediatly with single object
// registerFactory() => register object immediatly with new instance on call
//   sl.registerLazySingleton<Future<SharedPreferences>>(() async => await SharedPreferences.getInstance());