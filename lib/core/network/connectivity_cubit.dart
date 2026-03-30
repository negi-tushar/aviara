import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'network_info.dart';

class ConnectivityCubit extends Cubit<bool> {
  final NetworkInfo networkInfo;
  late StreamSubscription<bool> _subscription;

  ConnectivityCubit({required this.networkInfo}) : super(true) {
    _checkInitialStatus();
    _subscription = networkInfo.connectivityStream.listen((isConnected) {
      emit(isConnected);
    });
  }

  Future<void> _checkInitialStatus() async {
    final isConnected = await networkInfo.isConnected;
    emit(isConnected);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
