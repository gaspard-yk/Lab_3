import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'place_info.dart';
import 'objects.dart';

class PlacesList extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _PlacesListState createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  late List<dynamic> data;
  String _searchQuery = 'Югорский государственный университет';
  String _searchCity = 'Ханты-Мансийск';
  List<String> _selectedTypes = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _setSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
    fetchData();
  }

  fetchData() async {
    http.Response response;
    String selectedTypesString = _selectedTypes.join(',');
    try {
      if (selectedTypesString.isEmpty) {
        response = await http.get(Uri.parse(
            'https://catalog.api.2gis.com/3.0/items?q=$_searchQuery+ +$_searchCity&locale=ru_RU&key=21332ac5-6352-4d09-bd09-104853f0e27d'));
      } else {
        response = await http.get(Uri.parse(
            'https://catalog.api.2gis.com/3.0/items?q=$_searchQuery+ +$_searchCity&type=$selectedTypesString&locale=ru_RU&key=21332ac5-6352-4d09-bd09-104853f0e27d'));
      }
      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body)['result']['items'] ?? [];
        });
      }
    } catch (e) {
      setState(() {
        data = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Справочник мест'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                final query = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                          title: Text('Поиск'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                onChanged: (value) {
                                  _searchQuery = value;
                                },
                                decoration:
                                    InputDecoration(hintText: 'Введите запрос'),
                              ),
                              TextField(
                                onChanged: (value) {
                                  _searchCity = value;
                                },
                                decoration: InputDecoration(hintText: 'Город'),
                              ),
                              SizedBox(
                                height: 160.0, // give it a specific height
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    children: availableTypes.map((type) {
                                      return CheckboxListTile(
                                        title: Text(availableTypesru[type]),
                                        value: _selectedTypes.contains(type),
                                        onChanged: (value) {
                                          setState(() {
                                            if (value!) {
                                              _selectedTypes.add(type);
                                            } else {
                                              _selectedTypes.remove(type);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Отмена'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, _searchQuery);
                                _setSearchQuery(_searchQuery);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
                if (query != null) {
                  _setSearchQuery(query);
                }
              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(16.0), // add padding to the container
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            '${data[index]['name']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle:
                              Text('Адрес: ${data[index]['address_name']}'),
                          onTap: () {
                            if (data[index]['id'] != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Place_Info(placeId: data[index]['id']),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
