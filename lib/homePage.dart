import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pec_library/requestNewBook.dart';
import 'package:pec_library/useraccount.dart';
import 'package:pec_library/wishlist.dart';
import 'package:romanice/romanice.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final ToRoman standardToRoman = ToRoman.standard();

  getList()async{
    String theUrl="https://peclibrary.000webhostapp.com/getData.php";
    var res= await http.get(Uri.parse(theUrl),headers: {"Accept": "application/json"});
    var responseBody= json.decode(res.body);
    return responseBody;
  }

    Future<void> refreshList()async{
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
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return Wishlist();
                }));
              },
            ),
            ListTile(
              title: Text('Request new book'),
              leading: Icon(Icons.library_books),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return RequestNewBook();
                }));
              },
            ),
            ListTile(
              title: Text('User Account'),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context){
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
                onPressed: (){
                  showSearch(context: context, delegate: Search());
                }),
            IconButton(
                icon: Icon(Icons.favorite),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
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
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  List snap=snapshot.data;

                  if(snapshot.connectionState== ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if(snapshot.hasError){
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
                          childAspectRatio: (1/1.5),
                        ),
                        itemBuilder: (context,index){
                          return Card(
                            elevation: 2,
                            child: InkWell(
                              onTap: showSheet,
                              splashColor: Colors.blue.withAlpha(30),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    //Image.asset('assets/BookCover.jpg'),
                                    Center(
                                      child: Image.network(
                                        '${snap[index]['CoverPage']}',
                                        //fit: BoxFit.cover,
                                        width: 350,
                                        height: 180,
                                        loadingBuilder: (context,child,progress)=> progress ==null ?
                                        child:Center(
                                          child: CircularProgressIndicator()),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text('${snap[index]['BookName']}',overflow: TextOverflow.ellipsis,maxLines: 2,),
                                      subtitle: Text('${snap[index]['AuthorName']}',overflow: TextOverflow.ellipsis,maxLines: 2,),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  );
                }),
          ),
        )
      );
  }
  Future showSheet() => showSlidingBottomSheet(
      context, builder: (context)=>SlidingSheetDialog(
      avoidStatusBar: true,
      cornerRadius: 16,
      snapSpec: SnapSpec(
        snappings: [0.85,0.95],
      ),
      builder: buildSheet,
    headerBuilder: header,
  )
  );
  Widget buildSheet(context, state) => Material(
    child: ListView(
      shrinkWrap: true,
      primary: false,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Stack(
            children: <Widget>[
              Image.asset('assets/BookCover.jpg'),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.favorite),
                          onPressed: (){}
                          ),
                      IconButton(
                        color: Colors.white,
                          icon: Icon(Icons.share),
                          onPressed: (){}
                          )
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
              Text('Book Tile'),
              Text('Author'),
              Text('Branch'),
              Text('Year'),
              Text('Semister'),
              Text('Availability'),
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

  Widget header(BuildContext context, SheetState state)=> Material(
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
                  borderRadius: BorderRadius.circular(20)
              ),
            ),
          ),
        ],
      ),
    ),
  );

}

class Search extends SearchDelegate<String>{

  final authors=['Chethan Bhagat', "Sudha Murthy", "Ruskin Bond"];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query="";
        })];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            progress: transitionAnimation),
        onPressed: (){
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final authorsList=authors;
    return ListView.builder(
        itemBuilder: (context, index)=>ListTile(
          leading:Icon(Icons.create),
          title: Text(authorsList[index]),
        ),
        itemCount: authorsList.length,
    );
  }

}
