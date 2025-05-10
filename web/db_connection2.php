<?php
$host = "mysql-production-51e4.up.railway.app";
$port = 21309;
$dbname = "railway";
$username = "root";
$password = "zaALEriFluOTWULNohJASdmshoehCvwZ"; // Senin şifren

try {
    $conn = new PDO("mysql:host=$host;port=$port;dbname=$dbname;charset=utf8mb4", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $conn->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
} catch (PDOException $e) {
    die("Bağlantı hatası: " . $e->getMessage());
}
?>
