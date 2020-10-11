<?php

if (isset($_POST['submit'])) {

    require_once("connect.php");

    $county_code = $_POST['county_code'];
    $state_code = $_POST['state_code'];
    $year = $_POST['year'];

    $query = "CALL locationYearPollution(:county_code, :state_code, :year)";

try
    {
        
      $prepared_stmt2 = $dbo->prepare($query);
      $prepared_stmt2->bindValue(':county_code', $county_code, PDO::PARAM_INT);
      $prepared_stmt2->bindValue(':state_code', $state_code, PDO::PARAM_INT);
      $prepared_stmt2->bindValue(':year', $year, PDO::PARAM_INT);
      $prepared_stmt2->execute();
      $result = $prepared_stmt2->fetchAll();

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
  if ($result && $prepared_stmt2->rowCount() > 0) { ?>
    
    <h2>Results</h2>

    <table>
      <thead>
		<tr>
		  <th>county_code</th>
		  <th>state_code</th>
		  <th>year</th>
          <th>parameter_name</th>
          <th>units_of_measure</th>
		  <th>arithmetic_mean</th>
		  <th>first_max_value</th>
          <th>first_max_datetime</th>
          <th>seventy_five_percentile</th>
		</tr>
      </thead>
      <tbody>
  
<?php foreach ($result as $row) { ?>
      
      <tr>
		<td><?php echo $row["county_code"]; ?></td>
		<td><?php echo $row["state_code"]; ?></td>
		<td><?php echo $row["year"]; ?></td>
        <td><?php echo $row["parameter_name"]; ?></td>
        <td><?php echo $row["units_of_measure"]; ?></td>
		<td><?php echo $row["arithmetic_mean"]; ?></td>
		<td><?php echo $row["first_max_value"]; ?></td>
        <td><?php echo $row["first_max_datetime"]; ?></td>
        <td><?php echo $row["seventy_five_percentile"]; ?></td>
      </tr>
<?php } ?>
      </tbody>
  </table>
  
<?php } else { ?>
    > No results found for <?php echo $_POST['county_code']; ?> <?php echo $_POST['state_code']; ?> <?php echo $_POST['year']; ?>.
  <?php }
} ?>

<h1> Pollutant Information by Location and Year </h1>

    <form method="post">

        <label for="county_code">county_code</label>
        <input type="text" name="county_code" id="county_code">

        <label for="state_code">state_code</label>
        <input type="text" name="state_code" id="state_code">

        <label for="year">year</label>
        <input type="text" name="year" id="year">
        
        <input type="submit" name="submit" value="Submit">
    </form>
