create table llibres(
  codi number generated as identity,
  titol varchar(60) not null,
  autor varchar(30),
  editorial varchar(15),
  preu number(5,2),
  primary key (codi)
);

insert into llibres (titol, autor, editorial, preu) values('El principito','Antonine de Saint','Planeta',15);
insert into llibres (titol, autor, editorial, preu) values('La Cocinera de Castamar','Fernando J. Múñez','Planeta',40);
insert into llibres (titol, autor, editorial, preu) values('Yerma','Federico García Lorca','Planeta',40);
insert into llibres (titol, autor, editorial, preu) values('Cómo hacer que te pasen cosas buenas','Marián Rojas','Espasa',18.20);
insert into llibres (titol, autor, editorial, preu) values('Mecanoscrit del segon origen','Manuel de Pedrolo','Espasa',15);
insert into llibres (titol, autor, editorial, preu) values('Magia y enigma','Henry Kamen','Espasa',22.20);
insert into llibres (titol, autor, editorial, preu) values('Matilda','Roald Dahl','Alfaguara',36.40);
insert into llibres (titol, autor, editorial, preu) values('Momo', 'Michael Ende', 'Alfaguara',30.80);
insert into llibres (titol, autor, editorial, preu) values('Mujercitas','Louisa May Alcott','Alfaguara',45.00);
insert into llibres (titol, autor, editorial, preu) values('La historia interminable','Michael Ende','Alfaguara',46.00);
insert into llibres (titol, autor, editorial, preu) values('Peter Pan','J.M. Barrie','Alfaguara',null);

select * from llibres;

-- 1. Llistar la quantitat de llibres agrupats per editorial:
-- Columnes: Editorial, recompte llibres
SELECT EDITORIAL, COUNT(*) AS Recompte_llibres  FROM LLIBRES GROUP BY EDITORIAL;
-- 2. Llistar la quantitat de llibres agrupats per editorial, però només els grups editorials que tenen més de quatre llibres:
-- Columnes: Editorial, recompte llibres
SELECT EDITORIAL, COUNT(*) AS Recompte_llibres  FROM LLIBRES GROUP BY EDITORIAL HAVING COUNT(*) > 4;
-- 3. Llistar la mitjana dels preus dels llibres agrupats per editorial i ordenats per preu descendent:
-- Columnes: editorial, preu mitjà
SELECT EDITORIAL, AVG(PREU) AS Preu_Mitja FROM LLIBRES GROUP BY EDITORIAL ORDER BY AVG(PREU) DESC;
-- 4. Llistar la mitjana dels preus dels llibres agrupats per editorial, però només aquells la mitjana dels quals superi els 25 euros:
-- Columnes: editorial, preu mitjà
SELECT EDITORIAL, AVG(PREU) AS Preu_Mitja FROM LLIBRES GROUP BY EDITORIAL HAVING AVG(PREU) > 25;
-- 5. Llistar nombre de llibres agrupats per editorial sense tenir en compte l'editorial "Planeta":
-- Columnes: editorial, recompte llibres
SELECT EDITORIAL, COUNT(*) AS RECOMPTE_LLIBRES FROM LLIBRES WHERE UPPER(EDITORIAL) != Upper('Planeta') GROUP BY EDITORIAL ;
-- 6. Llistar nombre de llibres agrupats per editorial sense tenir en compte l'editorial "Planeta" ni els llibres amb preu nul:
-- Columnes: editorial, recompte llibres
SELECT EDITORIAL, COUNT(*) AS Recompte_llibres FROM LLIBRES WHERE UPPER(EDITORIAL) != UPPER('PLANETA') AND PREU IS NOT NULL GROUP BY EDITORIAL;
-- 7. Llistar mitjana dels preus agrupats per editorial d'aquelles editorials que tenen més de 2 llibres:
-- Columnes: editorial, preu mitjà
SELECT EDITORIAL, AVG(PREU) AS PREU_MITJA FROM LLIBRES group by EDITORIAL HAVING COUNT(*) > 2;
-- 8. Llistar el preu més gran d'un llibre per editorial i ordenat per preu descendent:
-- Columnes: editorial, preu més car
SELECT EDITORIAL, MAX(PREU) AS PREU_MES_CAR FROM LLIBRES GROUP BY EDITORIAL ORDER BY MAX(PREU) DESC;
-- 9. Llistar el preu més gran d'un llibre per editorial d'aquelles que tinguin, almenys, un llibre que superi els 30 euros:
-- Columnes: editorial, preu més car
SELECT EDITORIAL, MAX(PREU) AS PREU_MES_CAR FROM LLIBRES group by EDITORIAL HAVING MAX(PREU) > 30 ORDER BY MAX(PREU) DESC ;
-- 10. Llistar el títol i l'autor dels llibres amb títol que comenci per la lletra "M" i l'autor dels quals contingui la lletra "H", independent de majúscula/minúscula:
-- Columnes: títol, autor
SELECT TITOL, AUTOR FROM  LLIBRES WHERE UPPER(TITOL) LIKE(UPPER('M%')) AND UPPER(AUTOR) LIKE(UPPER('%H%'));
-- 11. Llistar la quantitat de llibres agrupats per autor, ordenat per quantitat descendent:
-- Columnes: autor, quantitat llibres
SELECT AUTOR, COUNT(*) AS QUANTITA_LLIBRES FROM LLIBRES GROUP BY AUTOR ORDER BY COUNT(*) DESC;
-- 12. Llista les diferents lletres inicials dels titols dels llibres i el preu promig dels llibres amb un títol que comenci per aquesta lletra. Ordena per preu ascendent:
-- Columnes: Lletra inicial títol, preu mitjà
SELECT SUBSTR(TITOL,1,1) AS LLETRA_INICIAL, AVG(PREU) AS PREU_MITJA FROM LLIBRES group by SUBSTR(TITOL,1,1) ORDER BY AVG(PREU) ASC;