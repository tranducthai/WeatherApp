import 'package:latlong2/latlong.dart';

class GeocodeData {
  String name;
  String country;
  LatLng latLng;
  GeocodeData({
    required this.name,
    required this.country,
    required this.latLng,
  });

  factory GeocodeData.fromJson(List< dynamic> json) {
    return GeocodeData(

      name: json[0]['name'],
      country: json[0]['country'],
      latLng: LatLng(json[0]['lat'], json[0]['lon']),
    );
  }
}
