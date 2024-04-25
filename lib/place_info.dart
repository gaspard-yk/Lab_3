import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'objects.dart';

class Place_Info extends StatefulWidget {
  final String placeId;

  Place_Info({required this.placeId});

  @override
  _Place_infoState createState() => _Place_infoState();
}

class _Place_infoState extends State<Place_Info> {
  late SharedPreferences prefs; //переменная для получения сохраннеых объектв
  List<PlaceCard> favoritePlaces = [];
  PlaceCard? place;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    fetchDetails(widget.placeId).then((value) => setState(() => place = value));
  }

  initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    favoritePlaces =
        (prefs.getStringList('favoritePlaces') ?? []) //получение избранных
            .map((jsonString) => PlaceCard.fromMap(json.decode(jsonString)))
            .toList();
    setState(() {});
  }

  Future<PlaceCard> fetchDetails(String id) async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://catalog.api.2gis.com/3.0/items/byid?id=$id&key=21332ac5-6352-4d09-bd09-104853f0e27d'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          json.decode(response.body)['result']['items'][0];
      return PlaceCard(
        id: data['id'],
        name: data['name'],
        address: data['address_name'],
        type: data['type'],
      );
    }
    return PlaceCard(
      id: '',
      name: '',
      address: '',
      type: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Подробнее'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite(place) ? Icons.favorite : Icons.favorite_border,
              color: isFavorite(place) ? Colors.red : Colors.black,
            ),
            onPressed: () {
              Add_To_Favorite(place!);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            height: 600,
            decoration: BoxDecoration(
                //color: Colors.grey[300],
                //borderRadius: BorderRadius.circular(10.0)
                ),
            child: place == null
                ? Center(child: CircularProgressIndicator())
                : Container(
                    margin: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${place?.name}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        if (place?.address == null) ...[
                          SizedBox(height: 10),
                          Text(
                            'Адрес: ${place?.address}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                        SizedBox(height: 10),
                        Text(
                          'Тип: ${availableTypesru[place?.type]}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  bool isFavorite(PlaceCard? place) {
    if (place == null) return false;
    return favoritePlaces.any((favorite) => favorite.id == place.id);
  }

  void Add_To_Favorite(PlaceCard place) {
    if (isFavorite(place)) {
      favoritePlaces.removeWhere((favorite) => favorite.id == place.id);
      prefs.setStringList(
          'favoritePlaces',
          favoritePlaces
              .map((place) => jsonEncode(place.toMap()))
              .toList()); //запись в память
    } else {
      favoritePlaces.add(place);
      prefs.setStringList(
          'favoritePlaces',
          favoritePlaces
              .map((place) => jsonEncode(place.toMap()))
              .toList()); //запись в память
    }
    setState(() {});
  }
}
