<?php

$dbhost = '127.0.0.1';
$dbuname = 'root';
$dbpass = 'root'; // windows users do not need username
$dbname = 'air_quality_db';

//Windows: $dbo = new PDO('mysql:host=' . $dbhost . ';port=3306;dbname=' . $dbname, $dbuname, $dbpass);
    
$dbo = new PDO('mysql:host=' . $dbhost . ';port=8889;dbname=' . $dbname, $dbuname, $dbpass);
?>
