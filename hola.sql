-- =====================================================
-- BASE DE DATOS: TiendaAbarrotes (SQL Server)
-- Solo comandos vistos en la sesión: CREATE, INSERT, SELECT
-- =====================================================

-- PASO 1. Crear la base de datos
CREATE DATABASE TiendaAbarrotes;
GO

-- PASO 2. Usar la base de datos
USE TiendaAbarrotes;
GO

-- PASO 3. Crear la tabla Categoria
CREATE TABLE Categoria(
    id_categoria CHAR(5) NOT NULL,
    nombre VARCHAR(30) NOT NULL,
    CONSTRAINT PK_Categoria PRIMARY KEY (id_categoria)
);
GO

-- PASO 4. Crear la tabla Producto (clave foránea hacia Categoria)
CREATE TABLE Producto(
    id_producto CHAR(5) NOT NULL,
    id_categoria CHAR(5) NOT NULL,
    nombre VARCHAR(30) NOT NULL,
    marca VARCHAR(30) NOT NULL,
    tamano VARCHAR(20) NOT NULL,
    unidad_medida VARCHAR(20) NOT NULL,
    precio_venta DECIMAL(6,2) NOT NULL,
    stock_inicial INTEGER NOT NULL,
    CONSTRAINT PK_Producto PRIMARY KEY (id_producto),
    CONSTRAINT FK_Producto_Categoria FOREIGN KEY (id_categoria) REFERENCES Categoria (id_categoria)
);
GO

-- PASO 5. Crear la tabla Entrada
CREATE TABLE Entrada(
    id_entrada CHAR(5) NOT NULL,
    fecha DATE NOT NULL,
    CONSTRAINT PK_Entrada PRIMARY KEY (id_entrada)
);
GO

-- PASO 6. Crear la tabla DetalleEntrada (claves foráneas hacia Entrada y Producto)
CREATE TABLE DetalleEntrada(
    id_detalle_entrada CHAR(5) NOT NULL,
    id_entrada CHAR(5) NOT NULL,
    id_producto CHAR(5) NOT NULL,
    cantidad INTEGER NOT NULL,
    costo_unitario DECIMAL(6,2) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    CONSTRAINT PK_DetalleEntrada PRIMARY KEY (id_detalle_entrada),
    CONSTRAINT FK_DetEnt_Entrada FOREIGN KEY (id_entrada) REFERENCES Entrada (id_entrada),
    CONSTRAINT FK_DetEnt_Producto FOREIGN KEY (id_producto) REFERENCES Producto (id_producto)
);
GO

-- PASO 7. Crear la tabla Venta
CREATE TABLE Venta(
    id_venta CHAR(5) NOT NULL,
    fecha DATE NOT NULL,
    CONSTRAINT PK_Venta PRIMARY KEY (id_venta)
);
GO

-- PASO 8. Crear la tabla DetalleVenta (claves foráneas hacia Venta y Producto)
CREATE TABLE DetalleVenta(
    id_detalle_venta CHAR(5) NOT NULL,
    id_venta CHAR(5) NOT NULL,
    id_producto CHAR(5) NOT NULL,
    cantidad INTEGER NOT NULL,
    precio_unitario DECIMAL(6,2) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    CONSTRAINT PK_DetalleVenta PRIMARY KEY (id_detalle_venta),
    CONSTRAINT FK_DetVen_Venta FOREIGN KEY (id_venta) REFERENCES Venta (id_venta),
    CONSTRAINT FK_DetVen_Producto FOREIGN KEY (id_producto) REFERENCES Producto (id_producto)
);
GO

-- PASO 9. Insertar categorías
INSERT INTO Categoria (id_categoria, nombre) VALUES ('CA01', 'Granos');
INSERT INTO Categoria (id_categoria, nombre) VALUES ('CA02', 'Aceites');
GO

-- PASO 10. Insertar productos
INSERT INTO Producto (id_producto, id_categoria, nombre, marca, tamano, unidad_medida, precio_venta, stock_inicial)
VALUES ('P01', 'CA01', 'Arroz', 'Costeño', '1 kg', 'bolsa', 4.50, 10);
INSERT INTO Producto (id_producto, id_categoria, nombre, marca, tamano, unidad_medida, precio_venta, stock_inicial)
VALUES ('P02', 'CA02', 'Aceite', 'Primor', '1 L', 'botella', 8.00, 5);
GO
<
-- PASO 11. Insertar entradas (compras)
INSERT INTO Entrada (id_entrada, fecha) VALUES ('E01', '2026-11-17');
INSERT INTO Entrada (id_entrada, fecha) VALUES ('E02', '2026-11-18');
GO

-- PASO 12. Insertar detalle de entradas (los costos son valores de ejemplo)
INSERT INTO DetalleEntrada (id_detalle_entrada, id_entrada, id_producto, cantidad, costo_unitario, fecha_vencimiento)
VALUES ('DE01', 'E01', 'P01', 20, 3.80, '2027-11-17');
INSERT INTO DetalleEntrada (id_detalle_entrada, id_entrada, id_producto, cantidad, costo_unitario, fecha_vencimiento)
VALUES ('DE02', 'E01', 'P02', 6, 6.50, '2027-05-17');
INSERT INTO DetalleEntrada (id_detalle_entrada, id_entrada, id_producto, cantidad, costo_unitario, fecha_vencimiento)
VALUES ('DE03', 'E02', 'P01', 15, 3.80, '2027-11-18');
GO

-- PASO 13. Insertar ventas
INSERT INTO Venta (id_venta, fecha) VALUES ('V01', '2026-11-18');
INSERT INTO Venta (id_venta, fecha) VALUES ('V02', '2026-11-19');
GO

-- PASO 14. Insertar detalle de ventas
INSERT INTO DetalleVenta (id_detalle_venta, id_venta, id_producto, cantidad, precio_unitario, fecha_vencimiento)
VALUES ('DV01', 'V01', 'P01', 2, 4.50, '2027-11-17');
INSERT INTO DetalleVenta (id_detalle_venta, id_venta, id_producto, cantidad, precio_unitario, fecha_vencimiento)
VALUES ('DV02', 'V01', 'P02', 1, 8.00, '2027-05-17');
INSERT INTO DetalleVenta (id_detalle_venta, id_venta, id_producto, cantidad, precio_unitario, fecha_vencimiento)
VALUES ('DV03', 'V02', 'P01', 3, 4.50, '2027-11-17');
GO

-- PASO 15. Verificar los datos
SELECT * FROM Categoria;
SELECT * FROM Producto;
SELECT * FROM Entrada;
SELECT * FROM DetalleEntrada;
SELECT * FROM Venta;
SELECT * FROM DetalleVenta;
GO