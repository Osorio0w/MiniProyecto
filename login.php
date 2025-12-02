<?php
session_start();
include("config/conexion.php");

if (isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit;
}

$error = "";

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user = trim($_POST['usuario']);
    $pass = $_POST['password'];

    $stmt = $con->prepare("SELECT id_usuario, password, nombre_completo FROM usuarios WHERE usuario = ?");
    $stmt->bind_param("s", $user);
    $stmt->execute();
    $resultado = $stmt->get_result();

    if ($fila = $resultado->fetch_assoc()) {
        if (password_verify($pass, $fila['password'])) {
            $_SESSION['id_usuario'] = $fila['id_usuario'];
            $_SESSION['nombre'] = $fila['nombre_completo'];

            header("Location: index.php");
            exit;
        } else {
            $error = "Contraseña incorrecta.";
        }
    } else {
        $error = "El usuario no existe.";
    }
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Login - Caribe Azul</title>
    <link rel="icon" href="assets/img/Icono.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/estilos.css">
    <style>
        body {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #00d2ff 0%, #3a7bd5 100%);
        }

        .login-card {
            width: 400px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>

<body>

    <div class="box login-card p-5">
        <div class="has-text-centered mb-5">
            <span class="icon is-large has-text-info">
                <i class="fas fa-umbrella-beach fa-3x"></i>
            </span>
            <h1 class="title is-4 mt-3">Caribe Azul Travel</h1>
            <p class="subtitle is-6">Acceso al Sistema</p>
        </div>

        <?php if ($error): ?>
            <div class="notification is-danger is-light p-3 mb-4">
                <small><i class="fas fa-exclamation-circle"></i> <?= $error ?></small>
            </div>
        <?php endif; ?>

        <form method="POST">
            <div class="field">
                <label class="label">Usuario</label>
                <div class="control has-icons-left">
                    <input class="input" type="text" name="usuario" required autofocus>
                    <span class="icon is-small is-left"><i class="fas fa-user"></i></span>
                </div>
            </div>

            <div class="field">
                <label class="label">Contraseña</label>
                <div class="control has-icons-left">
                    <input class="input" type="password" name="password" required>
                    <span class="icon is-small is-left"><i class="fas fa-lock"></i></span>
                </div>
            </div>

            <button type="submit" class="button is-info is-fullwidth mt-5 has-text-weight-bold">
                INGRESAR
            </button>
        </form>

        <p class="has-text-centered is-size-7 mt-4 has-text-grey">
            &copy; 2025 Sistema de Gestión Turística
        </p>
    </div>

</body>

</html>