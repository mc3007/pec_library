<?php

try{
$connection = new PDO('mysql:host=localhost'; dbname='id17839915_peclibrary','id17839915_chaithanya',')q5c#+q&$b2hTggZ');
$connection ->setAttribute(PDO::Attr_ERRMODE,PDO::ERRMODE_EXCEPTION);
echo("connected");
}catch(PDOException $exc){
echo $exc->getMessage();
die("could not connect");
}
?>