import 'package:flutter/material.dart';
import 'package:parkassist/boundary/infoInterface.dart';
import 'package:parkassist/boundary/map_interface.dart';
import 'package:parkassist/control/searchController.dart';
import 'package:parkassist/entity/carParkList.dart';
import 'package:parkassist/control/carParkController.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SearchInterface extends StatefulWidget {
  const SearchInterface({super.key});

  @override
  State<SearchInterface> createState() => _SearchInterfaceState();
}

class _SearchInterfaceState extends State<SearchInterface>{

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CarPark>>(
      future: CarParkController().getAllCarparks(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Search'),
            actions:[
              IconButton(
                icon: Icon(Icons.search),
                tooltip: 'Search',
                onPressed: (){
                   showSearch(
                     context: context, 
                     delegate: CustomSearchDelegate(),
                   );
                }
              ),
            ],
          ),

          body: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index){
              if (snapshot.hasData) {
                return Container(
                  height: 75,
                  color: Colors.white,
                  child: Center(
                    child: Text(snapshot.data![index].development!),
                  ),
                );
              }
              else if (snapshot.hasError){
                return Text(snapshot.error.toString());
              }
              return const CircularProgressIndicator();
            }
          )
        );
      }
    );
  }
}


class CustomSearchDelegate extends SearchDelegate{
  final CarParkController carParkController = CarParkController();
  List<String> developments = SearchController.getCarparkDevelopments(CarParkList as CarParkList);

  @override
  List<Widget> buildActions(BuildContext context){
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        //clear query on press
          onPressed: (){
            query = '';
          },
      )
    ];
  }
  
  @override
  Widget buildLeading(BuildContext context){
  //leave and close search bar
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: (){
        close(context,null);
      },   
    );
  }

  @override
  Widget buildResults(BuildContext context){
    List<String> matchQuery = [];

    for (var word in developments){
      if (word.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(word);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context,index){
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var word in developments) {
      if (word.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(word);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MapInterface()))
        );
          //onpress
      },
    );
  }
}




//           return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Container(
//                   height: 75,
//                   color: Colors.white,
//                   child: Center(
//                     child: Text(snapshot.data![index].development!),
//                   ),
//                 );
//               });
//         } else if (snapshot.hasError) {
//           return Text(snapshot.error.toString());
//         }
//         // By default show a loading spinner.
//         return const CircularProgressIndicator();
//       },
//     );
//   }  
// }




// class SearchHome extends StatefulWidget{
//   const SearchHome({super.key});

  

//   @override
//   State<SearchInterface> createState() => _SearchInterfaceState();
// }




  



/*
class _SearchInterfaceState extends State<SearchInterface>{

 // List<String> developments = SearchController.getCarparkDevelopments(carParkList);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search)'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate(),);
            },
            icon: const Icon(Icons.search),
            ),
        ],
      )
    );

  }
}

class CustomSearchDelegate extends SearchDelegate{
  final CarParkController carParkController = CarParkController();
  List<String> developments = SearchController.getCarparkDevelopments(CarParkList as CarParkList);

  @override
  List<Widget> buildActions(BuildContext context){
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        //clear query on press
          onPressed: (){
            query = '';
          },
      )
    ];
  }
  
  @override
  Widget buildLeading(BuildContext context){
  //leave and close search bar
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: (){
        close(context,null);
      },   
    );
  }

  @override
  Widget buildResults(BuildContext context){
    List<String> matchQuery = [];

    for (var word in developments){
      if (word.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(word);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context,index){
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var word in developments) {
      if (word.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(word);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MapInterface()))
        );
          //onpress
      },
    );
  }
}




  Widget build(BuildContext context) {
    return FutureBuilder<List<CarPark>>(
      future: CarParkController().getAllCarparks() ,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 75,
                  color: Colors.white,
                  child: Center(
                    child: Text(snapshot.data![index].development!),
                  ),
                );
              });
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        // By default show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }



  */