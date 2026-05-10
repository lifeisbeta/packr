<?php
/**
 * One-time setup script — run once after deploying to DreamHost.
 * Sets the password for jesse@jessehaynes.com.
 *
 * Usage:
 *   https://packr.jessehaynes.com/setup.php
 *
 * DELETE THIS FILE after running it.
 */

// Very basic protection — change this token before uploading
define('SETUP_TOKEN', 'packr-setup-2024');

require __DIR__ . '/config.php';

$token = $_GET['token'] ?? '';
if ($token !== SETUP_TOKEN) {
    http_response_code(403);
    die('Forbidden. Add ?token='.SETUP_TOKEN.' to the URL.');
}

try {
    $pdo = new PDO(
        "mysql:host=$db_host;dbname=$db_name;charset=utf8mb4",
        $db_user, $db_pass,
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );
} catch (PDOException $e) {
    die('DB connection failed: ' . $e->getMessage());
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $password = $_POST['password'] ?? '';
    $confirm  = $_POST['confirm']  ?? '';

    if (strlen($password) < 8) {
        $error = 'Password must be at least 8 characters.';
    } elseif ($password !== $confirm) {
        $error = 'Passwords do not match.';
    } else {
        $hash = password_hash($password, PASSWORD_DEFAULT);
        $st = $pdo->prepare('UPDATE users SET password_hash = ? WHERE email = ?');
        $st->execute([$hash, 'jesse@jessehaynes.com']);
        $done = true;
    }
}

// Check current state
$st = $pdo->prepare('SELECT id, email, password_hash FROM users');
$st->execute();
$users = $st->fetchAll(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>Packr Setup</title>
<style>
body{font-family:-apple-system,sans-serif;max-width:480px;margin:60px auto;padding:0 20px;color:#1a1a1a}
h1{font-size:22px;margin-bottom:6px}
p{color:#555;font-size:14px;margin-bottom:1.5rem}
label{display:block;font-size:13px;font-weight:500;margin-bottom:4px;margin-top:12px}
input{width:100%;padding:9px 12px;border:1px solid #ccc;border-radius:6px;font-size:14px;box-sizing:border-box}
button{margin-top:16px;width:100%;padding:10px;background:#1a1a1a;color:#fff;border:none;border-radius:6px;font-size:14px;cursor:pointer}
.error{color:#e53e3e;font-size:13px;margin-top:8px}
.success{background:#f0fff4;border:1px solid #9ae6b4;border-radius:8px;padding:14px;margin-top:16px;font-size:14px}
table{width:100%;border-collapse:collapse;margin-top:1rem;font-size:13px}
td,th{padding:6px 8px;border-bottom:1px solid #eee;text-align:left}
th{color:#555;font-weight:500}
</style>
</head>
<body>

<h1>🧳 Packr Setup</h1>
<p>Set the password for your Packr account. Delete this file when done.</p>

<?php if (!empty($done)): ?>
  <div class="success">
    ✅ Password updated successfully for <strong>jesse@jessehaynes.com</strong>.<br><br>
    <strong>Important:</strong> Delete <code>setup.php</code> from the server now.
  </div>
<?php else: ?>
<form method="POST">
  <label>New Password (min 8 characters)</label>
  <input type="password" name="password" required/>
  <label>Confirm Password</label>
  <input type="password" name="confirm" required/>
  <button type="submit">Set Password</button>
  <?php if (!empty($error)): ?>
    <p class="error"><?= htmlspecialchars($error) ?></p>
  <?php endif; ?>
</form>
<?php endif; ?>

<h2 style="margin-top:2rem;font-size:16px">Users in database</h2>
<table>
  <tr><th>ID</th><th>Email</th><th>Has Password</th></tr>
  <?php foreach ($users as $u): ?>
  <tr>
    <td><?= $u['id'] ?></td>
    <td><?= htmlspecialchars($u['email']) ?></td>
    <td><?= $u['password_hash'] ? '✅ Yes' : '❌ Not set' ?></td>
  </tr>
  <?php endforeach; ?>
</table>

</body>
</html>
