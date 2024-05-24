create table Contador(
Ejercicio varchar(4)not null,
Nombre varchar (30) not null,
Serie varchar(2) not null ,
numero int,
primary key (Ejercicio, Nombre, Serie)
)

select * from Albaran

select * from Contador

insert into Producto ( descripcion, cantidad, iva)
values ('Sardina', 1000, 4),
		('Caballa', 1000, 10),
		('Atún rojo', 1000, 21),
		('Rape', 1000, 10)

insert into Cliente ( nombre_cliente, direccion)
values ('Juan Palomo', 'aqui'),
		('Anacleto Rodriguez', 'alli'),
		('Luisa Medina', 'aca'),
		('Manuela Leija', 'alla')


insert into Contador (ejercicio, nombre, serie, numero)
values (2024, 'Albaran', 12, 1)
