<?php

// Array of players
$players = [
  [
    "id" => 1,
    "nickname" => "player1",
    "score" => 100,
  ],
  [
    "id" => 2,
    "nickname" => "player2",
    "score" => 200,
  ],
  [
    "id" => 3,
    "nickname" => "player3",
    "score" => 300,
  ],
];

// Function to get player by ID
function getPlayerById($id) {
  global $players;
  foreach ($players as $player) {
    if ($player["id"] == $id) {
      return $player;
    }
  }
  return null;
}

// Function to get the top score
function getTopScore() {
  global $players;
  $topScore = 0;
  foreach ($players as $player) {
    if ($player["score"] > $topScore) {
      $topScore = $player["score"];
    }
  }
  return $topScore;
}

// Function to get the score table
function getScoreTable() {
  global $players;
  return $players;
}

// Processing the request
$player = null;
$topScore = null;
$scoreTable = null;

if (isset($_GET["id"])) {
  $player = getPlayerById($_GET["id"]);
} elseif (isset($_GET["topscore"])) {
  $topScore = getTopScore();
} else {
  $scoreTable = getScoreTable();
}

// Setting the response header as JSON
header('Content-Type: application/json');

// Encoding and printing the data in JSON
if ($player) {
  echo json_encode($player);
} elseif ($topScore) {
  echo json_encode(["top_score" => $topScore]);
} elseif ($scoreTable) {
  echo json_encode($scoreTable);
} else {
  echo json_encode(["error" => "Invalid parameters"]);
}

?>
