class SearchInfo {
  Geometry? geometry;
  String? type;
  Properties? properties;

  SearchInfo({this.geometry, this.type, this.properties});

  SearchInfo.fromJson(Map<String, dynamic> json) {
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    type = json['type'];
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    data['type'] = type;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    return data;
  }
}

class Geometry {
  List<double>? coordinates;
  String? type;

  Geometry({this.coordinates, this.type});

  Geometry.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coordinates'] = coordinates;
    data['type'] = type;
    return data;
  }
}

class Properties {
  String? osmType;
  int? osmId;
  String? country;
  String? osmKey;
  String? countrycode;
  String? osmValue;
  String? postcode;
  String? name;
  String? state;
  String? type;
  String? county;
  String? city;
  String? street;
  String? district;
  List<double>? extent;

  Properties(
      {this.osmType,
      this.osmId,
      this.country,
      this.osmKey,
      this.countrycode,
      this.osmValue,
      this.postcode,
      this.name,
      this.state,
      this.type,
      this.county,
      this.city,
      this.street,
      this.district,
      this.extent});

  Properties.fromJson(Map<String, dynamic> json) {
    List<double> extents = [];
    if (json['extent'] != null) {
      for (var i in json['extent']) {
        extents.add(double.parse(i.toString()));
      }
    }
    osmType = json['osm_type'];
    osmId = json['osm_id'];
    country = json['country'];
    osmKey = json['osm_key'];
    countrycode = json['countrycode'];
    osmValue = json['osm_value'];
    postcode = json['postcode'];
    name = json['name'];
    state = json['state'];
    type = json['type'];
    county = json['county'];
    city = json['city'];
    street = json['street'];
    district = json['district'];
    extent = extents;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['osm_type'] = osmType;
    data['osm_id'] = osmId;
    data['country'] = country;
    data['osm_key'] = osmKey;
    data['countrycode'] = countrycode;
    data['osm_value'] = osmValue;
    data['postcode'] = postcode;
    data['name'] = name;
    data['state'] = state;
    data['type'] = type;
    data['county'] = county;
    data['city'] = city;
    data['street'] = street;
    data['district'] = district;
    data['extent'] = extent;
    return data;
  }
}
