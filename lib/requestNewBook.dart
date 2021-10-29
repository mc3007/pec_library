import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RequestNewBook extends StatefulWidget{
  @override
  _RequestNewBook createState() => _RequestNewBook();
}

class _RequestNewBook extends State<RequestNewBook>{

  var formkey=GlobalKey<FormState>();
  TextEditingController bookname=TextEditingController();
  TextEditingController authorname=TextEditingController();
  TextEditingController booklink=TextEditingController();

  void clearText() {
    bookname.clear();
    authorname.clear();
    booklink.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request new book'),
      ),
      body: Form(
        key: formkey,
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: <Widget>[
               Container(
                 child: SvgPicture.asset(
                   'assets/new book.svg',
                   width: MediaQuery.of(context).size.width*0.40,
                   height: MediaQuery.of(context).size.height*0.40,
                 ),
               ),
               Padding(
                 padding: const EdgeInsets.symmetric(vertical: 10),
                 child: Expanded(
                   child: TextFormField(
                     maxLines: null,
                    keyboardType: TextInputType.text,
                    controller: bookname,
                    validator: (String value) {
                      if(value.isEmpty){
                        return 'Enter Book title';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Book title',
                        suffixIcon: IconButton(
                            icon: Icon(Icons.clear), onPressed: clearText),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
              ),
                 ),
               ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Expanded(
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    controller: authorname,
                    validator: (String value) {
                      if(value.isEmpty){
                        return 'Enter Author name';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Author',
                        suffixIcon: IconButton(
                            icon: Icon(Icons.clear), onPressed: clearText),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Expanded(
                  child: TextField(
                    controller: booklink,
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Amazon or Flipkart links of the book',
                        labelText: 'Book links',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),
              ),
              Center(
                child: RaisedButton(
                    color: Colors.blue,
                    onPressed: (){},
                    child: Text(
                      "Request",
                      style: TextStyle(color: Colors.white),
                    ),
                ),
              )
            ],
          ),
      ),
    );
  }

}