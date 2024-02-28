<?php

// Improved reading of players from a .csv file using array_map and file
$players = array_map(function($data) {
    // Splitting the data by comma and ensuring correct encoding
    $data = array_map("trim", explode(",", $data));
    return [
        "id" => $data[0],
        "nickname" => $data[1],
        "score" => (int)$data[2], // Casting score to integer for proper comparison
    ];
}, file('players.csv', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES));

// Optimized function to get player by ID using array_filter
function getPlayerById($id) {
  global $players;
  $filteredPlayers = array_filter($players, function($player) use ($id) {
    return $player["id"] == $id;
  });
  return $filteredPlayers ? array_values($filteredPlayers)[0] : null;
}

// Optimized function to get the top score using array_column and max
function getTopScore() {
  global $players;
  return max(array_column($players, 'score'));
}

// Simplified function to get the score table, no change needed
function getScoreTable() {
  global $players;
  return $players;
}

// Processing the request with a more concise approach
$response = null;

if (isset($_GET["id"])) {
  $response = getPlayerById($_GET["id"]);
} elseif (isset($_GET["topscore"])) {
  $response = ["top_score" => getTopScore()];
} else {
  $response = getScoreTable();
}

// Setting the response header as JSON
header('Content-Type: application/json');

// Encoding and printing the data in JSON, simplified with a single echo
echo json_encode($response ?: ["error" => "Invalid parameters"]);

?>

