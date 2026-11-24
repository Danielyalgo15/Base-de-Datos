-- PARTE 1. CREAR LA BASE DE DATOS Y LAS TABLAS

CREATE DATABASE BD_Abarrotes;
GO

USE BD_Abarrotes;
GO

CREATE TABLE ProductoBase (
    id_producto VARCHAR(10) NOT NULL PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    id_categoria VARCHAR(10) NOT NULL,
    nombre_categoria NVARCHAR(60) NOT NULL,
    unidad_medida NVARCHAR(20) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL CHECK (precio_venta > 0),
    stock_inicial DECIMAL(10,3) NOT NULL CHECK (stock_inicial >= 0)
);

CREATE TABLE Compra (
    id_compra VARCHAR(10) NOT NULL PRIMARY KEY,
    fecha DATE NOT NULL
);

CREATE TABLE DetalleCompra (
    id_compra VARCHAR(10) NOT NULL,
    id_producto VARCHAR(10) NOT NULL,
    cantidad DECIMAL(10,3) NOT NULL CHECK (cantidad > 0),
    costo_unitario DECIMAL(10,2) NOT NULL CHECK (costo_unitario > 0),

    PRIMARY KEY (id_compra, id_producto),

    FOREIGN KEY (id_compra)
        REFERENCES Compra (id_compra),

    FOREIGN KEY (id_producto)
        REFERENCES ProductoBase (id_producto)
);

CREATE TABLE Venta (
    id_venta VARCHAR(10) NOT NULL PRIMARY KEY,
    fecha DATE NOT NULL
);

CREATE TABLE DetalleVenta (
    id_venta VARCHAR(10) NOT NULL,
    id_producto VARCHAR(10) NOT NULL,
    cantidad DECIMAL(10,3) NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario > 0),

    PRIMARY KEY (id_venta, id_producto),

    FOREIGN KEY (id_venta)
        REFERENCES Venta (id_venta),

    FOREIGN KEY (id_producto)
        REFERENCES ProductoBase (id_producto)
);
GO


-- PARTE 2. INSERTAR LOS DATOS DEL WORD

INSERT INTO ProductoBase (
    id_producto, nombre, id_categoria, nombre_categoria,
    unidad_medida, precio_venta, stock_inicial
)
VALUES
    ('P01', N'Arroz', 'CA01', N'Granos', N'kg', 4.50, 10),
    ('P02', N'Aceite', 'CA02', N'Aceites', N'botella', 8.00, 5);

INSERT INTO Compra (id_compra, fecha)
VALUES
    ('C01', '20261117'),
    ('C02', '20261118');

INSERT INTO DetalleCompra (
    id_compra, id_producto, cantidad, costo_unitario
)
VALUES
    ('C01', 'P01', 20, 3.00),
    ('C01', 'P02', 6, 6.00),
    ('C02', 'P01', 15, 3.20);

INSERT INTO Venta (id_venta, fecha)
VALUES
    ('V01', '20261118'),
    ('V02', '20261119');

INSERT INTO DetalleVenta (
    id_venta, id_producto, cantidad, precio_unitario
)
VALUES
    ('V01', 'P01', 2, 4.50),
    ('V01', 'P02', 1, 8.00),
    ('V02', 'P01', 3, 4.50);
GO


-- PARTE 3. LAS OCHO CONSULTAS

USE BD_Abarrotes;
GO

-- 1. Mostrar las ventas entre dos fechas de productos
-- que tienen compras registradas.

SELECT DISTINCT
    v.id_venta, v.fecha, p.id_producto,
    p.nombre, dv.cantidad, dv.precio_unitario
FROM Venta AS v
JOIN DetalleVenta AS dv ON v.id_venta = dv.id_venta
JOIN ProductoBase AS p ON dv.id_producto = p.id_producto
JOIN DetalleCompra AS dc ON p.id_producto = dc.id_producto
WHERE v.fecha BETWEEN '20261118' AND '20261119'
ORDER BY v.fecha, v.id_venta, p.nombre, p.id_producto;


-- 2. Mostrar las ventas de P01 y P02 que tienen
-- compras registradas, indicando su unidad de medida.

SELECT DISTINCT
    v.id_venta, p.id_producto, p.nombre,
    p.unidad_medida, dv.cantidad
FROM Venta AS v
JOIN DetalleVenta AS dv ON v.id_venta = dv.id_venta
JOIN ProductoBase AS p ON dv.id_producto = p.id_producto
JOIN DetalleCompra AS dc ON p.id_producto = dc.id_producto
WHERE p.id_producto IN ('P01', 'P02')
ORDER BY p.nombre, v.id_venta, p.id_producto;


-- 3. Mostrar las ventas de productos cuyo nombre empieza
-- con Ar y que tienen compras registradas.

SELECT DISTINCT
    v.id_venta, v.fecha, p.id_producto,
    p.nombre, dv.cantidad
FROM Venta AS v
JOIN DetalleVenta AS dv ON v.id_venta = dv.id_venta
JOIN ProductoBase AS p ON dv.id_producto = p.id_producto
JOIN DetalleCompra AS dc ON p.id_producto = dc.id_producto
WHERE p.nombre LIKE N'Ar%'
ORDER BY v.fecha, v.id_venta, p.nombre, p.id_producto;


-- 4. Mostrar las ventas de productos con alguna compra
-- cuyo costo unitario está entre 3.00 y 3.20.

SELECT DISTINCT
    v.id_venta, p.id_producto, p.nombre,
    dv.cantidad, dv.precio_unitario
FROM Venta AS v
JOIN DetalleVenta AS dv ON v.id_venta = dv.id_venta
JOIN ProductoBase AS p ON dv.id_producto = p.id_producto
JOIN DetalleCompra AS dc ON p.id_producto = dc.id_producto
WHERE dc.costo_unitario BETWEEN 3.00 AND 3.20
ORDER BY v.id_venta, p.nombre, p.id_producto;


-- 5. Mostrar las compras entre dos fechas de productos
-- que tienen ventas registradas.

SELECT DISTINCT
    c.id_compra, c.fecha, p.id_producto,
    p.nombre, dc.cantidad, dc.costo_unitario
FROM Compra AS c
JOIN DetalleCompra AS dc ON c.id_compra = dc.id_compra
JOIN ProductoBase AS p ON dc.id_producto = p.id_producto
JOIN DetalleVenta AS dv ON p.id_producto = dv.id_producto
WHERE c.fecha BETWEEN '20261117' AND '20261118'
ORDER BY c.fecha, c.id_compra, p.nombre, p.id_producto;


-- 6. Mostrar las compras de P01 que tiene ventas
-- registradas y calcular el importe de cada línea.

SELECT DISTINCT
    c.id_compra, p.id_producto, p.nombre,
    dc.cantidad, dc.costo_unitario,
    dc.cantidad * dc.costo_unitario AS importe
FROM Compra AS c
JOIN DetalleCompra AS dc ON c.id_compra = dc.id_compra
JOIN ProductoBase AS p ON dc.id_producto = p.id_producto
JOIN DetalleVenta AS dv ON p.id_producto = dv.id_producto
WHERE p.id_producto IN ('P01')
ORDER BY c.id_compra, p.nombre, p.id_producto;


-- 7. Mostrar las compras de productos cuyo nombre contiene
-- ceite y que tienen ventas registradas.

SELECT DISTINCT
    c.id_compra, c.fecha, p.id_producto,
    p.nombre, dc.cantidad, dc.costo_unitario
FROM Compra AS c
JOIN DetalleCompra AS dc ON c.id_compra = dc.id_compra
JOIN ProductoBase AS p ON dc.id_producto = p.id_producto
JOIN DetalleVenta AS dv ON p.id_producto = dv.id_producto
WHERE p.nombre LIKE N'%ceite%'
ORDER BY c.fecha, c.id_compra, p.nombre, p.id_producto;


-- 8. Mostrar las compras de la categoría Granos de productos
-- con ventas registradas, desde el mayor costo al menor.

SELECT DISTINCT
    c.id_compra, p.id_producto, p.nombre_categoria,
    p.nombre, dc.cantidad, dc.costo_unitario
FROM Compra AS c
JOIN DetalleCompra AS dc ON c.id_compra = dc.id_compra
JOIN ProductoBase AS p ON dc.id_producto = p.id_producto
JOIN DetalleVenta AS dv ON p.id_producto = dv.id_producto
WHERE p.nombre_categoria IN (N'Granos')
ORDER BY dc.costo_unitario DESC,
         c.id_compra, p.nombre, p.id_producto;