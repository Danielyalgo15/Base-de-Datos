USE BD_Abarrotes;
GO

-- SUBCONSULTA 1
-- Mostrar los productos cuyo precio de venta es mayor
-- que el precio promedio de todos los productos.

SELECT
    id_producto,
    nombre,
    precio_venta
FROM ProductoBase
WHERE precio_venta > (
    SELECT AVG(precio_venta)
    FROM ProductoBase
)
ORDER BY precio_venta DESC, id_producto;


-- SUBCONSULTA 2
-- Mostrar los productos que se vendieron
-- en la venta V02.

SELECT
    id_producto,
    nombre,
    unidad_medida
FROM ProductoBase
WHERE id_producto IN (
    SELECT id_producto
    FROM DetalleVenta
    WHERE id_venta = 'V02'
)
ORDER BY nombre, id_producto;


-- SUBCONSULTA 3
-- Mostrar las compras que contienen
-- el producto P01, correspondiente al arroz.

SELECT
    id_compra,
    fecha
FROM Compra
WHERE id_compra IN (
    SELECT id_compra
    FROM DetalleCompra
    WHERE id_producto = 'P01'
)
ORDER BY fecha, id_compra;


-- SUBCONSULTA 4
-- Mostrar las líneas de venta cuya cantidad supera
-- la cantidad promedio de las líneas de DetalleVenta.

SELECT
    id_venta,
    id_producto,
    cantidad,
    precio_unitario
FROM DetalleVenta
WHERE cantidad > (
    SELECT AVG(cantidad)
    FROM DetalleVenta
)
ORDER BY cantidad DESC, id_venta, id_producto;