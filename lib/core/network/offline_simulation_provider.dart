import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crm_dashboard_app/core/network/dio_client.dart';

/// Reactive provider for the simulated network connectivity state.
final offlineSimulationProvider = StateProvider<bool>((ref) {
  return DioClient.isOfflineSimulated;
});
