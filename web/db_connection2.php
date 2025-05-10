<?php
// db_connection.php

$host = "mysql-production-51e4.up.railway.app"; // Railway MySQL public URL
$port = 21309;  // Railway tarafından sağlanan port numarası
$dbname = "railway"; // Veritabanı adı
$username = "root";  // Kullanıcı adı
$password = "zaALEriFluOTWULNohJASdmshoehCvwZ";  // Şifre

try {
    // PDO ile MySQL bağlantısı oluştur
    $conn = new PDO("mysql:host=$host;port=$port;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $conn->exec("SET NAMES 'utf8'");
} catch (PDOException $e) {
    die("Bağlantı hatası: " . $e->getMessage());
}

?>
