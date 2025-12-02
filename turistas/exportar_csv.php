<?php
include("../config/seguridad.php");
include("../config/conexion.php");

header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename=turistas_caribe_azul.csv');

$output = fopen('php://output', 'w');

fputs($output, "\xEF\xBB\xBF");

fputcsv($output, array('ID', 'Nombre', 'Apellido', 'Documento', 'Teléfono', 'Correo', 'Ubicación'));

$sql = "SELECT 
            t.id_turista, 
            t.nombre, 
            t.apellido, 
            CONCAT(td.codigo, '-', t.numero_documento) as documento,
            t.telefono, 
            t.correo, 
            t.ubicacion
        FROM turistas t
        INNER JOIN tipo_documentos td ON t.id_tipo_documento = td.id_tipo_documento
        WHERE t.activo = 1
        ORDER BY t.apellido ASC";

$resultado = $con->query($sql);

while ($fila = $resultado->fetch_assoc()) {
    fputcsv($output, $fila);
}

fclose($output);
exit;
