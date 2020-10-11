<?php

if (isset($_POST['submit'])) {

    require_once("connect.php");

    $county_name = $_POST['county_name'];
    $state_name = $_POST['state_name'];

    $query = "CALL locationTranslator(:county_name, :state_name)";

try
    {
      $prepared_stmt = $dbo->prepare($query);
      $prepared_stmt->bindValue(':county_name', $county_name, PDO::PARAM_STR);
      $prepared_stmt->bindValue(':state_name', $state_name, PDO::PARAM_STR);
      $prepared_stmt->execute();
      $result = $prepared_stmt->fetchAll();

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

table {
  border-collapse: collapse;
  border-spacing: 0;
}

td, th {
  padding: 5px 30px 5px 30px;
  border-bottom: 1px solid #aaa;
}

</style>

<?php
if (isset($_POST['submit'])) {
  if ($result && $prepared_stmt->rowCount() > 0) { ?>
    
    <h2>Results</h2>

    <table>
      <thead>
		<tr>
		  <th>county_code</th>
		  <th>state_code</th>
		</tr>
      </thead>
      <tbody>
  
<?php foreach ($result as $row) { ?>
      
      <tr>
		<td><?php echo $row["county_code"]; ?></td>
		<td><?php echo $row["state_code"]; ?></td>
      </tr>
<?php } ?>
      </tbody>
  </table>
  
<?php } else { ?>
    > No results found for <?php echo $_POST['county_code']; ?> <?php echo $_POST['state_code']; ?>.
  <?php }
} ?>

<h1> County and State Codes </h1>

    <form method="post">

        <label for="county_name">county_name</label>
        <input type="text" name="county_name" id="county_name">

        <label for="state_name">state_name</label>
        <input type="text" name="state_name" id="state_name">
        
        <input type="submit" name="submit" value="Submit">
    </form>
