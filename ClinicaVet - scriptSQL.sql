/*** Criação do banco de dados ***/
CREATE DATABASE ClinicaVet
GO
USE ClinicaVet
GO

/*** Criação da tabela Setor ***/
CREATE TABLE Setor
(
	idsetor smallint			NOT NULL,
	nome    varchar(40)			NOT NULL,
	CONSTRAINT PK_setor			PRIMARY KEY (idsetor),
	CONSTRAINT AK_setor_nome	UNIQUE (nome)
)

/*** Criação da tabela Proprietario ***/
CREATE TABLE Proprietario
(
	idproprietario smallint					NOT NULL,
	nome           varchar(40)				NOT NULL,
	sexo           varchar(1)				NOT NULL,
	datanasc       date						NOT NULL,
	rg             varchar(15)				NOT NULL,
	cpf            varchar(12)				NOT NULL,
	endereco       varchar(40)				NOT NULL,
	bairro         varchar(20)				NOT NULL,
	cidade         varchar(20)				NOT NULL
	CONSTRAINT     DF_proprietario_cidade	DEFAULT 'João Pessoa',
	cep            varchar(10)				NOT NULL,
	fone           varchar(10)				NULL,
	CONSTRAINT PK_proprietario				PRIMARY KEY (idproprietario),
	CONSTRAINT AK_proprietario_rg			UNIQUE (rg),
	CONSTRAINT AK_proprietario_cpf			UNIQUE (cpf),
	CONSTRAINT CK_proprietario_sexo			CHECK (sexo LIKE '[FM]'),
	CONSTRAINT CK_proprieatario_cpf			CHECK (cpf LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9]')
)

/*** Criação da tabela Animal ***/
CREATE TABLE Animal
(
	idanimal       smallint				NOT NULL,
	nome           varchar(40)			NULL,
	sexo           varchar(1)			NOT NULL,
	peso           varchar(5)			NOT NULL,
	idade          smallint				NULL,
	especie        varchar(40)			NOT NULL,
	idproprietario smallint				NOT NULL,
	CONSTRAINT FK_animal_proprietario	FOREIGN KEY (idproprietario) REFERENCES Proprietario,
	CONSTRAINT PK_animal				PRIMARY KEY (idanimal, idproprietario),
	CONSTRAINT CK_animal_sexo			CHECK (sexo LIKE '[FM]')
)

/*** Criação da tabela Medicamento ***/
CREATE TABLE Medicamento
(
	idmedicamento smallint		NOT NULL,
	nome          varchar(40)	NOT NULL,
	CONSTRAINT PK_medicamento	PRIMARY KEY (idmedicamento)
)

/*** Criação da tabela Exame ***/
CREATE TABLE Exame
(
	idexame smallint		NOT NULL,
	nome    varchar(40)		NOT NULL,
	valor   numeric(10, 2)	NOT NULL,
	CONSTRAINT PK_exame		PRIMARY KEY (idexame)
)

/*** Criação da tabela Laboratorio ***/
CREATE TABLE Laboratorio
(
	idlaboratorio smallint			NOT NULL,
	nome          varchar(40)		NOT NULL,
	fone          varchar(10)		NOT NULL,
	cnpj          varchar(12)		NOT NULL,
	CONSTRAINT PK_laboratorio		PRIMARY KEY (idlaboratorio),
	CONSTRAINT AK_laboratorio_cnpj	UNIQUE (cnpj),
	CONSTRAINT CK_laboratorio_cnpj	CHECK (cnpj LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9]')
)

/*** Criação da tabela Veterinario ***/
CREATE TABLE Veterinario
(
	idveterinario smallint					NOT NULL,
	nome          varchar(40)				NOT NULL,
	sexo          varchar(1)				NOT NULL,
	datanasc      date						NOT NULL,
	rg            varchar(15)				NOT NULL,
	cpf           varchar(12)				NOT NULL,
	crmv          varchar(40)				NOT NULL,
	salario       numeric(10, 2)			NOT NULL,
	endereco      varchar(40)				NOT NULL,
	bairro        varchar(20)				NOT NULL,
	cidade        varchar(20)				NOT NULL
	CONSTRAINT    DF_veterinario_cidade		DEFAULT 'João Pessoa',
	cep           varchar(10)				NOT NULL,
	idchefe       smallint					NULL,
	CONSTRAINT PK_veterinario				PRIMARY KEY (idveterinario),
	CONSTRAINT AK_veterinario_rg			UNIQUE (rg),
	CONSTRAINT AK_veterinario_cpf			UNIQUE (cpf),
	CONSTRAINT AK_veterinario_crmv			UNIQUE (crmv),
	CONSTRAINT FK_veterinario_veterinario	FOREIGN KEY (idchefe) REFERENCES Veterinario,
	CONSTRAINT CK_veterinario_sexo			CHECK (sexo LIKE '[FM]'),
	CONSTRAINT CK_veterinario_cpf			CHECK (cpf LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9]')
)

/*** Criação da tabela Fone ***/
CREATE TABLE Fone
(
	idfone        smallint			NOT NULL,
	numero        varchar(10)		NOT NULL,
	idveterinario smallint			NOT NULL,
	CONSTRAINT FK_fone_veterinario	FOREIGN KEY (idveterinario) REFERENCES Veterinario,
	CONSTRAINT PK_fone				PRIMARY KEY (idfone, idveterinario)
)

/*** Criação da tabela Consulta ***/
CREATE TABLE Consulta
(
	idconsulta     smallint				NOT NULL,
	dataconsulta   date					NOT NULL,
	idsetor        smallint				NOT NULL,
	idveterinario  smallint				NOT NULL,
	idanimal       smallint				NOT NULL,
	idproprietario smallint				NOT NULL,
	valor          numeric(10, 2)		NOT NULL,
	CONSTRAINT FK_consulta_setor		FOREIGN KEY (idsetor) REFERENCES Setor,
	CONSTRAINT FK_consulta_veterinario	FOREIGN KEY (idveterinario) REFERENCES Veterinario,
	CONSTRAINT FK_consulta_animal		FOREIGN KEY (idanimal, idproprietario) REFERENCES Animal,
	CONSTRAINT PK_consulta				PRIMARY KEY (idconsulta, idveterinario, idanimal, idproprietario)
)

/*** Criação da tabela Prescricao ***/
CREATE TABLE Prescricao
(
	idconsulta     smallint					NOT NULL,
	idveterinario  smallint					NOT NULL,
	idanimal       smallint					NOT NULL,
	idproprietario smallint					NOT NULL,
	idmedicamento  smallint					NOT NULL,
	dataprescricao date						NOT NULL,
	CONSTRAINT FK_prescricao_consulta		FOREIGN KEY (idconsulta, idveterinario, idanimal, idproprietario) REFERENCES Consulta,
	CONSTRAINT FK_prescricao_medicamento	FOREIGN KEY (idmedicamento) REFERENCES Medicamento,
	CONSTRAINT PK_prescricao				PRIMARY KEY (idconsulta, idveterinario, idanimal, idproprietario, idmedicamento)
)

/*** Criação da tabela Solicitacao ***/
CREATE TABLE Solicitacao
(
	idconsulta      smallint				NOT NULL,
	idveterinario   smallint				NOT NULL,
	idanimal        smallint				NOT NULL,
	idproprietario  smallint				NOT NULL,
	idexame         smallint				NOT NULL,
	datasolicitacao date					NOT NULL,
	idlaboratorio   smallint				NOT NULL,
	CONSTRAINT FK_solicitacao_consulta		FOREIGN KEY (idconsulta, idveterinario, idanimal, idproprietario) REFERENCES Consulta,
	CONSTRAINT FK_solicitacao_exame			FOREIGN KEY (idexame) REFERENCES Exame,
	CONSTRAINT FK_solicitacao_laboratorio	FOREIGN KEY (idlaboratorio) REFERENCES Laboratorio,
	CONSTRAINT PK_solicitacao				PRIMARY KEY (idconsulta, idveterinario, idanimal, idproprietario, idexame)
)

/*** Criação da tabela Cirurgia ***/
CREATE TABLE Cirurgia
(
	idcirurgia     smallint				NOT NULL,
	datacirurgia   date					NOT NULL,
	idsetor        smallint				NOT NULL,
	idvetcirurgia  smallint				NOT NULL,
	idconsulta     smallint				NOT NULL,
	idvetconsulta  smallint				NOT NULL,
	idanimal       smallint				NOT NULL,
	idproprietario smallint				NOT NULL,
	valor          numeric(10, 2)		NOT NULL,
	CONSTRAINT PK_cirurgia				PRIMARY KEY (idcirurgia),
	CONSTRAINT FK_cirurgia_setor		FOREIGN KEY (idsetor) REFERENCES Setor,
	CONSTRAINT FK_cirurgia_veterinario	FOREIGN KEY (idvetcirurgia) REFERENCES Veterinario,
	CONSTRAINT FK_cirurgia_conulta		FOREIGN KEY (idconsulta, idvetconsulta, idanimal, idproprietario) REFERENCES Consulta
)

/*** Inserção de dados na tabela Setor ***/
INSERT INTO Setor VALUES (1,'Ambulatório')
INSERT INTO Setor VALUES (2,'Cirúrgico')
INSERT INTO Setor VALUES (3,'Imagem')
INSERT INTO Setor VALUES (4,'Raio X')
INSERT INTO Setor VALUES (5,'Preventiva')
INSERT INTO Setor VALUES (6,'Esterilização')
INSERT INTO Setor VALUES (7,'Internamento')

/*** Inserção de dados na tabela Proprietario ***/
INSERT INTO Proprietario VALUES (1,'Pedro Gregório Ramos Pimenta','M','31/01/1960','4561236/PB','123456654-12','Av. Espírito Santo, 345','Bairro dos Estados','João Pessoa','58030-065','988233115')
INSERT INTO Proprietario VALUES (2,'Luzinete Vistor Santana','F','23/05/1968','4569974/PB','564541215-65','R. Odete Gomes Araújo, 345','Bessa','João Pessoa','58057-303','987564456')
INSERT INTO Proprietario VALUES (3,'Walderlan Santoa Silva','M','21/09/1961','2359844/PB','456897215-45','R. Silva Mariz, 24','Cruz das Armas','João Pessoa','58038-123',NULL)
INSERT INTO Proprietario VALUES (4,'Gláucio Barbosa Leite','M','12/02/1960','15698435/PB','456987125-98','R. João Teixeira Carvalho, 480','Pedro Gondim','João Pessoa','58037-100',NULL)
INSERT INTO Proprietario VALUES (5,'Maria Creusa Santos Lima','F','12/09/1958','5689741/PB','452136987-72','R. Nestor Costa Melo, 245','Bancários','João Pessoa','58039-190',NULL)
INSERT INTO Proprietario VALUES (6,'Solange Gusmão Porto','F','23/07/1959','65983215/PB','958421350-98','R. João Soares Costa, 24','Cruz das Armas','João Pessoa','58085-490','986554321')
INSERT INTO Proprietario VALUES (7,'Cleobaldo Nunes Matos','M','23/06/1966','21231212/PB','123545455-13','R. Marcina Maria Almeida, 87','Mangabeira II','João Pessoa','58087-252',NULL)
INSERT INTO Proprietario VALUES (8,'Maria Lúcia Sandoval Pessoa','F','29/09/1966','1245789/PB','154896351-87','R. Paulo Franca Marinho, 124','Miramar','João Pessoa','58000-000','987478995')
INSERT INTO Proprietario VALUES (9,'Dorgival Salustiano Vasques','M','14/05/1970','1323659/PB','659784212-12','R. Vicente Leipo, 345','Bessa','João Pessoa','58035-060',NULL)
INSERT INTO Proprietario VALUES (10,'Valda Maria Braga da Silva','F','25/08/1971','4541122/PB','458743878-32','R Alves de Sá, 853','Jardim 13 de Maio','João Pessoa','58035-012',NULL)

/*** Inserção de dados na tabela Animal ***/
INSERT INTO Animal VALUES (1,'Berimbau','M','12',5,'Canino',1)
INSERT INTO Animal VALUES (2,'Capeta','M','24',8,'Canino',2)
INSERT INTO Animal VALUES (3,'Baby','F','3,6',5,'Felino',3)
INSERT INTO Animal VALUES (4,'Kit Nelson','M','4',6,'Felino',4)
INSERT INTO Animal VALUES (5,'Emile','F','4,5',7,'Felino',5)
INSERT INTO Animal VALUES (6,'Lady','F','20',10,'Canino',6)
INSERT INTO Animal VALUES (7,'Hiroshima','M','22',12,'Canino',7)
INSERT INTO Animal VALUES (8,'Nagazap','M','19',14,'Canino',8)
INSERT INTO Animal VALUES (9,'Madonna','F','4',8,'Felino',9)
INSERT INTO Animal VALUES (10,'Hulk','M','6',4,'Felino',10)

/*** Inserção de dados na tabela Medicamento ***/
INSERT INTO Medicamento VALUES (1,'Meloxican')
INSERT INTO Medicamento VALUES (2,'Petsporin')
INSERT INTO Medicamento VALUES (3,'Prediderm')
INSERT INTO Medicamento VALUES (4,'Atropina')
INSERT INTO Medicamento VALUES (5,'Clorfeniramina')
INSERT INTO Medicamento VALUES (6,'Doxitec')
INSERT INTO Medicamento VALUES (7,'Otomax')

/*** Inserção de dados na tabela Exame ***/
INSERT INTO Exame VALUES (1,'Sangue','42')
INSERT INTO Exame VALUES (2,'Urina','42')
INSERT INTO Exame VALUES (3,'Fezes','42')
INSERT INTO Exame VALUES (4,'Retal','42')
INSERT INTO Exame VALUES (5,'Raio X','25')
INSERT INTO Exame VALUES (6,'Oftalmológico','25')
INSERT INTO Exame VALUES (7,'Ultrassonografia','25')
INSERT INTO Exame VALUES (8,'Odontológico','25')
INSERT INTO Exame VALUES (9,'Endoscopia','42')
INSERT INTO Exame VALUES (10,'Rinoscopia','42')
INSERT INTO Exame VALUES (11,'Laringoscopia','42')
INSERT INTO Exame VALUES (12,'Broncoscopia','42')

/*** Inserção de dados na tabela Laboratorio ***/
INSERT INTO Laboratorio VALUES (1,'Nutrivet','244.5897','222721637-12')
INSERT INTO Laboratorio VALUES (2,'Animal Prime','246.2741','234678234-98')
INSERT INTO Laboratorio VALUES (3,'Gamavet','226.2340','123658123-98')
INSERT INTO Laboratorio VALUES (4,'Focus Vet','244.5612','123456789-10')
INSERT INTO Laboratorio VALUES (5,'Provet','246.3298','326598747-45')
INSERT INTO Laboratorio VALUES (6,'NewVet','228.2543','235698523-98')

/*** Inserção de dados na tabela Veterinario ***/
INSERT INTO Veterinario VALUES (1,'Paulo Brandão Albuquerque','M','21/05/1963','54564545/PB','986531245-48','1654/PB','10000','R. Libertadores, 234','Centro','João Pessoa','58000-000',NULL)
INSERT INTO Veterinario VALUES (2,'Francisca Lopes Gonzaga','F','12/06/1973','21313148/PB','212354112-15','1766/PB','6000','Av. Marechal Deodoro, 678','Torre','João Pessoa','58045-065',NULL)
INSERT INTO Veterinario VALUES (3,'Sandra Almeida Prado','F','14/02/1968','645641545/PB','656454598-16','1620/PB','6000','R. Nunes Filho, 234','Tambauzinho','João Pessoa','58033-030',NULL)
INSERT INTO Veterinario VALUES (4,'Clóvis Beltrão Borba','M','25/05/1962','15345668/PB','156456456-12','1950/PB','6000','R. Carlos Alverga, 34','Tambaú','João Pessoa','58045-012',NULL)
INSERT INTO Veterinario VALUES (5,'Vilibaldo Saturnino Simão','M','07/03/1971','22313545/PB','562314897-15','1555/PB','6000','R, Lindolfo José Neves, 419','Bessa','João Pessoa','58037-520',NULL)
INSERT INTO Veterinario VALUES (6,'João Astrolábio Bezerra','M','16/05/1960','987587589/PB','987654321-98','1464/PB','6000','Av. São Paulo, 324','Bairro dos Estados','João Pessoa','58030-061',NULL)

/*** Inserção de dados na tabela Fone ***/
INSERT INTO Fone VALUES (1,'981.1222',1)
INSERT INTO Fone VALUES (2,'981.2784',1)
INSERT INTO Fone VAlUES (3,'982.1333',1)
INSERT INTO Fone VALUES (4,'984.1245',2)
INSERT INTO Fone VALUES (5,'985.4589',2)
INSERT INTO Fone VALUES (6,'981.2374',3)
INSERT INTO Fone VALUES (7,'982.5575',3)
INSERT INTO Fone VALUES (8,'983.2258',4)
INSERT INTO Fone VALUES (9,'984.3636',4)
INSERT INTO Fone VALUES (10,'981.4568',5)
INSERT INTO Fone VALUES (11,'985.2658',5)
INSERT INTO Fone VALUES (12,'985.5987',6)
INSERT INTO Fone VALUES (13,'982.3568',6)


/*** Inserção de dados na tabela Consulta ***/
INSERT INTO Consulta VALUES (1,'21/05/2018',1,1,1,1,'120')
INSERT INTO Consulta VALUES (2,'12/06/2018',1,2,2,2,'120')
INSERT INTO Consulta VALUES (3,'14/02/2018',1,3,3,3,'120')
INSERT INTO Consulta VALUES (4,'25/05/2018',1,4,4,4,'120')
INSERT INTO Consulta VALUES (5,'07/03/2018',1,5,5,5,'120')
INSERT INTO Consulta VALUES (6,'16/05/2018',1,6,6,6,'120')
INSERT INTO Consulta VALUES (7,'31/01/2018',1,4,7,7,'120')
INSERT INTO Consulta VALUES (8,'20/11/2017',1,2,8,8,'120')
INSERT INTO Consulta VALUES (9,'12/12/2017',1,6,9,9,'120')
INSERT INTO Consulta VALUES (10,'14/12/2017',1,1,10,10,'120')

/*** Inserção de dados na tabela Prescricao ***/
INSERT INTO Prescricao VALUES (1,1,1,1,2,'21/05/2018')
INSERT INTO Prescricao VALUES (3,3,3,3,1,'14/02/2018')
INSERT INTO Prescricao VALUES (5,5,5,5,6,'07/03/2018')
INSERT INTO Prescricao VALUES (7,4,7,7,4,'31/01/2018')
INSERT INTO Prescricao VALUES (8,2,8,8,5,'20/11/2017')
INSERT INTO Prescricao VALUES (10,1,10,10,2,'14/12/2017')

/*** Inserção de dados na tabela Solicitacao ***/
INSERT INTO Solicitacao VALUES (2,2,2,2,1,'12/06/2018',1)
INSERT INTO Solicitacao VALUES (4,4,4,4,6,'25/05/2018',2)
INSERT INTO Solicitacao VALUES (6,6,6,6,3,'16/05/2018',5)
INSERT INTO Solicitacao VALUES (1,1,1,1,6,'21/05/2018',1)
INSERT INTO Solicitacao VALUES (3,3,3,3,5,'14/02/2018',5)
INSERT INTO Solicitacao VALUES (10,1,10,10,1,'14/12/2017',2)

/*** Inserção de dados na tabela Cirurgia ***/
INSERT INTO Cirurgia VALUES (1,'23/05/2018',2,6,1,1,1,1,'450')
INSERT INTO Cirurgia VALUES (2,'15/02/2018',2,4,3,3,3,3,'500')
INSERT INTO Cirurgia VALUES (3,'12/06/2018',2,1,2,2,2,2,'450')
INSERT INTO Cirurgia VALUES (4,'25/05/2018',2,5,4,4,4,4,'600')
INSERT INTO Cirurgia VALUES (5,'17/05/2018',2,2,6,6,6,6,'450')
INSERT INTO Cirurgia VALUES (6,'01/02/2018',2,6,7,4,7,7,'500')




/*** Atualização da coluna valor na tabela Exame ***/
UPDATE Exame
SET valor = valor*1.10
WHERE valor = '42'

/*** Atualizacão das colunas salario e idchefe na tabela Veterinário ***/
UPDATE Veterinario
SET idchefe = 1
WHERE idveterinario != 1

UPDATE Veterinario
SET salario = salario*1.12
WHERE idchefe IS NOT NULL



/*** Exclusão de dados com condição em pelo menos duas tabelas ***/
DELETE FROM Exame
WHERE idexame IN (11,12)

DELETE FROM Medicamento
WHERE nome = 'Otomax'