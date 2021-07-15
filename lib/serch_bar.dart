import 'package:flutter/material.dart';
import 'package:search_bar_app/constants.dart';

class SerachBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          "Search App",
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // ye automatically search bar show kre ga
                showSearch(context: context, delegate: DataSearch());
              })
        ],
      ),
      body: Center(
          child: Text(
        "Search city from top",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      )),
    );
  }
}

// SearchDelegate ye class automatically serach ka funchtion perform kraye ga
class DataSearch extends SearchDelegate {
  String cityName = "Nothing";
  final cities = [
    "Multan",
    "Lahore",
    "Faisalabad",
    "Islamabad",
    "Pindi",
    "Bahawalpur",
    "Karachi",
    "Kashmir",
  ];
  final recentCities = [
    "Multan",
    "Lahore",
    "Faisalabad",
    "Islamabad",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // jese hi search per click kren gy oski jagha ye button ly ly ga
    // ye button right side per aye ga
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // AppBar k left me kon sa icon lgana he
    // jese hi search per click kiya left per back arrow show hoga
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // jesy hi List tiles per click kren gy to ye kam ho ga
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.40,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FittedBox(
                  child: Image.asset("assets/images/$cityName.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              descriptionList[0]["$cityName"],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //todo: jb user search per click kre
    // ager user ne abhi koch enter nahi kiya to "recentCites" show kraye ga nahi to "Cities" ki list"
    String queryText = "";
    if (query.length > 0) {
      // pehle charecter ko capital or baki ko small me likhne k liye
      queryText = "${query.substring(0, 1).toUpperCase()}" +
          query.substring(1).toLowerCase();
    }
    // search option me jo type kren gy wo "query" me aye ga, ye "query" build_in keyword he
    final suggestionList = query.isEmpty
        ? recentCities
        : cities.where((result) => result.startsWith(queryText)).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          // oper showResult function me functionality define kren gy
          cityName = suggestionList[index];
          showResults(context);
        },
        leading: Icon(Icons.location_city),
        // RichText used for style the particuler part of the string
        title: RichText(
          text: TextSpan(
              // style for first part of the string
              text: suggestionList[index].substring(0, query.length),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                // style for second part of the string
                TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.black54)),
              ]),
        ),
      ),
    );
  }
}
