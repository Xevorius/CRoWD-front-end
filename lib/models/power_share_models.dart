class PowerShareOrderModel {
    final String pickupStation; 
    final String returnStation; 
    final DateTime pickupTime;
    final DateTime returnTime;
    final DateTime created;

    PowerShareOrderModel(
      {
        required this.pickupStation,
        required this.returnStation,
        required this.pickupTime,
        required this.returnTime,
        required this. created
      }
    );
  factory PowerShareOrderModel.fromJson(Map<String, dynamic> json) {
    return PowerShareOrderModel(pickupStation: json['pickupStation'], returnStation: json['returnStation'], pickupTime: json['pickupTime'], returnTime: json['returnTime'], created: json['created']);
  }
}

class PowerShareStationModel {
    final double lat; 
    final double lon; 
    final String model;
    final String created;

    PowerShareStationModel(
      {
        required this.lat,
        required this.lon,
        required this.model,
        required this. created
      }
    );
  factory PowerShareStationModel.fromJson(Map<String, dynamic> json) {
    return PowerShareStationModel(lat: json['lat'], lon: json['lon'], model: json['model'], created: json['created']);
  }
}