DECLARE
    TYPE rec_pessoa_type IS RECORD (
       id_pessoa     pessoa.id_pessoa%type,
       nome_completo pessoa.nome_completo%type,
       idade         NUMBER(4)
    );
    --
    TYPE tab_pessoa_type IS TABLE OF rec_pessoa_type
       INDEX BY BINARY_INTEGER;
    --
    pessoa_type tab_pessoa_type;
    --
    v_contador NUMBER := 1;
    --
    cursor cur_pessoa_ativa is
           select p.id_pessoa
                 ,p.nome_completo
                 ,trunc(months_between(sysdate,p.dt_nascimento)/12) idade
             from pessoa p
            where 1=1
              and p.status = 'A'
           ;
BEGIN
    open cur_pessoa_ativa;
    --
    loop
        fetch cur_pessoa_ativa into pessoa_type(v_contador);
         exit when cur_pessoa_ativa%notfound;
        dbms_output.put_line(pessoa_type(v_contador).nome_completo||' - '||pessoa_type(v_contador).idade);
        v_contador := v_contador + 1;
    end loop;
    --
    close cur_pessoa_ativa;
    --
    dbms_output.put_line('Total de linhas em memória para pessoa_type: '||pessoa_type.COUNT);
END;

/*
-- CRIACAO DE TABELAS
CREATE TABLE pessoa (
    id_pessoa NUMBER(11) NOT NULL,
    nome_completo VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    dt_nascimento DATE NOT NULL,
    sexo VARCHAR2(1) NOT NULL,
    status VARCHAR2(1) NOT NULL, --I=INATIVO,A=ATIVO
    PRIMARY KEY (id_pessoa)
);

-- INCLUSAO DE INFORMACOES
insert into pessoa values (1,'João Henrique da Silva','joaohs@joaohs.com',to_date('01/01/1990','dd/mm/yyyy'),'M','A');
insert into pessoa values (2,'Ana Patrícia Monteiro Dias','anapmd@anapmd.com',to_date('05/05/2006','dd/mm/yyyy'),'F','A');
insert into pessoa values (3,'Carlos José Pinheiro','carlosjp@carlosjp.com',to_date('05/05/2006','dd/mm/yyyy'),'M','I');
*/
