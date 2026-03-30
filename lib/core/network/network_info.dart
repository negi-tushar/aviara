import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get connectivityStream;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return _mapResults(result);
  }

  @override
  Stream<bool> get connectivityStream {
    return connectivity.onConnectivityChanged.map((result) {
      return _mapResults(result);
    });
  }

  bool _mapResults(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    // We are connected if any result is NOT ConnectivityResult.none
    return results.any((element) => element != ConnectivityResult.none);
  }
}
