import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pec_library/book.dart';
import 'package:pec_library/bookapi.dart';
import 'package:pec_library/requestNewBook.dart';
import 'package:pec_library/useraccount.dart';
import 'package:pec_library/wishlist.dart';
import 'package:romanice/romanice.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


Future getList() async {
  String theUrl = "https://peclibrary.000webhostapp.com/getData.php";
  var res = await http
      .get(Uri.parse(theUrl), headers: {"Accept": "application/json"});
  var responseBody = json.decode(res.body);
  return responseBody;
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ToRoman standardToRoman = ToRoman.standard();
  int _index=0;
  List snap;

  Future<void> refreshList() async {
    await getList();
    setState(() {});
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Material(
              child: ListView(
            children: <Widget>[
              DrawerHeader(child: SvgPicture.asset('assets/books.svg')),
              ListTile(
                title: Text('Wishlist'),
                leading: Icon(Icons.favorite),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Wishlist();
                  }));
                },
              ),
              ListTile(
                title: Text('Request new book'),
                leading: Icon(Icons.library_books),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RequestNewBook();
                  }));
                },
              ),
              ListTile(
                title: Text('User Account'),
                leading: Icon(Icons.person),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return UserAccount();
                  }));
                },
              )
            ],
          )),
        ),
        appBar: AppBar(
          title: Text('PEC Library'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: Search());
                }),
            IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Wishlist();
                  }));
                })
          ],
        ),
        body: Scrollbar(
          child: RefreshIndicator(
            onRefresh: refreshList,
            child: FutureBuilder(
                future: getList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  snap = snapshot.data;

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error fetching data"),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: GridView.builder(
                        itemCount: snap.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: (1 / 1.5),
                        ),
                        itemBuilder: (context, index) {
                          _index=index;
                          String img='${snap[index]['CoverPage']}';
                           return Card(
                             elevation: 2,
                             child: GridTile(
                                 child: Hero(
                                   tag: img,
                                   child: GestureDetector(
                                       onTap: () {
                                         _index=index;
                                         return showSheet();
                                         },
                                     child: Image.network(
                                       '$img',
                                       loadingBuilder: (context, child, progress) => progress == null ? child : Center(child: CircularProgressIndicator()),
                                     ),
                                   ),
                                 ),
                             footer: GridTileBar(
                               backgroundColor: Colors.black38,
                                 title: Text(
                                   '${snap[index]['BookName']}',
                                   overflow: TextOverflow.ellipsis,
                                   maxLines: 1,
                                   style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               subtitle: Text(
                                 '${snap[index]['AuthorName']}',
                                 overflow: TextOverflow.ellipsis,
                                 maxLines: 1,
                                 style: TextStyle(
                                   fontWeight: FontWeight.bold,
                                   color: Colors.lightBlueAccent
                                 ),
                               ),
                             ),),
                           );
                          // Card(
                          //   elevation: 2,
                          //   child: InkWell(
                          //     onTap: () {
                          //       _index=index;
                          //       return showSheet();
                          //     },
                          //     splashColor: Colors.blue.withAlpha(30),
                          //     child: Column(
                          //       mainAxisSize: MainAxisSize.min,
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceAround,
                          //       children: <Widget>[
                          //         //Image.asset('assets/BookCover.jpg'),
                          //         Center(
                          //           child: Image.network(
                          //             '${snap[index]['CoverPage']}',
                          //             //fit: BoxFit.cover,
                          //             width: 350,
                          //             height: 180,
                          //             loadingBuilder: (context, child, progress) => progress == null ? child : Center(child: CircularProgressIndicator()),
                          //           ),
                          //         ),
                          //         ListTile(
                          //           title: Text(
                          //             '${snap[index]['BookName']}',
                          //             overflow: TextOverflow.ellipsis,
                          //             maxLines: 1,
                          //           ),
                          //           subtitle: Text(
                          //             '${snap[index]['AuthorName']}',
                          //             overflow: TextOverflow.ellipsis,
                          //             maxLines: 1,
                          //           ),
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // );
                        }),
                  );
                }),
          ),
        ));
  }

  Future showSheet() => showSlidingBottomSheet(context,
      builder: (context) => SlidingSheetDialog(
            avoidStatusBar: true,
            cornerRadius: 16,
            snapSpec: SnapSpec(
              snappings: [1],
            ),
            builder: bookDetails,
            headerBuilder: header,
          ));

  Widget bookDetails(context, state) {
    String img='${snap[_index]['CoverPage']}';
    return Material(
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Stack(
              children: <Widget>[
                Hero(
                    tag: img,
                    child:  Center(
                      child: Image.network('$img',
                        width: 350,
                        height: 180,
                        loadingBuilder: (context, child, progress) => progress == null ? child : Center(child: CircularProgressIndicator()),),
                   )
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.favorite), onPressed: () {}),
                        IconButton(
                            color: Colors.lightBlueAccent,
                            icon: Icon(Icons.share),
                            onPressed: () {})
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text('${snap[_index]['BookName']}'),
                Text('${snap[_index]['AuthorName']}'),
                Text('${snap[_index]['Edition']}'),
                Text('Year'),
                Text('${snap[_index]['Semester']}'),
                Text('${snap[_index]['Branch']}'),
                Text('${snap[_index]['Availability']}'),
                Text('${snap[_index]['Description']}'),
                Text('${snap[_index]['Location']}'),
                Text('Book Tile'),
                Text('Book Tile'),
                Text('Book Tile'),
                Text('Book Tile'),
                Text('Book Tile'),
                Text('Book Tile'),
                Text('Book Tile'),
                Text('Book Tile'),
                Text('Book Tile'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget header(BuildContext context, SheetState state) => Material(
        child: Container(
          height: kToolbarHeight,
          color: Colors.blueAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  width: 32,
                  height: 8,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
        ),
      );
}


class Search extends SearchDelegate<String> {

  @override
  List<Widget> buildActions(BuildContext context) {
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
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {

    int _index=0;

    if(query.isEmpty){
      return Container(
          child: Center(
            child: Text("Books"),
          )
      );
    };

    return FutureBuilder(
        future: BooksApi.getBooks(query),
        builder: (context , snapshot){
          final List<Book> snap=snapshot.data;
          if(snapshot.connectionState==ConnectionState.waiting) {
            return Container(
              child: Center(
                  child: CircularProgressIndicator()
              ),
            );
          }
          if(snap==null ){
            return Container(
                child: Center(
                  child: Text("No results found"),
                )
            );
          };
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: (1 / 1.5),
              ),
            itemCount: snap.length,
              itemBuilder: (context, index){
                _index=index;
                return Card(
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                          _index=index;
                          return _HomePageState().showSheet();
                        },
                    splashColor: Colors.blue.withAlpha(30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Center(
                          child: Image.network(
                            '${snap[index].coverPage}',
                            //fit: BoxFit.cover,
                            width: 350,
                            height: 180,
                            loadingBuilder: (context, child, progress) => progress == null ? child : Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            '${snap[index].bookName}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            '${snap[index].authorName}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
          );
        }
    );
  }


  @override
  Widget buildSuggestions(BuildContext context) {

    if(query.isEmpty){
      return Container(
          child: Center(
            child: Text("Books"),
          )
      );
    };

    return FutureBuilder(
      future: BooksApi.getBooks(query),
        builder: (context , snapshot){
        final List<Book> snap=snapshot.data;
        if(snapshot.connectionState==ConnectionState.waiting) {
          return Container(
            child: Center(
                child: CircularProgressIndicator()
            ),
          );
        }
        if(snap==null ){
          return Container(
            child: Center(
              child: Text("No results found"),
            )
          );
        };
        return ListView.builder(
            itemCount: snap.length,
            itemBuilder: (context,index){
              print(snap.toList());
              return InkWell(
                onTap: (){},
                child: ListTile(
                  title: Text(snap[index].bookName),
                  subtitle: Text(snap[index].authorName),
                ),
              );
            }
        );
        }
    );
  }
}
