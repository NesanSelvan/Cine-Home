import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Database extends StatefulWidget {
  Database({Key? key}) : super(key: key);

  @override
  _DatabaseState createState() => _DatabaseState();
}

class _DatabaseState extends State<Database> {
  Future<List<Map<String, dynamic>>?> loadAsset() async {
    final myData = await rootBundle.loadString("assets/movies.csv");
    print(myData);
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);
    List<List<dynamic>> data = [];
    List<Map<String, dynamic>> databaseList = [];
    csvTable.remove(0);
    for (final item in csvTable) {
      final moviesData = "$item";
      final data = moviesData.replaceAll("[", "");
      final finalData = data.replaceAll("]", "");
      final movieList = finalData.split(",");
      final genereList = movieList.last.split("|");
      // print(movieList)

      if (movieList.isEmpty || movieList.length < 3) {
        break;
      }
      databaseList.add({
        "movieId": movieList[0],
        "movieName": movieList[1],
        "genres": genereList
      });
      if (genereList == genereList[0]) {}
      // print(item.runtimeType);
    }
    return databaseList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () async {
          final data = await loadAsset();
          print("${data}");
          final movieCollection =
              FirebaseFirestore.instance.collection("movies");
          // firebase.collection("movies").add(data)
          if (data != null) {
            for (var item in data) {
              await movieCollection.add(item);
            }
          }
        },
      ),
    );
  }
}
