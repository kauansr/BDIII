CREATE OR REPLACE FUNCTION trgValidaDadosConsulta() returns trigger as $trgValidaDadosConsulta$

declare
pac_row record;
espec_row record;

begin
    RAISE NOTICE 'Meu trigger rodou!!!';
    RETURN NEW;

END;
$trgValidaDadosConsulta$ LANGUAGE plpgsql;

create TRIGGER trgValidaDadosConsulta
BEFORE INSERT OR UPDATE ON consultas
FOR EACH ROW 
EXECUTE PROCEDURE trgValidaDadosConsulta();
