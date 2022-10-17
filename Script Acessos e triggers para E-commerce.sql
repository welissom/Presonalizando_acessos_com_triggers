use company;

-- Número de empregados por departamento e localidade
create view emp_dept_loc as
 select count(*) as Quant_empregados from employee as em
	inner join departament as de
		on em.Dno = de.Dnumber
    inner join dept_locations as dl
		on de.Dnumber = dl.Dnumber;

select * from emp_dept_loc;

-- Lista de departamentos e seus gerentes
create view dept_manager as
	select de.Sname as departamento, concat(emp.Fname,'',emp.Minit,'',emp.Lname) as gerente from departament as de
		inner join employee as emp on Mgr_ssn = Super_ssn;

select * from dept_manager;

-- Projetos com maior número de empregados(ex: por ordenação desc)

-- create view numero_emp as
create view numero_emp as
	select * from project 
		inner join employee on Dno = Dnum
        where Dnum > 4 order by salary desc;
        
select * from numero_emp;
drop view numero_emp;

-- Lista de projetos, departamentos e gerentes
create view Lista_proj_dept_ger as
select Pname, Plocation, Sname, Mgr_ssn, concat(Fname,' ',Minit,' ',Lname) as nome, Address, sex, Salary from project
	inner join departament on Dnum = Dnumber
    inner join employee on Super_ssn = Mgr_ssn;
    
select * from Lista_proj_dept_ger;

-- Quais empregados possuem dependentes e são gerentes
select * from employee
	inner join dependent on Ssn = Essn
    and Super_ssn is not null;
    
-- Privilégios de conexão para gerente

create user 'gerente'@localhost identified by '123456';
grant all privileges on company.departament to 'gerente'@localhost;
grant all privileges on company.employee to 'gerente'@localhost;

-- criação da trigger before delete
create table backup_clients(
	idClient int primary key auto_increment,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11),
    Address varchar(200)
);

delimiter $
create trigger bkp_clients
	before delete on clients
    for each row
    begin
		insert into backup_clients values(null, old.Fname, old.Minit, old.Lname, old.CPF, old.address);
	end $
delimiter ;

delete from clients where idClient = 7;

-- Criação da trigger before update
delimiter $
create trigger comission_seller
	before update on seller
    for each row
    begin
		set new.comission = new.comission * 1.2;
	end $
delimiter ;

 update seller set comission = 1100.00 where idSeller = 1;
