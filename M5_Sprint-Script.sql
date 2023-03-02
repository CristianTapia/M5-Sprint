/****************************
*    CREACIÓN DE TABLAS     *
****************************/

CREATE TABLE
    cliente (
        rutcliente NUMERIC(10) PRIMARY KEY,
        clinombres VARCHAR(30) NOT NULL,
        cliapellidos VARCHAR(50) NOT NULL,
        clitelefono VARCHAR (20) NOT NULL,
        cliafp VARCHAR (30),
        clisistemasalud NUMERIC (2),
        clidireccion VARCHAR(100) NOT NULL,
        clicomuna VARCHAR (50) NOT NULL,
        cliedad NUMERIC (3) NOT NULL
	);

CREATE TABLE
	capacitacion (
        idcapacitacion INT AUTO_INCREMENT PRIMARY KEY,
        capfecha DATE NOT NULL,
        caphora TIME,
        caplugar VARCHAR(100) NOT NULL,
        capduracion NUMERIC (4),
        rutcliente NUMERIC  (10) NOT NULL,
        CONSTRAINT Capacitacion_Cliente_FK FOREIGN KEY (rutcliente) REFERENCES cliente(rutcliente)
    );

CREATE TABLE
    Asistentes (
        idasistente INT PRIMARY KEY AUTO_INCREMENT,
        asistnombrecompleto VARCHAR (100) NOT NULL,
        asistedad NUMERIC (3) NOT NULL,
        asistecorreo VARCHAR (70),
        asisttelefono VARCHAR (20),
        idcapacitacion int NOT NULL,
		CONSTRAINT Asistentes_capacitacion_FK FOREIGN KEY (idcapacitacion) REFERENCES capacitacion(idcapacitacion)
    );

CREATE TABLE
    Accidente (
        idaccidente INT AUTO_INCREMENT PRIMARY KEY,
        accifecha DATE NOT NULL,
        accihora TIME NOT NULL,
        accilugar VARCHAR (150) NOT NULL,
        acciorigen VARCHAR (100) NOT NULL,
        acciconsecuencias VARCHAR (100),
        rutcliente NUMERIC (10) NOT NULL,
        CONSTRAINT Accidente_cliente_FK FOREIGN KEY (rutcliente) REFERENCES cliente (rutcliente)
    );

CREATE TABLE
    Visita (
        idvisita INT PRIMARY KEY AUTO_INCREMENT,
        visfecha DATE NOT NULL,
        vishora TIME,
        vislugar VARCHAR(50) NOT NULL,
        viscomentarios VARCHAR (250) NOT NULL,
        rutcliente NUMERIC (10) NOT NULL,
        CONSTRAINT Visita_cliente_FK FOREIGN KEY (rutcliente) REFERENCES cliente(rutcliente)
	);
    
/* • Una tabla de chequeos, que permita registrar todas las diferentes revisiones que se
 pueden hacer sobre una empresa. Se debe incluir un campo identificador y un nombre
 del chequeo.*/

CREATE TABLE
    chequeo (
        idchequeo INT PRIMARY KEY AUTO_INCREMENT,
        nombre VARCHAR (50) NOT NULL
    );
    
/* • Una tabla que permita registrar qué chequeo se realiza a un cliente en una visita. Por
cada registro de esta tabla se debe considerar el estado de cumplimiento (si ese chequeo
se cumple, si se cumple con observaciones, o bien si no se cumple).*/

CREATE TABLE
    registros (
        idregistro int PRIMARY KEY AUTO_INCREMENT,
        cumplimiento varchar(2) NOT NULL,
        observaciones varchar(250),
        idchequeo int NOT NULL,
        rutcliente NUMERIC NOT NULL,
        CONSTRAINT Registros_chequeo_FK FOREIGN KEY (idchequeo) REFERENCES chequeo(idchequeo),
        CONSTRAINT Registros_Cliente_FK FOREIGN KEY (rutcliente) REFERENCES cliente(rutcliente)
    );

/* • Una tabla de usuarios, la que debe contener el nombre, apellido, la fecha de nacimiento
 y el RUN. Esta tabla almacenará los usuarios registrados en la plataforma.*/

CREATE TABLE
    usuarios (
        rutusuario NUMERIC (10) PRIMARY KEY,
        nombre VARCHAR(30) NOT NULL,
        apellido VARCHAR(30) NOT NULL,
        fnacimiento DATE NOT NULL
	);

/* • Cada cliente debe asociarse a un usuario de sistema. Por tanto, debe agregar un campo
 que permita asociar un cliente con un usuario de sistema.*/
 
ALTER TABLE usuarios ADD COLUMN idcliente NUMERIC(10);
ALTER TABLE usuarios ADD CONSTRAINT Usuario_cliente_FK 
FOREIGN KEY (idcliente) REFERENCES cliente (rutcliente);

/* • Una tabla que permita registrar administrativos, de quienes se interesa saber su RUN, sus
 nombres, sus apellidos, su correo electrónico y el nombre del área a la que pertenece. Al
 igual que la tabla que almacena clientes, esta tabla de administrativos debe estar
 asociada a la tabla de usuarios a través de una llave foránea.*/
 
 CREATE TABLE 
	administrativos (
		 rutadmin NUMERIC(10) PRIMARY KEY, 
		 nombreadmin VARCHAR (30), 
		 apellidosadmin VARCHAR (30), 
		 correoadmin VARCHAR (30), 
		 areaadmin VARCHAR (15),
		 rutusuario NUMERIC (10)
	 );
 
ALTER TABLE administrativos ADD CONSTRAINT Usuario_admin_FK
FOREIGN KEY (rutusuario) REFERENCES usuarios (rutusuario);

/* • Se debe agregar una tabla que permita registrar profesionales, de quienes se requiere
 conocer su RUN, sus nombres, sus apellidos, su teléfono, su título profesional y el
 proyecto en el que se desempeña. Bajo la misma idea de las tablas que registran clientes
 y administrativos, debe asociar un profesional a un usuario de sistema, por medio de una
 llave ajena. */
 
CREATE TABLE 
	profesionales (
		rut numeric(10) PRIMARY KEY,
		nombres varchar(50) NOT NULL,
		apellidos varchar(50) NOT NULL,
		telefono int,
		tituloProfesional varchar(70) NOT NULL,
		proyecto varchar(100) NOT NULL
	);

-- Agregar columna a tabla usuarios
ALTER TABLE usuarios ADD COLUMN rutprofesional NUMERIC(10);

-- Definir PK en tabla profesionales como FK en tabla usuarios 
ALTER TABLE usuarios ADD CONSTRAINT Usuario_profesional_FK 
FOREIGN KEY (rutprofesional) REFERENCES profesionales(rut);

/* - Una tabla que registre los pagos de cada cliente. Esta tabla debe contener un campo
identificador correlativo autoincremental, la fecha del pago, el monto del pago, el mes y
año que se está pagando (en campos distintos). Es necesario recordar que un cliente tiene
muchos pagos, pero un registro de pago se asociará solo a un cliente */

CREATE TABLE 
	pagos (
		idpago int AUTO_INCREMENT,
		fecha date NOT NULL,
		monto int NOT NULL,
		mes varchar(9) NOT NULL,
		año int NOT NULL,
		rutcliente NUMERIC (10),
		PRIMARY KEY (idpago),
		CONSTRAINT Pagos_cliente_FK FOREIGN KEY (rutcliente) REFERENCES cliente(rutcliente)
	);

/*- Una tabla que registre asesorías realizadas a los clientes. Una asesoría es una actividad
de verificación de situaciones que pueden generar problemas en el mediano plazo. Por
cada una de estas instancias se desea conocer un código único, la fecha de realización, el
motivo por el cual se solicita y el profesional al que se asignará dicha asesoría (debe existir
una llave foránea a la tabla profesional).*/

CREATE TABLE 
	asesorias (
		idasesoria int AUTO_INCREMENT PRIMARY KEY,
		fecha date NOT NULL,
		motivo varchar(250) NOT NULL,
		asignado NUMERIC(10) NOT NULL,
		CONSTRAINT Asesorias_profesionales_FK FOREIGN KEY (asignado) REFERENCES profesionales (rut)
	);

/*- Por cada asesoría, se generan una o más actividades de mejora, que son
recomendaciones que el profesional hace al cliente. En cada una de estas instancias se
registra un campo único autoincremental, el título de la actividad de mejora, la
descripción de esta y el plazo en días de resolución.*/

CREATE TABLE 
	mejoras (
		idmejora int PRIMARY KEY AUTO_INCREMENT,
		titulo varchar(70) NOT NULL,
		descripcion varchar(250),
		plazoResolucion date NOT NULL,
		idasesoria int NOT NULL,
		CONSTRAINT Mejoras_aseorias_FK FOREIGN KEY (idasesoria) REFERENCES asesorias (idasesoria)
	);
    
/****************************
*   AGREGAR DATOS A TABLAS  *
****************************/

/*- Al script anterior debe agregar consultas de inserción de registros en cada tabla. Se
pide como mínimo tres registros en cada tabla insertados. Debe cuidar el orden lógico
de inserción de datos, a fin de no generar conflictos con las restricciones.*/

INSERT INTO cliente (rutcliente, clinombres, cliapellidos, clitelefono, cliafp, clisistemasalud, clidireccion, clicomuna, cliedad) VALUES
(123456789, 'Juan', 'Pérez', '+56912345678', 'AFP Modelo', 1, 'Calle 1 #123', 'Valparaíso', 30),
(987654321, 'María', 'González', '+56987654321', 'AFP Cuprum', 2, 'Calle 2 #456', 'Las Condes', 25),
(246810121, 'Pedro', 'Rodríguez', '+56924681012', 'AFP Habitat', 3, 'Calle 3 #789', 'Santiago', 40);

INSERT INTO Visita (visfecha, vishora, vislugar, viscomentarios, rutcliente) VALUES
('2022-03-01', '10:30:00', 'Oficina 101', 'Reunión para revisar estado de proyecto', 123456789),
('2022-03-03', '15:00:00', 'Casa del cliente', 'Presentación de propuesta de diseño', 987654321),
('2022-03-05', '16:00:00', 'Local comercial', 'Visita para tomar medidas y preparar presupuesto', 246810121);

INSERT INTO capacitacion (capfecha, caphora, caplugar, capduracion, rutcliente) VALUES
('2022-03-15', '10:00:00', 'Sala de reuniones', 120, 123456789),
('2022-04-20', '15:30:00', 'Auditorio central', 90, 987654321),
('2022-05-25', '09:00:00', 'Sala de conferencias', 180, 246810121);

INSERT INTO Asistentes (asistnombrecompleto, asistedad, asistecorreo, asisttelefono, idcapacitacion) VALUES 
('Juan Pérez', 30, 'juan.perez@email.com', '123456789', 1),
('María González', 25, 'maria.gonzalez@email.com', '987654321', 1),
('Pedro Sánchez', 40, 'peter.sanchez@email.com', '55555555', 2);

INSERT INTO Accidente (accifecha, accihora, accilugar, acciorigen, acciconsecuencias, rutcliente) VALUES
('2022-03-01', '09:15:00', 'Avenida principal', 'Falla mecánica', 'Daños materiales', 123456789),
('2022-04-02', '15:30:00', 'Calle principal', 'Exceso de velocidad', 'Lesiones leves', 987654321),
('2022-05-03', '12:00:00', 'Intersección de calles', 'No respetar señalización', 'Heridas graves', 246810121);

INSERT INTO Visita (visfecha, vishora, vislugar, viscomentarios, rutcliente) VALUES
('2022-03-01', '10:30:00', 'Oficina 101', 'Reunión para revisar estado de proyecto', 123456789),
('2022-03-03', '15:00:00', 'Casa del cliente', 'Presentación de propuesta de diseño', 987654321),
('2022-03-05', '16:00:00', 'Local comercial', 'Visita para tomar medidas y preparar presupuesto', 246810121);

INSERT INTO chequeo (nombre) VALUES 
('Revision sustancias peligrosas'), 
('Chequeo seguridad instalaciones'), 
('Chequeo instalaciones electricas');

INSERT INTO registros (cumplimiento, observaciones, idchequeo, rutcliente) VALUES
('Sí', 'Todo en orden', 1, 123456789),
('No', 'Faltan documentos', 2, 987654321),
('Sí', 'Esta bien', 3, 246810121);
       
INSERT INTO usuarios (rutusuario, nombre, apellido, fnacimiento) VALUES
(111111111, 'Juan', 'Pérez', '1990-01-15'),
(222222222, 'María', 'González', '1985-03-20'),
(333333333, 'Pedro', 'Rodríguez', '1992-11-05'),
(444444444, 'Carla', 'Fernández', '1987-07-12');
       
INSERT INTO administrativos (rutadmin, nombreadmin, apellidosadmin, correoadmin, areaadmin, rutusuario) VALUES
(123456789, 'Juan', 'Pérez', 'juan.perez@ejemplo.com', 'Administración', 111111111),
(987654321, 'María', 'González', 'maria.gonzalez@ejemplo.com', 'Finanzas', 222222222),
(246810121, 'Pedro', 'Díaz', 'pedro.diaz@ejemplo.com', 'RRHH', 333333333); 
       
INSERT INTO profesionales (rut, nombres, apellidos, telefono, tituloProfesional, proyecto) VALUES 
(111111115, 'Juan', 'Pérez', 912345678, 'Ingeniero Civil', 'Construcción de puente'),
(222222227, 'María', 'González', 912345679, 'Arquitecta', 'Diseño de edificio residencial'),
(333333339, 'Pedro', 'Rodríguez', 912345680, 'Abogado', 'Asesoría legal');
       
INSERT INTO pagos (fecha, monto, mes, año, rutcliente) VALUES 
('2022-01-15', 1000, 'Enero', 2022, 123456789),
('2022-02-15', 1500, 'Febrero', 2022, 987654321),
('2022-03-15', 2000, 'Marzo', 2022, 246810121);

INSERT INTO asesorias (fecha, motivo, asignado) VALUES
('2023-03-01', 'Asesoría financiera', 111111115),
('2023-03-02', 'Asesoría legal', 222222227),
('2023-03-03', 'Asesoría de negocios', 333333339);

INSERT INTO mejoras (titulo, descripcion, plazoResolucion, idasesoria) VALUES 
('Mejora en el proceso de producción', 'Implementar un nuevo sistema de control de calidad', '2023-04-30', 1),
('Mejora en el servicio al cliente', 'Capacitar al personal en atención al cliente', '2023-05-15', 2),
('Mejora en la gestión de inventarios', 'Implementar un sistema de control de inventarios automatizado', '2023-06-30', 3);


/****************************
*   	   CONSULTAS        *
****************************/

/*a) Realice una consulta que permita listar todas las capacitaciones de un cliente en
particular, indicando el nombre completo, la edad y el correo electrónico de los
asistentes.*/

SELECT asistnombrecompleto AS 'Nombre Asistente', asistedad AS 'Edad Asistente', asistecorreo AS 'Correo Asistente'  
FROM sprint.asistentes INNER JOIN capacitacion ON asistentes.idcapacitacion = capacitacion.idcapacitacion 
WHERE capacitacion.rutcliente = 987654321;

/*b) Realice una consulta que permita desplegar todas las visitas en terreno realizadas a 
los clientes que sean de la comuna de Valparaíso. Por cada visita debe indicar todos los 
chequeos que se hicieron en ella, junto con el estado de cumplimiento de cada uno.*/

SELECT	visita.visfecha AS 'Fecha visita', visita.vishora AS 'Hora visita', visita.vislugar AS 'Lugar',  visita.viscomentarios AS 'Comentarios de la visita', visita.rutcliente AS 'RUT cliente',
		cliente.clicomuna AS 'Comuna cliente',
        chequeo.nombre AS 'Chequeo en visita',
        registros.cumplimiento AS 'Cumplimiento'
FROM visita
INNER JOIN cliente ON visita.rutcliente = cliente.rutcliente
INNER JOIN registros ON cliente.rutcliente = registros.rutcliente
INNER JOIN chequeo ON registros.idchequeo = chequeo.idchequeo
WHERE cliente.clicomuna = 'Valparaiso';

/*c) Realice una consulta que despliegue los accidentes registrados para todos los clientes,
indicando los datos de detalle del accidente, y el nombre, apellido, RUT y teléfono del cliente
al que se asocia dicha situación.*/

SELECT accidente.idaccidente AS ID, accidente.accifecha AS 'Fecha Accidente', accidente.accihora 
AS 'Hora Accidente', accidente.accilugar AS 'Lugar Accidente', accidente.acciorigen AS 'Origen Accidente', 
accidente.acciconsecuencias AS 'Consecuencias Accidente', cliente.clinombres AS 'Nombre Cliente',  
cliente.cliapellidos AS 'Apellidos Cliente', cliente.rutcliente AS 'Rut Cliente', cliente.clitelefono 
AS 'Telefono Cliente' FROM sprint.accidente INNER JOIN cliente ON accidente.rutcliente = cliente.rutcliente;

COMMIT;