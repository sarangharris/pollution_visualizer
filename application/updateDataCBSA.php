<?php

if (isset($_POST['submit'])) {

    require_once("connect.php");

    $address = $_POST['address'];
    $cbsa_name = $_POST['cbsa_name'];

    $query = "UPDATE air_quality_db.SiteChanges SET cbsa_name=:cbsa_name WHERE address=:address";

try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindValue(':address', $address, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':cbsa_name', $cbsa_name, PDO::PARAM_STR);
      $prepared_stmt->execute();
    }
    catch (PDOException $ex)
    { // Error in database processing.
      echo $sql . "<br>" . $error->getMessage(); // HTTP 500 - Internal Server Error
    }
}
?>

<style>
label {
  display: block;
  margin: 5px 0;
}

</style>

<h1> Crowdsource cbsa_name Updates </h1>

    <form method="post">
        <label for="address">address</label>
        <input type="text" name="address" id="address">

        <label for="cbsa_name">cbsa_name</label>
        <input type="text" name="cbsa_name" id="cbsa_name">
        
        <input type="submit" name="submit" value="Submit">
    </form>
