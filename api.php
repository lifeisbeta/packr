<?php
header('Content-Type: application/json');
session_start();

require __DIR__ . '/config.php';

try {
    $pdo = new PDO(
        "mysql:host=$db_host;dbname=$db_name;charset=utf8mb4",
        $db_user, $db_pass,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
         PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]
    );
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'DB connection failed']);
    exit;
}

$input  = json_decode(file_get_contents('php://input'), true) ?? [];
$action = $input['action'] ?? '';

function ok($data = [])   { echo json_encode($data); exit; }
function err($msg, $code = 400) { http_response_code($code); echo json_encode(['error' => $msg]); exit; }
function uid() {
    if (empty($_SESSION['user_id'])) err('Not authenticated', 401);
    return (int) $_SESSION['user_id'];
}

// ── AUTH ──────────────────────────────────────────────────────────────────────

if ($action === 'login') {
    $email    = trim($input['email'] ?? '');
    $password = $input['password'] ?? '';
    if (!$email || !$password) err('Email and password required');

    $st = $pdo->prepare('SELECT id, email, password_hash FROM users WHERE email = ?');
    $st->execute([$email]);
    $user = $st->fetch();

    if (!$user || !password_verify($password, $user['password_hash'])) err('Invalid email or password', 401);

    $_SESSION['user_id'] = $user['id'];
    ok(['user' => ['id' => $user['id'], 'email' => $user['email']]]);
}

if ($action === 'logout') {
    session_destroy();
    ok(['ok' => true]);
}

if ($action === 'me') {
    if (empty($_SESSION['user_id'])) err('Not authenticated', 401);
    $st = $pdo->prepare('SELECT id, email FROM users WHERE id = ?');
    $st->execute([$_SESSION['user_id']]);
    $user = $st->fetch();
    if (!$user) err('User not found', 401);
    ok(['user' => $user]);
}

if ($action === 'register') {
    $email    = trim($input['email'] ?? '');
    $password = $input['password'] ?? '';
    if (!$email || !$password) err('Email and password required');
    if (strlen($password) < 6) err('Password must be at least 6 characters');

    $st = $pdo->prepare('SELECT id FROM users WHERE email = ?');
    $st->execute([$email]);
    if ($st->fetch()) err('An account with that email already exists');

    $hash = password_hash($password, PASSWORD_DEFAULT);
    $st = $pdo->prepare('INSERT INTO users (email, password_hash) VALUES (?, ?)');
    $st->execute([$email, $hash]);
    $userId = $pdo->lastInsertId();

    $_SESSION['user_id'] = $userId;
    ok(['user' => ['id' => $userId, 'email' => $email]]);
}

if ($action === 'change_password') {
    $userId = uid();
    $current = $input['current'] ?? '';
    $new     = $input['new'] ?? '';
    if (!$current || !$new) err('Both current and new password required');
    if (strlen($new) < 6) err('New password must be at least 6 characters');

    $st = $pdo->prepare('SELECT password_hash FROM users WHERE id = ?');
    $st->execute([$userId]);
    $user = $st->fetch();
    if (!$user || !password_verify($current, $user['password_hash'])) err('Current password is incorrect');

    $st = $pdo->prepare('UPDATE users SET password_hash = ? WHERE id = ?');
    $st->execute([password_hash($new, PASSWORD_DEFAULT), $userId]);
    ok(['ok' => true]);
}

// ── TRIPS ─────────────────────────────────────────────────────────────────────

if ($action === 'trips_list') {
    $userId = uid();
    $st = $pdo->prepare('SELECT id, name, data, is_shared, created_at FROM trips WHERE user_id = ? AND name != ? ORDER BY created_at DESC');
    $st->execute([$userId, '__trip_defaults__']);
    $rows = $st->fetchAll();
    foreach ($rows as &$r) $r['data'] = json_decode($r['data'], true);
    ok($rows);
}

if ($action === 'trip_save') {
    $userId = uid();
    $id       = $input['id'] ?? '';
    $name     = $input['name'] ?? '';
    $data     = $input['data'] ?? [];
    $isShared = !empty($input['is_shared']) ? 1 : 0;
    if (!$id || !$name) err('id and name required');

    $st = $pdo->prepare('INSERT INTO trips (id, user_id, name, data, is_shared) VALUES (?,?,?,?,?)
        ON DUPLICATE KEY UPDATE name=VALUES(name), data=VALUES(data), is_shared=VALUES(is_shared)');
    $st->execute([$id, $userId, $name, json_encode($data), $isShared]);
    ok(['ok' => true]);
}

if ($action === 'trip_delete') {
    $userId = uid();
    $id = $input['id'] ?? '';
    if (!$id) err('id required');
    $st = $pdo->prepare('DELETE FROM trips WHERE id = ? AND user_id = ?');
    $st->execute([$id, $userId]);
    ok(['ok' => true]);
}

if ($action === 'trip_share') {
    $userId = uid();
    $id = $input['id'] ?? '';
    if (!$id) err('id required');
    $st = $pdo->prepare('UPDATE trips SET is_shared = 1 WHERE id = ? AND user_id = ?');
    $st->execute([$id, $userId]);
    ok(['ok' => true]);
}

if ($action === 'trip_get_public') {
    $id = $input['id'] ?? '';
    if (!$id) err('id required');
    $st = $pdo->prepare('SELECT id, name, data FROM trips WHERE id = ? AND is_shared = 1');
    $st->execute([$id]);
    $row = $st->fetch();
    if (!$row) err('Not found', 404);
    $row['data'] = json_decode($row['data'], true);
    ok($row);
}

// ── DEFAULTS (stored as a special trip row) ───────────────────────────────────

if ($action === 'defaults_get') {
    $userId = uid();
    $defId  = $userId . '_defaults';
    $st = $pdo->prepare('SELECT data FROM trips WHERE id = ?');
    $st->execute([$defId]);
    $row = $st->fetch();
    ok($row ? json_decode($row['data'], true) : null);
}

if ($action === 'defaults_save') {
    $userId = uid();
    $defId  = $userId . '_defaults';
    $data   = $input['data'] ?? [];
    $st = $pdo->prepare('INSERT INTO trips (id, user_id, name, data, is_shared) VALUES (?,?,?,?,0)
        ON DUPLICATE KEY UPDATE data=VALUES(data)');
    $st->execute([$defId, $userId, '__trip_defaults__', json_encode($data)]);
    ok(['ok' => true]);
}

// ── GEAR INVENTORY ────────────────────────────────────────────────────────────

if ($action === 'gear_list') {
    $userId = uid();
    $st = $pdo->prepare('SELECT id, name, cat, weight, qty, cost, url, sort_order FROM gear_inventory WHERE user_id = ? ORDER BY sort_order');
    $st->execute([$userId]);
    ok($st->fetchAll());
}

if ($action === 'gear_save') {
    $userId = uid();
    $id     = $input['id'] ?? '';
    if (!$id) err('id required');
    $st = $pdo->prepare('INSERT INTO gear_inventory (id, user_id, name, cat, weight, qty, cost, url, sort_order)
        VALUES (?,?,?,?,?,?,?,?,?)
        ON DUPLICATE KEY UPDATE name=VALUES(name), cat=VALUES(cat), weight=VALUES(weight),
        qty=VALUES(qty), cost=VALUES(cost), url=VALUES(url), sort_order=VALUES(sort_order)');
    $st->execute([
        $id, $userId,
        $input['name'] ?? '',
        $input['cat']  ?? '',
        $input['weight'] ?? 0,
        $input['qty']  ?? 1,
        $input['cost'] ?? 0,
        $input['url']  ?? '',
        $input['sort_order'] ?? 0
    ]);
    ok(['ok' => true]);
}

if ($action === 'gear_delete') {
    $userId = uid();
    $id = $input['id'] ?? '';
    if (!$id) err('id required');
    $st = $pdo->prepare('DELETE FROM gear_inventory WHERE id = ? AND user_id = ?');
    $st->execute([$id, $userId]);
    ok(['ok' => true]);
}

// ── LOADOUT TEMPLATES ─────────────────────────────────────────────────────────

if ($action === 'loadout_list') {
    $userId = uid();
    $st = $pdo->prepare('SELECT id, name, emoji, loadout, created_at FROM loadout_templates WHERE user_id = ? ORDER BY created_at');
    $st->execute([$userId]);
    $rows = $st->fetchAll();
    foreach ($rows as &$r) $r['loadout'] = json_decode($r['loadout'], true);
    ok($rows);
}

if ($action === 'loadout_save') {
    $userId = uid();
    $id     = $input['id'] ?? '';
    if (!$id) err('id required');
    $st = $pdo->prepare('INSERT INTO loadout_templates (id, user_id, name, emoji, loadout)
        VALUES (?,?,?,?,?)
        ON DUPLICATE KEY UPDATE name=VALUES(name), emoji=VALUES(emoji), loadout=VALUES(loadout)');
    $st->execute([
        $id, $userId,
        $input['name']  ?? '',
        $input['emoji'] ?? '🏕️',
        json_encode($input['loadout'] ?? [])
    ]);
    ok(['ok' => true]);
}

if ($action === 'loadout_delete') {
    $userId = uid();
    $id = $input['id'] ?? '';
    if (!$id) err('id required');
    $st = $pdo->prepare('DELETE FROM loadout_templates WHERE id = ? AND user_id = ?');
    $st->execute([$id, $userId]);
    ok(['ok' => true]);
}

// ── ADDONS ────────────────────────────────────────────────────────────────────

if ($action === 'addons_list') {
    $userId = uid();
    $st = $pdo->prepare('SELECT id, name, description, items, sort_order FROM addons WHERE user_id = ? ORDER BY sort_order');
    $st->execute([$userId]);
    $rows = $st->fetchAll();
    foreach ($rows as &$r) $r['items'] = json_decode($r['items'], true);
    ok($rows);
}

if ($action === 'addon_save') {
    $userId = uid();
    $id     = $input['id'] ?? '';
    if (!$id) err('id required');
    $st = $pdo->prepare('INSERT INTO addons (id, user_id, name, description, items, sort_order)
        VALUES (?,?,?,?,?,?)
        ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description),
        items=VALUES(items), sort_order=VALUES(sort_order)');
    $st->execute([
        $id, $userId,
        $input['name'] ?? '',
        $input['description'] ?? '',
        json_encode($input['items'] ?? []),
        $input['sort_order'] ?? 0
    ]);
    ok(['ok' => true]);
}

if ($action === 'addon_delete') {
    $userId = uid();
    $id = $input['id'] ?? '';
    if (!$id) err('id required');
    $st = $pdo->prepare('DELETE FROM addons WHERE id = ? AND user_id = ?');
    $st->execute([$id, $userId]);
    ok(['ok' => true]);
}

err('Unknown action');
