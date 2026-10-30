<?php
require __DIR__ . '/config.php';
$d = corps();

$stmt = db()->prepare('SELECT * FROM utilisateurs WHERE email = ?');
$stmt->execute([trim($d['email'] ?? '')]);
$u = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$u || !password_verify($d['mot_de_passe'] ?? '', $u['mot_de_passe_hash'])) {
    reponse(401, ['message' => 'E-mail ou mot de passe incorrect']);
}
reponse(200, utilisateurJson($u));