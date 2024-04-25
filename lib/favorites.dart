import 'package:flutter/material.dart';
import 'place_info.dart';

class FavoritePage extends StatefulWidget {
  final List<dynamic> favoritePlaces;

  FavoritePage({required this.favoritePlaces});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

//страница с избранными местами
class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              "Избранные места",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(16.0), // add padding to the container
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.favoritePlaces.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            title: Text(
                              '${widget.favoritePlaces[index].name}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                                'Адрес: ${widget.favoritePlaces[index].address}'),
                            onTap: () {
                              Navigator.push(
                                //открытие окна с объектом
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Place_Info(
                                        placeId:
                                            widget.favoritePlaces[index].id);
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
