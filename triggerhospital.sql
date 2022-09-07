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

INSERT INTO consultas (especialidade_id,pac_id,profiss_id) values (1,1,1);


ALTER TABLE consultas ADD COLUMN last_user_updated varchar(100);
ALTER TABLE consultas ADD COLUMN last_time_updated timestamp;

CREATE OR REPLACE FUNCTION trgValidaDadosConsulta() returns trigger as $trgValidaDadosConsulta$

declare
pac_row record;
espec_row record;

begin
    if NEW.especialidade_id is null then
	RAISE EXCEPTION 'Especialdide_id nao informada.';
END if;
    if NEW.pac_id is null then
RAISE EXCEPTION 'consulta precisa de paciente';
end if;
	
     if NEW.profiss_id is null then
	RAISE EXCEPTION 'INDICAR qual a profissao';
END IF;
	
	SELECT INTO pac_row * from pacientes as p where p.id = NEW.especialidade_id;

	SELECT INTO espec_row * from especialidades as esp where esp.id = NEW.especialidade_id;

	if pac_row.sexo = 'm' AND espec_row.nome = 'ginecologista' THEN
	RAISE EXCEPTION 'gINECOLOGISTA APENAS PARA pacientes femininos';
	ELSEIF pac_row.sexo = 'f' AND espec_row.nome = 'urologista' THEN
	RAISE EXCEPTION 'Urologista apenas para pacientes masculinos';
	END IF;

	NEW.last_time_updated := current_timestamp;
	NEW.last_user_updated := 'nomeDoUsuario';
	RETURN NEW;
END;
$trgValidaDadosConsulta$ LANGUAGE plpgsql;

create TRIGGER trgValidaDadosConsulta
BEFORE INSERT OR UPDATE ON consultas
FOR EACH ROW 
EXECUTE PROCEDURE ValidaDadosConsulta();

SELECT * FROM pacientes;
SELECT * FROM especialidades;
SELECT * FROM consultas;
SELECT * FROM profissionais;
