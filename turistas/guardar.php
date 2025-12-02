<?php
include("../config/seguridad.php");
include("../config/conexion.php");

function mostrarError($mensaje)
{
    echo "
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset='UTF-8'>
        <link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bulma@1.0.4/css/bulma.min.css'>
        <title>Error</title>
    </head>
    <body>
        <section class='section'>
            <div class='container'>
                <div class='box'>
                    <div class='notification is-danger'>
                        <strong>Error:</strong><br>
                        $mensaje
                    </div>
                    <a href='registrar.php' class='button is-link'>Volver</a>
                </div>
            </div>
        </section>
    </body>
    </html>";
    exit;
}

$nom = trim($_POST["nombre"]);
$ape = trim($_POST["apellido"]);
$doc = $_POST["documento"];
$num = trim($_POST["numero"]);
$tel = trim($_POST["telefono"]);
$ubi = trim($_POST["ubicacion"]);
$cor = trim($_POST["correo"]);

if (!preg_match("/^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$/", $nom)) {
    mostrarError("El nombre solo debe contener letras.");
}

if (!preg_match("/^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]+$/", $ape)) {
    mostrarError("El apellido solo debe contener letras.");
}

if (!ctype_digit($num)) {
    mostrarError("El número de documento debe ser numérico.");
}

if ($tel !== "" && !ctype_digit($tel)) {
    mostrarError("El teléfono debe contener solo números.");
}

if (!filter_var($cor, FILTER_VALIDATE_EMAIL)) {
    mostrarError("El correo ingresado no es válido. Formato esperado: nombre@dominio.com");
}

$validar = $con->prepare("SELECT * FROM turistas WHERE id_tipo_documento = ? AND numero_documento = ?");
$validar->bind_param("is", $doc, $num);
$validar->execute();
$res = $validar->get_result();

if ($res->num_rows > 0) {
    mostrarError("Ya existe un turista con este tipo y número de documento.");
}

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {

    $sql = $con->prepare("INSERT INTO turistas(nombre, apellido, telefono, ubicacion, correo, id_tipo_documento, numero_documento)
                          VALUES (?,?,?,?,?,?,?)");

    $sql->bind_param("sssssis", $nom, $ape, $tel, $ubi, $cor, $doc, $num);

    $sql->execute();

    header("Location: listar.php?ok=1");
    exit;
} catch (mysqli_sql_exception $e) {

    if (str_contains($e->getMessage(), 'chk_email_valido')) {
        mostrarError("El correo no cumple las reglas del sistema. Intente con un email válido.");
    } else {
        mostrarError("Ocurrió un error inesperado: " . $e->getMessage());
    }
}
