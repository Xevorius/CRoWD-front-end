import 'package:crowd_front_end/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/power_share_models.dart';

final powerShareStationDataProvider = FutureProvider<List<PowerShareStationModel>>(
  (ref) async {
    return ref.watch(powerShareStationProvider).fetchAllStations();
  }
);