import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pec_library/book.dart';

class BooksApi {
  static Future<List<Book>> getBooks(String query) async {
    String theUrl = "https://peclibrary.000webhostapp.com/getData.php";
    var response = await http.get(Uri.parse(theUrl), headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      final List books = json.decode(response.body);
      return books.map((json) => Book.fromJson(json)).where((book){
            final titleLower= book.bookName.toLowerCase();
            final authorLower= book.authorName.toLowerCase();
            final lowerQuery= query.toLowerCase();

            return titleLower.contains(lowerQuery) || authorLower.contains(lowerQuery) ;
          }
      ).toList();
    } else {
      throw Exception();
    }
  }
}