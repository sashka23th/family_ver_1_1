import 'package:family_cash/core/remoute/network_info.dart';
import 'package:family_cash/features/Presentation/bloc/analytic/analytic_bloc.dart';
import 'package:family_cash/features/Presentation/bloc/auth/auth_bloc.dart';
import 'package:family_cash/features/Presentation/bloc/category/category_bloc.dart';
import 'package:family_cash/features/Presentation/bloc/family/family_bloc.dart';
import 'package:family_cash/features/Presentation/bloc/payments/payment_bloc.dart';
import 'package:family_cash/features/Presentation/bloc/settings_bloc.dart';
import 'package:family_cash/features/data/datasources/local/category_local_source.dart';
import 'package:family_cash/features/data/datasources/local/family_local_source.dart';
import 'package:family_cash/features/data/datasources/local/parm_local_source.dart';
import 'package:family_cash/features/data/datasources/local/payment_local_source.dart';
import 'package:family_cash/features/data/datasources/local/token_local_source.dart';
import 'package:family_cash/features/data/datasources/local/user_local_source.dart';
import 'package:family_cash/features/data/datasources/remote/analytic_remote_source.dart';
import 'package:family_cash/features/data/datasources/remote/category_remote_source.dart';
import 'package:family_cash/features/data/datasources/remote/family_remote_source.dart';
import 'package:family_cash/features/data/datasources/remote/payment_remote_source.dart';
import 'package:family_cash/features/data/datasources/remote/token_remote_source.dart';
import 'package:family_cash/features/data/datasources/remote/user_remote_source.dart';
import 'package:family_cash/features/data/repositories/analytic_repository_impl.dart';
import 'package:family_cash/features/data/repositories/auth_repository_impl.dart';
import 'package:family_cash/features/data/repositories/category_repository_impl.dart';
import 'package:family_cash/features/data/repositories/family_repository_impl.dart';
import 'package:family_cash/features/data/repositories/payment_repository_impl.dart';
import 'package:family_cash/features/domain/repositories/analytic_repository.dart';
import 'package:family_cash/features/domain/repositories/auth_repository.dart';
import 'package:family_cash/features/domain/repositories/category_repository.dart';
import 'package:family_cash/features/domain/repositories/family_repository.dart';
import 'package:family_cash/features/domain/repositories/payment_repository.dart';
import 'package:family_cash/features/domain/usecases/analytic_usecase.dart';
import 'package:family_cash/features/domain/usecases/auth_usecase.dart';
import 'package:family_cash/features/domain/usecases/category_usercase.dart';
import 'package:family_cash/features/domain/usecases/family_usecase.dart';
import 'package:family_cash/features/domain/usecases/payment_usecase.dart';

import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as acc;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //Block
  sl.registerFactory(() => AuthBloc(authUsecase: sl()));
  sl.registerFactory(() => FamilyBloc(familyUsecase: sl()));
  sl.registerFactory(() => SettingsBloc());
  sl.registerFactory(() => PaymentBloc(paymentUsecase: sl()));
  sl.registerFactory(() => CategoryBloc(categoryUsercase: sl()));
  sl.registerFactory(() => AnalyticBloc(analyticUsecase: sl()));

  //UseCase
  sl.registerLazySingleton(() => AuthUsecase(repository: sl()));
  sl.registerLazySingleton(() => FamilyUsecase(familyRepository: sl()));
  sl.registerLazySingleton(() => CategoryUsercase(categoryRepository: sl()));
  sl.registerLazySingleton(() => PaymentUsecase(paymentRepository: sl()));
  sl.registerLazySingleton(() => AnalyticUsecase(analyticRepository: sl()));

  //Reposityry
  sl.registerLazySingleton<IAuthRepository>(() => AuthRepositoryImpl(
      tokenRemote: sl(),
      tokenLocalSource: sl(),
      networkInfo: sl(),
      userRemoteSource: sl(),
      userLocalSource: sl()));

  sl.registerLazySingleton<IFamilyRepository>(() => FamilyRepositoryImpl(
      tokenLocalSource: sl(),
      networkInfo: sl(),
      familyLocalSource: sl(),
      famailyRemoteSource: sl()));

  sl.registerLazySingleton<ICategoryRepository>(() => CategoryRepositoryImpl(
      tokenLocalSource: sl(),
      networkInfo: sl(),
      categoryLocalSource: sl(),
      categoryRemoteSource: sl()));

  sl.registerLazySingleton<IPaymentRepository>(() => PaymentRepositoryImpl(
      tokenLocalSource: sl(),
      networkInfo: sl(),
      paymentLocalSource: sl(),
      paymentRemoteSource: sl()));

  sl.registerLazySingleton<IAnalyticRepository>(() => AnalyticRepositoryImpl(
      tokenLocalSource: sl(),
      networkInfo: sl(),
      analyticRemoteSource: sl(),
      parmLocalSource: sl()));

  //Source
  sl.registerLazySingleton<TokenRemoteSource>(
    () => TokenRemoteSourceImpl(),
  );
  sl.registerLazySingleton<TokenLocalSource>(
    () => TokenLocalSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<UserRemoteSource>(
    () => UserRemoteSourceImp(),
  );
  sl.registerLazySingleton<UserLocalSource>(
    () => UserLocalSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<FamilyLocalSource>(
    () => FamilyLocalSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<FamailyRemoteSource>(
    () => FamilyRemoteSourceImpl(),
  );
  sl.registerLazySingleton<CategoryLocalSource>(
    () => CategoryLocalSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<CategoryRemoteSource>(
    () => CategoryRemoteSourceImpl(),
  );
  sl.registerLazySingleton<PaymentLocalSource>(
    () => PaymentLocalSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<PaymentRemoteSource>(
    () => PaymentRemoteSourceImpl(),
  );
  sl.registerLazySingleton<AnalyticRemoteSource>(
    () => AnalyticRemoteSourceImpl(),
  );
  sl.registerLazySingleton<ParmLocalSource>(
    () => ParmLocalSourceImpl(sharedPreferences: sl()),
  );

  //Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(internetConnectionChecker: sl()),
  );

  //Extract
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(
      () => acc.InternetConnectionChecker.createInstance());
}
