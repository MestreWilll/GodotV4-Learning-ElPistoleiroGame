<?php
parse_str(file_get_contents("php://input"), $postData);
$name = $postData['name'];
$score = $postData['score'];
$file = 'registro.txt';
$formattedData = "Nome: " . $name . ", Score: " . $score . "\n";
file_put_contents($file, $formattedData, FILE_APPEND | LOCK_EX);
