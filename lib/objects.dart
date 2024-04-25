class PlaceCard {
  final String id;
  final String name;
  final String address;
  final String type;

  PlaceCard({
    required this.id,
    required this.name,
    required this.address,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'type': type,
    };
  }

  factory PlaceCard.fromMap(Map<String, dynamic> map) {
    return PlaceCard(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      type: map['type'],
    );
  }
}

List<String> availableTypes = [
  'branch',
  'building',
  'street',
  'parking',
  'station',
  'station.metro',
  'attraction',
];
Map<String, dynamic> availableTypesru = {
  'branch': "компания",
  'building': "здание",
  'street': "улица",
  'parking': "парковка",
  'station': "станция",
  'station.metro': "станция метро",
  'attraction': "достопримечательность"
};
