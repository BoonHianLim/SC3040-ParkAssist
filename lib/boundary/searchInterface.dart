import 'package:flutter/material.dart';
import 'package:parkassist/control/searchController.dart';
import 'package:parkassist/entity/carParkList.dart';
import 'package:parkassist/control/carParkController.dart';
import 'dart:async';


class SearchInterface extends StatefulWidget {
  const SearchInterface({super.key});

  @override
  State<SearchInterface> createState() => _SearchInterfaceState();
}

class _SearchInterfaceState extends State<SearchInterface>{

  @override
  SearchController _devList = SearchController();
  @override
  void initState() {
    SearchController();
    super.initState();
  }


  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: Scaffold(
  //       appBar: AppBar(
  //         title: Text('UserList'),
  //         actions: [
  //           IconButton(
  //             onPressed: () {
  //               showSearch(context: context, delegate: CustomSearchDelegate());
  //             },
  //             icon: Icon(Icons.search_sharp),
  //           )
  //         ],
  //       ),
  //       body: Container(
  //         padding: EdgeInsets.all(20),
  //         child: FutureBuilder<List<CarPark>>(
  //             future: _devList.getDevList(),
  //             builder: (context, snapshot) {
  //               var data = snapshot.data;
  //               return ListView.builder(
  //                   itemCount: data?.length,
  //                   itemBuilder: (context, index) {
  //                     if (!snapshot.hasData) {
  //                       return Center(child: CircularProgressIndicator());
  //                     }
  //                     return Card(
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: ListTile(
  //                           title: Row(
  //                             children: [
  //                               Container(
  //                                 width: 60,
  //                                 height: 60,
  //                                 decoration: BoxDecoration(
  //                                   color: Colors.deepPurpleAccent,
  //                                   borderRadius: BorderRadius.circular(10),
  //                                 ),
  //                                 child: Center(
  //                                   child: Text(
  //                                     '${data?[index].carParkID}',
  //                                     style: TextStyle(
  //                                         fontSize: 20,
  //                                         fontWeight: FontWeight.bold,
  //                                         color: Colors.white),
  //                                   ),
  //                                 ),
  //                               ),
  //                               SizedBox(width: 20),
  //                               Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                       '${data?[index].development}',
  //                                       style: TextStyle(
  //                                           fontSize: 18,
  //                                           fontWeight: FontWeight.w600),
  //                                     ),
  //                                     SizedBox(height: 10),
  //                                     Text(
  //                                       '${data?[index].availableLots}',
  //                                       style: TextStyle(
  //                                         color: Colors.black,
  //                                         fontSize: 14,
  //                                         fontWeight: FontWeight.w400,
  //                                       ),
  //                                     ),
  //                                   ])
  //                             ],
  //                           ),
  //                           // trailing: Text('More Info'),
  //                         ),
  //                       ),
  //                     );
  //                   });
  //             }),
  //       ),
  //     ),
  //   );
  // }


  Widget build(BuildContext context) {
    return FutureBuilder<List<CarPark>>(
      future: CarParkController().getAllCarparks(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Search'),
            actions:[
              IconButton(
                icon: const Icon(Icons.search),
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
            itemCount: snapshot.data?.length,
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



class CustomSearchDelegate extends SearchDelegate {
  //final CarParkController carParkController = CarParkController();
  //Future<List<CarPark>> carparklist = CarParkController().getAllCarparks();
  List<String> test = ['Dog','Batok','HIllVIew'];
  //List<String> carparkdevelopment = SearchController.getCarparkDevelopments(developments);
  //List cars = await CarParkController().getAllCarparks();

  @override
  List<Widget> buildActions(BuildContext context){
    return [
      IconButton(
        //icon: Icon(Icons.close)
        //clear query on press
        onPressed: (){
            query = '';
          },
        icon: const Icon(Icons.close),
      )
    ];
  }
  
  @override
  Widget buildLeading(BuildContext context){
  //leave and close search bar
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: (){
        close(context, null);
      },   
    );
  }
  //   @override
  // Widget buildResults(BuildContext context){
  //   return FutureBuilder<List<CarPark>>(
  //     future:CarParkController().getAllCarparks(),
  //     builder: (context, snapshot) {
  //       List<String> matchQuery = [];
  //       List<String> devlist = [];
  //         for (int i = 0; i < snapshot.data!.length ; i++){
  //           for (int j = 0; j < snapshot.data![i].development!.length; j++){
  //             for(var word in snapshot.)
  //               if (word.toLowerCase().contains(query.toLowerCase())){
  //                 matchQuery.add(snapshot.data![i].development!);
  //             }
            
  //         }
  //         }
  //           return ListView.builder(
  //             itemCount: matchQuery.length,
  //             itemBuilder: (context,index){
  //               var result = matchQuery[index];
  //               return ListTile(
  //                 title: Text(result),
  //               );
  //             },
  //           );
  //     }
  //   );
  // }

  @override
  Widget buildResults(BuildContext context){
    return FutureBuilder<List<CarPark>>(
      //future:SearchController().getDevelopments()
      future: SearchController().getDevList(query: query),
      builder: (context, snapshot) {
         if (!snapshot.hasData) {
           return const Center(
             child: CircularProgressIndicator(),
              );
         }
        List<CarPark>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 56, 17, 165),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '${data?[index].carParkID}',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${data?[index].development}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${data?[index].availableLots}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ])
                    ],
                  ),
                );
              });
        });
  }

  @override
  Widget buildSuggestions(BuildContext context){
    return const Center(
      child: Text('Search Carpark'),
    );
    }

}


  //       List<String> carparks = SearchController().getCarparkDevelopments();
  //       List<String> matchQuery = [];

  //       for (var word in carparks){
  //         if (word.toLowerCase().contains(query.toLowerCase())){
  //           matchQuery.add(word);
  //       }
  //       }
  //       return ListView.builder(
  //         itemCount: matchQuery.length,
  //         itemBuilder: (context,index){
  //           var result = matchQuery[index];
  //           return ListTile(
  //             title: Text(result),
  //           );
  //         },
  //       );

  // }
  





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