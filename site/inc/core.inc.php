<?php
error_reporting(0);

function dbConnect() {
  static $connection;

  if(!isset($connection)) {
    include($_SERVER['DOCUMENT_ROOT'].'/inc/dbCredentials.inc.php');
    $connection = mysqli_connect("$DB_HOSTNAME","$DB_USERNAME","$DB_PASSWORD","$DB_DATABASE");
  }

  if($connection === false) { return mysqli_connect_error(); }
  return $connection;
}


function dbQuery($query) {
  $connection = dbConnect();
  $result = mysqli_query($connection,$query);
  return $result;
}


function dbSelect($query) {
  $rows = array();
  $result = dbQuery($query);

  if($result === false) { return false; }
  while ($row = mysqli_fetch_assoc($result)) { $rows[] = $row; }
  return $rows;
}


function dbCount($searchTerms, $table){
  $query_dbCount=dbSelect("SELECT COUNT(*) FROM $table WHERE $searchTerms");
  return $query_dbCount[0]['COUNT(*)'];
}

?>
