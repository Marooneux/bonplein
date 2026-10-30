<?php
// Toutes les réponses de l'API seront du JSON en UTF-8
header('Content-Type: application/json; charset=utf-8');

// Ouvre la connexion à la base MySQL avec les identifiants de config.local.php
function db(): PDO {
    $c = require __DIR__ . '/config.local.php'; // charge hôte, base, user, mot de passe
    return new PDO(
        "mysql:host={$c['host']};dbname={$c['dbname']};charset=utf8mb4",
        $c['user'],
        $c['password'],
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION] // lance une exception en cas d'erreur SQL
    );
}

// Envoie une réponse JSON avec un code HTTP (200, 400, 401...) puis arrête le script
function reponse(int $code, array $data): never {
    http_response_code($code);
    echo json_encode($data);
    exit;
}

// Lit le JSON envoyé par Flutter et le transforme en tableau PHP
function corps(): array {
    return json_decode(file_get_contents('php://input'), true) ?? [];
}

// Transforme une ligne de la table en JSON pour Flutter
// (sans le mot de passe, qui ne doit jamais être renvoyé)
function utilisateurJson(array $u): array {
    return [
        'email' => $u['email'],
        'nom' => $u['prenom'] . ' ' . $u['nom'],   // "Jean Dupont"
        'membre_depuis' => $u['cree_le'],
        'signalements' => (int)$u['signalements'],
        'km_economises' => (float)$u['km_economises'],
        'economies' => (float)$u['economies'],
        'est_contributeur_actif' => (bool)$u['est_contributeur_actif'],
    ];
}

// Si une erreur PHP survient, on l'écrit dans le journal
// et on renvoie un message neutre (sans détails sensibles)
set_exception_handler(function (Throwable $e) {
    error_log($e->getMessage());
    reponse(500, ['message' => 'Erreur serveur']);
});