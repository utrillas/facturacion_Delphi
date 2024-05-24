select * from Contador

delete from Contador where Serie = 12

select * from Albaran

select * from lineas_albaran

select * from Factura

select * from linea_factura

delete from factura

delete from Albaran

delete from lineas_albaran where serie = 12

drop Albaran_old

delete from factura where serie = 12


insert into Albaran(Ejercicio, Nombre, Serie, numero_Al, fecha, numero_cliente) values ('2024', 'Albaran', 12, 1, '2024-05-20', '3')

insert into linea_factura (Ejercicio, Serie, codigo_producto, descripcion, cantidad)  SELECT Ejercicio, Serie, numero_Al, codigo_producto, descripcion, cantidad, '
       'FROM lineas_albaran  WHERE Ejercicio = ' 2024'
        AND Serie= '12' 
      AND numero_Al= 3;

EXEC sp_rename 'Albaran' , 'Albaran_old';
create table Albaran(
Ejercicio varchar(4),
Nombre varchar (30),
Serie varchar (2),
numero_Al int IDENTITY (1,1),
fecha date,
numero_cliente int,
entregado bit ,
Recogido_por varchar (100),
numero_lineas int,
factura varchar(50),
constraint pk_Albaran Primary key (Ejercicio, Serie, numero_Al),
constraint fk_Cliente Foreign Key (numero_cliente) references Cliente (numero_cliente),
constraint fk_Contador Foreign Key (Ejercicio, Nombre, Serie) references Contador(Ejercicio, Nombre,  Serie)
)
SET IDENTITY_INSERT Albaran ON;

INSERT INTO Albaran (Ejercicio, Nombre, Serie, numero_Al, fecha, numero_cliente, entregado, Recogido_por, numero_lineas, factura)
SELECT Ejercicio, Nombre, Serie, numero_Al, fecha, numero_cliente, entregado, Recogido_por, numero_lineas, factura
FROM Albaran_old;

SET IDENTITY_INSERT Albaran OFF;

-- Eliminar la tabla antigua
DROP TABLE Albaran_old;


INSERT INTO linea_factura (Ejercicio, Serie, numero_factura) 
                      SELECT Ejercicio, Serie, numero_factura 
                      FROM factura
                      WHERE Ejercicio = '2024' 
                      AND Serie = '12' 
                      AND numero_Al = 1 