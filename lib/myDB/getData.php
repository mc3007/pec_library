
<?php

require('connection.php');
$makeQuery="Select * FROM  booksdetails";
$statement=$connection->prepare($makeQuery);
$statement->execute();
$myarray=array();
while($resultsFrom = $statement ->fetch()){
    array_push(
        $myarray,array(
            "BookID"=>$resultsFrom['BookID'],
            "BookNmae"=>$resultsFrom['BookName'],
            "AuthorName"=>$resultsFrom['AuthorName'],
            "Edition"=>$resultsFrom['Edition'],
            "Location"=>$resultsFrom['Location'],
            "Availability"=>$resultsFrom['Availability'],
            "CoverPage"=>$resultsFrom['CoverPage'],
            "Branch"=>$resultsFrom['Branch'],
            "Semester"=>$resultsFrom['Semester'],
            "Description"=>$resultsFrom['Description']
        )
    );
}

echo json_encode($myarray);

?>