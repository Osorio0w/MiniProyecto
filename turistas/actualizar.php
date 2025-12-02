<?php
include("../config/seguridad.php");
include("../config/conexion.php");

$id  = $_POST["id"];
$nom = trim($_POST["nombre"]);
$ape = trim($_POST["apellido"]);
$doc = $_POST["documento"];
$num = trim($_POST["numero"]);
$tel = trim($_POST["telefono"]);
$ubi = trim($_POST["ubicacion"]);
$cor = trim($_POST["correo"]);

function mostrarError($mensaje)
{
    echo "
    <section class='section'>
        <div class='container'>
            <div class='box'>
                <div class='notification is-danger'>
                    <strong>Error:</strong><br>$mensaje
                </div>
                <a href='listar.php' class='button is-link'>Volver</a>
            </div>
        </div>
    </section>";
    exit;
}

if (!preg_match("/^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$/", $nom)) mostrarError("El nombre solo debe contener letras.");
if (!preg_match("/^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$/", $ape)) mostrarError("El apellido solo debe contener letras.");
if (!ctype_digit($num)) mostrarError("El número de documento debe ser numérico.");
if ($tel !== "" && !ctype_digit($tel)) mostrarError("El teléfono debe ser numérico.");
if (!filter_var($cor, FILTER_VALIDATE_EMAIL)) mostrarError("Correo inválido.");

$val = $con->prepare("
    SELECT id_turista FROM turistas 
    WHERE id_tipo_documento = ? AND numero_documento = ? AND id_turista != ?
");
$val->bind_param("isi", $doc, $num, $id);
$val->execute();
$dup = $val->get_result();

if ($dup->num_rows > 0) {
    mostrarError("Ya existe un turista con este documento.");
}

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {
    $sql = $con->prepare("
        UPDATE turistas SET 
            nombre=?, apellido=?, telefono=?, ubicacion=?, correo=?, 
            id_tipo_documento=?, numero_documento=?
        WHERE id_turista=?
    ");

    $sql->bind_param("sssssisi", $nom, $ape, $tel, $ubi, $cor, $doc, $num, $id);
    $sql->execute();

    header("Location: listar.php?edit=1");
    exit;
} catch (mysqli_sql_exception $e) {
    mostrarError("Error inesperado: " . $e->getMessage());
}
