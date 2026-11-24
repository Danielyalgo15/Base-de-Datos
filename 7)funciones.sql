USE BD_Abarrotes;
GO


-- FUNCIÓN 1
-- Calcular el importe total de una venta
-- a partir de su código.

CREATE OR ALTER FUNCTION dbo.fn_TotalVenta (
    @id_venta VARCHAR(10)
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @total DECIMAL(18,2);

    SELECT @total = SUM(cantidad * precio_unitario)
    FROM dbo.DetalleVenta
    WHERE id_venta = @id_venta;

    RETURN ISNULL(@total, 0);
END;
GO


-- FUNCIÓN 2
-- Calcular las existencias de un producto:
-- stock inicial + compras - ventas.

CREATE OR ALTER FUNCTION dbo.fn_StockProducto (
    @id_producto VARCHAR(10)
)
RETURNS DECIMAL(18,3)
AS
BEGIN
    DECLARE @stock_inicial DECIMAL(18,3);
    DECLARE @comprado DECIMAL(18,3);
    DECLARE @vendido DECIMAL(18,3);

    SELECT @stock_inicial = stock_inicial
    FROM dbo.ProductoBase
    WHERE id_producto = @id_producto;

    SELECT @comprado = SUM(cantidad)
    FROM dbo.DetalleCompra
    WHERE id_producto = @id_producto;

    SELECT @vendido = SUM(cantidad)
    FROM dbo.DetalleVenta
    WHERE id_producto = @id_producto;

    RETURN @stock_inicial
           + ISNULL(@comprado, 0)
           - ISNULL(@vendido, 0);
END;
GO


-- PROBAR LA FUNCIÓN 1
-- Mostrar el total de cada venta.

SELECT
    id_venta,
    dbo.fn_TotalVenta(id_venta) AS total_venta
FROM dbo.Venta
ORDER BY id_venta;


-- PROBAR LA FUNCIÓN 2
-- Mostrar las existencias de cada producto.

SELECT
    id_producto,
    nombre,
    unidad_medida,
    dbo.fn_StockProducto(id_producto) AS stock_disponible
FROM dbo.ProductoBase
ORDER BY id_producto;
