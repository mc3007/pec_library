import 'package:flutter/material.dart';

class Wishlist extends StatefulWidget{
  @override
  _WishlistState createState()=>_WishlistState();
}

class _WishlistState extends State<Wishlist>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            }),
        title: Text('Favourites'),
        centerTitle: true,
      ),
    );
  }
}