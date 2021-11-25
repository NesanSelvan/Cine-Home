import 'package:basics/constants/constants.dart';
import 'package:basics/models/movies.dart';
import 'package:basics/pages/movies_screen.dart';
import 'package:basics/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();
  List<MoviesModel> searchedData = [];
  final searchFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // The search area here
            title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.grey[900], borderRadius: BorderRadius.circular(25)),
          child: Center(
            child: TextField(
              // autofocus: true,
              onTap: () {
                setState(() {});
              },
              focusNode: searchFocus,
              controller: searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: kPrimaryColor,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: kPrimaryColor,
                    ),
                    onPressed: () {
                      /* Clear the search field */
                      searchController.clear();
                      setState(() {});
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none),
              onEditingComplete: () async {
                debugPrint("Search For ${searchController.text}");
                searchedData =
                    await API().searchMovie(searchController.text, 5);
                searchFocus.unfocus();
                // SystemChannels.textInput.invokeMethod('TextInput.hide');
                setState(() {});
              },
            ),
          ),
        )),
        body: searchFocus.hasFocus
            ? Text("Searching...")
            : searchedData.length == 0
                ? Text("No Data to display")
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                        child: BuildMovieContainer(moviesList: searchedData)),
                  ));
  }
}
