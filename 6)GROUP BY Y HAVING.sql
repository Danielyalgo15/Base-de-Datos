USE BD_Abarrotes;
GO


-- CONSULTA GROUP BY Y HAVING 1
-- Mostrar los productos cuya cantidad total vendida
-- sea mayor que 2.

SELECT
    p.id_producto,
    p.nombre,
    SUM(dv.cantidad) AS total_vendido
FROM DetalleVenta AS dv
JOIN ProductoBase AS p
    ON dv.id_producto = p.id_producto
GROUP BY p.id_producto, p.nombre
HAVING SUM(dv.cantidad) > 2
ORDER BY total_vendido DESC, p.id_producto;


-- CONSULTA GROUP BY Y HAVING 2
-- Mostrar los productos cuya cantidad total comprada
-- sea mayor que 10.

SELECT
    p.id_producto,
    p.nombre,
    SUM(dc.cantidad) AS total_comprado
FROM DetalleCompra AS dc
JOIN ProductoBase AS p
    ON dc.id_producto = p.id_producto
GROUP BY p.id_producto, p.nombre
HAVING SUM(dc.cantidad) > 10
ORDER BY total_comprado DESC, p.id_producto;


-- CONSULTA GROUP BY Y HAVING 3
-- Mostrar las ventas cuyo importe total
-- sea mayor que 15.00.

SELECT
    id_venta,
    SUM(cantidad * precio_unitario) AS total_venta
FROM DetalleVenta
GROUP BY id_venta
HAVING SUM(cantidad * precio_unitario) > 15.00
ORDER BY total_venta DESC, id_venta;


-- CONSULTA GROUP BY Y HAVING 4
-- Mostrar las compras que incluyen
-- al menos dos productos diferentes.

SELECT
    id_compra,
    COUNT(*) AS cantidad_productos
FROM DetalleCompra
GROUP BY id_compra
HAVING COUNT(*) >= 2
ORDER BY cantidad_productos DESC, id_compra;

