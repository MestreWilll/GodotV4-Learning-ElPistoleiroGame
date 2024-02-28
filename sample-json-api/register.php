<?php
parse_str(file_get_contents("php://input"), $postData);
$name = $postData['name'];
$score = $postData['score'];
$file = 'players.csv';
// Read the entire file and find the highest ID for autoincrement
$lines = file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
$lastId = 0;
foreach ($lines as $line) {
    $data = explode(",", $line);
    $id = (int)$data[0];
    if ($id > $lastId) {
        $lastId = $id;
    }
}
$newId = $lastId + 1;
// Format the new data to append
$formattedData = $newId . "," . $name . "," . $score . "\n";
file_put_contents($file, $formattedData, FILE_APPEND | LOCK_EX);
