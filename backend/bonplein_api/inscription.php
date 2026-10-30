<?php
require __DIR__ . '/config.php'; // outils communs
$d = corps();                    // données envoyées par Flutter

// Cherche l'utilisateur correspondant à l'e-mail
$stmt = db()->prepare('SELECT * FROM utilisateurs WHERE email = ?');
$stmt->execute([trim($d['email'] ?? '')]);
$u = $stmt->fetch(PDO::FETCH_ASSOC);

// Refuse si l'e-mail n'existe pas OU si le mot de passe ne correspond pas au hash.
// Même message dans les deux cas, pour ne pas révéler quels e-mails existent.
if (!$u || !password_verify($d['mot_de_passe'] ?? '', $u['mot_de_passe_hash'])) {
    reponse(401, ['message' => 'E-mail ou mot de passe incorrect']);
}

// Tout est bon : on renvoie les infos de l'utilisateur
reponse(200, utilisateurJson($u));