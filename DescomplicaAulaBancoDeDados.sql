create database descomplica;

use descomplica;

create table aluno(
	id_aluno integer not null primary key auto_increment, 
    nome_aluno varchar(255),
	id_materia integer not null,
    foreign key fk_id_materia (id_materia) references materia(id_materia)
);

create table materia(
	id_materia integer primary key auto_increment,
    nome_materia varchar(255) not null
);

insert into materia (nome_materia) values("português");
insert into materia (nome_materia) values("matemática");
insert into materia (nome_materia) values("história");
insert into materia (nome_materia) values("geografia");
insert into materia (nome_materia) values("inglês");
insert into materia (nome_materia) values("biologia");

insert into aluno (nome_aluno, id_materia) values ("Miguel", 1);
insert into aluno (nome_aluno, id_materia) values ("Jose", 1);
insert into aluno (nome_aluno, id_materia) values ("João", 2);
insert into aluno (nome_aluno, id_materia) values ("Luanita", 3);
insert into aluno (nome_aluno, id_materia) values ("Rafaela", 4);
insert into aluno (nome_aluno, id_materia) values ("Jorge", 5);

-- criando uma view simples

create or replace view consulta_aluno_vw 
	as select * from aluno as a
    where a.id_materia = 1;
    
create or replace view consulta_todos_aluno_vw
		as select * from aluno;
        
-- criando uma view complexa        
create or replace view consulta_aluno_materia_vw (id_aluno, nome_aluno, id_materia, nome_materia)  as 
	select aluno.id_aluno, aluno.nome_aluno, materia.id_materia, materia.nome_materia from aluno
	inner join materia
    on aluno.id_materia = materia.id_materia
    order by materia.nome_materia desc;
    
select * from consulta_aluno_materia_vw;   
    
select * from consulta_aluno_vw;   

select * from consulta_todos_aluno_vw; 

-- criando index

create index nome_index on aluno(nome_aluno);
create index id_materia_index on aluno(id_materia);

select * from aluno where nome_aluno = "Miguel";
select * from aluno where id_materia = 1;

-- criando store procedure com parâmetros

delimiter $$
create procedure sp_inserindo_nome
	(nomeAluno varchar(255), 
    idMateria integer)
begin
	insert into aluno (nome_aluno, id_materia) values(nomeAluno,idMateria);
end$$
delimiter ;

-- criando store procedure sem parâmetro

delimiter $$
create procedure sp_recupera_todos_alunos() 
begin
	select *from aluno;
end$$
delimiter ;

-- no oracle é usado o comando exec no lugar de call

-- procedure com parametro
call sp_inserindo_nome("Lucas", 1);

-- procedure sem parametro
call sp_recupera_todos_alunos();

-- criando uma trigger "gatilho"

delimiter $$
create trigger muda_nome_wesley_bir
	before insert on aluno
	for each row
    begin
		if new.nome_aluno = "Wesley" then
			set new.nome_aluno = "Teste";
        end if;    
	end$$
delimiter ;   

drop trigger muda_nome_wesley_bir;    
        
insert into aluno (nome_aluno, id_materia) values("Wesley", 2);

select *from aluno;

-- criando uma tabela de copia usando o select
create table copia_aluno (select *from aluno);

alter table copia_aluno add primary key (id_aluno);

-- vendo estrutura da tabela
describe copia_aluno;

-- trucate limpa tabela copia_aluno
truncate copia_aluno;

-- insert com select
insert into copia_aluno (nome_aluno, id_materia)
    select aluno.nome_aluno, aluno.id_materia from aluno where nome_aluno = "Wesley";

select *from copia_aluno;