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


INSERT INTO especialidades (nome) VALUES ('urologista');
INSERT INTO especialidades (nome) VALUES ('ginecologista');
INSERT INTO especialidades (nome) VALUES ('clinica geral');

INSERT INTO profissionais (nome) VALUES ('DrFeelGoodUro');
INSERT INTO profissionais (nome) VALUES ('DrJekyGineco');
INSERT INTO profissionais (nome) VALUES ('DrRay');

INSERT INTO pacientes (nome,sexo,obito) VALUES ('Ada Lovelace','f',false);
INSERT INTO pacientes (nome,sexo,obito) VALUES ('Donald Knuth','m',false);
INSERT INTO pacientes (nome,sexo,obito) VALUES ('Grace Hopper','f',false);
INSERT INTO pacientes (nome,sexo,obito) VALUES ('Dennis Ritchie','m',false);





CREATE OR REPLACE FUNCTION trgValidaDadosConsulta() returns trigger as $trgValidaDadosConsulta$

declare
pacientegenero record;
espec_row record;

begin
  
	SELECT INTO pacientegenero * FROM pacientes as p where p.id = NEW.pac_id;

	SELECT INTO espec_row * FROM especialidades as esp where esp.id = NEW.especialidade_id;

IF pacientegenero.sexo = 'm' AND espec_row.nome = 'ginecologista' THEN
RAISE EXCEPTION 'Ginecologista apenas para genero feminino';

ELSEIF pacientegenero.sexo = 'f' AND espec_row.nome = 'urologista' THEN
RAISE EXCEPTION 'Urologista apenas para genero masculino';
END IF;

RETURN NEW;
END;
$trgValidaDadosConsulta$ LANGUAGE plpgsql;

create TRIGGER trgValidaDadosConsulta
BEFORE INSERT OR UPDATE ON consultas
FOR EACH ROW 
EXECUTE PROCEDURE trgValidaDadosConsulta();



SELECT * FROM pacientes;
SELECT * FROM especialidades;
SELECT * FROM consultas;
SELECT * FROM profissionais;