<?php
include("../config/seguridad.php");
include("../config/conexion.php");

$mensaje = "";
$tipo_mensaje = "";

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $nombre    = trim($_POST['nombre']);
    $apellido  = trim($_POST['apellido']);
    $correo    = trim($_POST['correo']);
    $ubicacion = trim($_POST['ubicacion']);

    $prefijo    = $_POST['prefijo'];
    $tlf_cuerpo = trim($_POST['telefono']);

    if (!preg_match("/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/", $nombre)) {
        $mensaje = "El nombre solo puede contener letras.";
        $tipo_mensaje = "is-danger";
    } elseif (!preg_match("/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/", $apellido)) {
        $mensaje = "El apellido solo puede contener letras.";
        $tipo_mensaje = "is-danger";
    } elseif (!ctype_digit($tlf_cuerpo)) {
        $mensaje = "El teléfono solo debe contener números.";
        $tipo_mensaje = "is-danger";
    } elseif (!filter_var($correo, FILTER_VALIDATE_EMAIL)) {
        $mensaje = "El formato del correo no es válido.";
        $tipo_mensaje = "is-danger";
    } else {

        $telefono_final = $prefijo . $tlf_cuerpo;

        try {
            $sql = "UPDATE turistas SET nombre=?, apellido=?, telefono=?, correo=?, ubicacion=? WHERE id_turista=?";
            $stmt = $con->prepare($sql);
            $stmt->bind_param("sssssi", $nombre, $apellido, $telefono_final, $correo, $ubicacion, $id);

            if ($stmt->execute()) {
                header("Location: listar.php?msg=actualizado");
                exit;
            }
        } catch (Exception $e) {
            $mensaje = "Error al actualizar: " . $e->getMessage();
            $tipo_mensaje = "is-danger";
        }
    }
}

$stmt = $con->prepare("SELECT * FROM turistas WHERE id_turista = ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$turista = $stmt->get_result()->fetch_assoc();

if (!$turista) {
    header("Location: listar.php");
    exit;
}

$tlf_db = $turista['telefono'];
$pref_mostrar  = "+58"; 
$cuerpo_mostrar = $tlf_db;

$prefijos = ['+58', '+1', '+34', '+57', '+55', '+54'];

foreach ($prefijos as $p) {
    if (strpos($tlf_db, $p) === 0) {
        $pref_mostrar = $p;
        $cuerpo_mostrar = substr($tlf_db, strlen($p));
        break; 
    }
}

if ($mensaje) {
    $pref_mostrar = $_POST['prefijo'];
    $cuerpo_mostrar = $_POST['telefono'];
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Editar Turista</title>
    <link rel="icon" href="../assets/img/Icono.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="../css/estilos.css">
</head>

<body>

    <?php include("../config/navbar.php"); ?>

    <section class="section">
        <div class="container">

            <nav class="breadcrumb" aria-label="breadcrumbs">
                <ul>
                    <li><a href="../index.php">Inicio</a></li>
                    <li><a href="listar.php">Turistas</a></li>
                    <li class="is-active"><a href="#" aria-current="page">Editar</a></li>
                </ul>
            </nav>

            <h1 class="title">Editar Turista</h1>
            <h2 class="subtitle is-6">Modificando a: <strong><?= $turista['nombre'] . ' ' . $turista['apellido'] ?></strong></h2>

            <?php if ($mensaje): ?>
                <div class="notification <?= $tipo_mensaje ?>">
                    <button class="delete" onclick="this.parentElement.style.display='none'"></button>
                    <?= $mensaje ?>
                </div>
            <?php endif; ?>

            <form method="POST" class="box">

                <div class="notification is-info is-light mb-4">
                    <p class="has-text-weight-bold">
                        <i class="fas fa-id-card mr-2"></i>
                        Documento: <?= $turista['numero_documento'] ?> (No editable)
                    </p>
                </div>

                <div class="columns">
                    <div class="column">
                        <label class="label">Nombre</label>
                        <div class="control has-icons-left">
                            <input class="input" type="text" name="nombre" required
                                value="<?= $mensaje ? $_POST['nombre'] : $turista['nombre'] ?>">
                            <span class="icon is-small is-left"><i class="fas fa-user"></i></span>
                        </div>
                    </div>
                    <div class="column">
                        <label class="label">Apellido</label>
                        <div class="control has-icons-left">
                            <input class="input" type="text" name="apellido" required
                                value="<?= $mensaje ? $_POST['apellido'] : $turista['apellido'] ?>">
                            <span class="icon is-small is-left"><i class="fas fa-user"></i></span>
                        </div>
                    </div>
                </div>

                <div class="columns">
                    <div class="column">
                        <label class="label">Correo Electrónico</label>
                        <div class="control has-icons-left">
                            <input class="input" type="email" name="correo" required
                                value="<?= $mensaje ? $_POST['correo'] : $turista['correo'] ?>">
                            <span class="icon is-small is-left"><i class="fas fa-envelope"></i></span>
                        </div>
                    </div>

                    <div class="column">
                        <label class="label">Teléfono Móvil</label>
                        <div class="field has-addons">
                            <p class="control">
                                <span class="select">
                                    <select name="prefijo">
                                        <option value="+58" <?= ($pref_mostrar == '+58') ? 'selected' : '' ?>>🇻🇪 +58</option>
                                        <option value="+1" <?= ($pref_mostrar == '+1') ? 'selected' : '' ?>>🇺🇸 +1</option>
                                        <option value="+34" <?= ($pref_mostrar == '+34') ? 'selected' : '' ?>>🇪🇸 +34</option>
                                        <option value="+57" <?= ($pref_mostrar == '+57') ? 'selected' : '' ?>>🇨🇴 +57</option>
                                        <option value="+55" <?= ($pref_mostrar == '+55') ? 'selected' : '' ?>>🇧🇷 +55</option>
                                        <option value="+54" <?= ($pref_mostrar == '+54') ? 'selected' : '' ?>>🇦🇷 +54</option>
                                    </select>
                                </span>
                            </p>
                            <p class="control is-expanded has-icons-left">
                                <input class="input" type="text" name="telefono"
                                    placeholder="Ej: 4141234567"
                                    pattern="[0-9]+"
                                    maxlength="15"
                                    title="Solo números"
                                    required
                                    value="<?= $cuerpo_mostrar ?>">
                                <span class="icon is-small is-left">
                                    <i class="fas fa-mobile-alt"></i>
                                </span>
                            </p>
                        </div>
                        <p class="help">Use solo números sin el cero inicial.</p>
                    </div>
                </div>

                <div class="field">
                    <label class="label">Ubicación</label>
                    <div class="control has-icons-left">
                        <input class="input" type="text" name="ubicacion" required
                            value="<?= $mensaje ? $_POST['ubicacion'] : $turista['ubicacion'] ?>">
                        <span class="icon is-small is-left"><i class="fas fa-map-marker-alt"></i></span>
                    </div>
                </div>

                <div class="buttons is-right">
                    <a href="listar.php" class="button is-text">Cancelar</a>
                    <button type="submit" class="button is-warning has-text-weight-bold">
                        <span class="icon"><i class="fas fa-save"></i></span>
                        <span>Actualizar Datos</span>
                    </button>
                </div>
            </form>

        </div>
    </section>
</body>

</html>