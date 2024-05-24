
create table Contador(
Ejercicio varchar(4)not null,
Nombre varchar (30) not null,
Serie varchar(2) not null ,
numero int,
primary key (Ejercicio, Nombre, Serie)
)

create table Producto(
codigo_producto int identity primary key not null,
descripcion varchar (150),
cantidad float,
iva float,
)

create table Cliente(
numero_cliente int  identity primary key not null,
nombre_cliente varchar (100),
direccion varchar (150),
correo varchar (50),
telefono varchar (50),
n_de_ventas int,
ventas_acumuladas float
)

create table Albaran(
Ejercicio varchar(4),
Nombre varchar (30),
Serie varchar (2),
numero_Al int,
fecha date,
numero_cliente int,
entregado bit ,
Recogido_por varchar (100),
numero_lineas int,
factura varchar(50),
constraint pk2_Albaran Primary key (Ejercicio, Serie, numero_Al),
constraint fk3_Cliente Foreign Key (numero_cliente) references Cliente (numero_cliente),
constraint fk2_Contador Foreign Key (Ejercicio, Nombre, Serie) references Contador(Ejercicio, Nombre,  Serie)
)

create table lineas_albaran(
Ejercicio varchar(4),
Serie varchar (2),
numero_Al int,
numero_linea int ,
codigo_producto int,
descripcion varchar (150),
cantidad float,
constraint pk_lineas_albaran primary key (Ejercicio, Serie, numero_Al, numero_linea),
constraint fk_Albaran Foreign Key (Ejercicio, Serie, numero_Al) references Albaran (Ejercicio, Serie, numero_Al),
constraint fk_Producto Foreign Key (codigo_producto) references Producto (codigo_producto)
)

create table factura(
Ejercicio varchar(4),
Nombre varchar(30),
Serie varchar (2),
numero_factura int,
fecha date,
numero_cliente int,
total_factura float,
modo_de_pago varchar (50),
numero_lineas int,
pagado bit,
numero_Al int,
constraint pk_factura Primary key (Ejercicio, Serie, numero_factura),
constraint fp2_Contador Foreign Key (Ejercicio, Nombre, Serie) references Contador (Ejercicio, Nombre, Serie),
constraint fk2_Cliente Foreign Key (numero_cliente) references Cliente (numero_cliente)
)

CREATE TABLE linea_factura_new (
    Ejercicio VARCHAR(4),
    Serie VARCHAR(2),
    numero_factura INT,
    linea_factura INT IDENTITY(1,1), -- Agregar la columna como IDENTITY
    codigo_producto INT,
    descripcion VARCHAR(150),
    cantidad FLOAT,
    precio_unidad FLOAT,
    descuento FLOAT,
    iva INT,
    precio_total FLOAT,
    CONSTRAINT pk_linea_factura_new PRIMARY KEY (Ejercicio, Serie, numero_factura, linea_factura),
    CONSTRAINT fk2_Producto_new FOREIGN KEY (codigo_producto) REFERENCES Producto (codigo_producto),
    CONSTRAINT fk_Factura_new FOREIGN KEY (Ejercicio, Serie, numero_factura) REFERENCES factura (Ejercicio, Serie, numero_factura)
)
//drop table Albaran_old