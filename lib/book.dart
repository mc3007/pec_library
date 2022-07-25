class Book {
  String bookID;
  String bookName;
  String authorName;
  String edition;
  String location;
  String availability;
  String coverPage;
  String branch;
  String semester;
  String description;

  Book(
      {this.bookID,
        this.bookName,
        this.authorName,
        this.edition,
        this.location,
        this.availability,
        this.coverPage,
        this.branch,
        this.semester,
        this.description});

  Book.fromJson(Map<String, dynamic> json) {
    bookID = json['BookID'];
    bookName = json['BookName'];
    authorName = json['AuthorName'];
    edition = json['Edition'];
    location = json['Location'];
    availability = json['Availability'];
    coverPage = json['CoverPage'];
    branch = json['Branch'];
    semester = json['Semester'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BookID'] = this.bookID;
    data['BookName'] = this.bookName;
    data['AuthorName'] = this.authorName;
    data['Edition'] = this.edition;
    data['Location'] = this.location;
    data['Availability'] = this.availability;
    data['CoverPage'] = this.coverPage;
    data['Branch'] = this.branch;
    data['Semester'] = this.semester;
    data['Description'] = this.description;
    return data;
  }
}
