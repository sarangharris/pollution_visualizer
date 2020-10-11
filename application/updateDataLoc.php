<?php

if (isset($_POST['submit'])) {

    require_once("connect.php");

    $parameter_code = $_POST['parameter_code'];
    $poc = $_POST['poc'];
    $parameter_name = $_POST['parameter_name'];

    $query = "UPDATE air_quality_db.ParameterInfo SET parameter_name=:parameter_name WHERE parameter_code=:parameter_code AND poc=:poc";

try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindValue(':parameter_code', $parameter_code, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':poc', $poc, PDO::PARAM_INT);
      $prepared_stmt->bindValue(':parameter_name', $parameter_name, PDO::PARAM_STR);
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

<h1> Crowdsource parameter_name Updates </h1>

    <form method="post">
        <label for="parameter_code">parameter_code</label>
        <input type="text" name="parameter_code" id="parameter_code">

        <label for="poc">poc</label>
        <input type="text" name="poc" id="poc">

        <label for="parameter_name">parameter_name</label>
        <input type="text" name="parameter_name" id="parameter_name">
        
        <input type="submit" name="submit" value="Submit">
    </form>
