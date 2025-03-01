import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  late final InternetConnectionChecker internetConnectionChecker;

  NetworkInfoImpl({required this.internetConnectionChecker});

  @override
  Future<bool> get isConnected async {
    try {
      final Future<bool> result = internetConnectionChecker.hasConnection;
      return true;
    } catch (_) {
      return false;
    }
  }

  // @override
  // Future<bool> get isConnected => internetConnectionChecker.hasConnection;
}
