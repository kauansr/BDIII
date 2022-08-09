create table if not exists pacientes(
	id serial PRIMARY KEY,
	nome varchar(40) not null,
	sexo varchar(1),
	obito boolean,
	insertedAt TIMESTAMP NOT NULL DEFAULT NOW());

create table if not exists profissionais(
	id serial PRIMARY KEY,
	nome varchar(50));


create table if not exists especialidades(
	id serial PRIMARY KEY,
	nome varchar(50));

create table if not exists consultas(
	id serial PRIMARY KEY,
	
	especialidade_id integer,
	pac_id integer,
	profiss_id integer);

create table if not exists obitos(
	id serial PRIMARY KEY,
	obs text);

ALTER TABLE consultas
ADD CONSTRAINT FkEspecialidadeDaConsulta FOREIGN KEY(especialidade_id) REFERENCES especialidades(id);

ALTER TABLE consultas
ADD CONSTRAINT FkProfissionalDaConsulta FOREIGN KEY(profiss_id) REFERENCES profissionais(id);


INSERT INTO especialidades (nome) VALUES ("urologista");
INSERT INTO especialidades (nome) VALUES ("ginecologista");
INSERT INTO especialidades (nome) VALUES ("clinica geral");

INSERT INTO profissionais (nome) VALUES ("DrFeelGoodUro");
INSERT INTO profissionais (nome) VALUES ("DrJekyGineco");
INSERT INTO profissionais (nome) VALUES ("DrRay");

INSERT INTO pacientes (nome,sexo,obito) VALUES ("Ada Lovelace","f",false);
INSERT INTO pacientes (nome,sexo,obito) VALUES ("Donald Knuth","m",false);
INSERT INTO pacientes (nome,sexo,obito) VALUES ("Grace Hopper","f",false);
INSERT INTO pacientes (nome,sexo,obito) VALUES ("Dennis Ritchie","m",false);



SELECT * FROM especialidades;
SELECT * FROM profissionais;
SELECT * FROM pacientes;
SELECT * FROM consultas;