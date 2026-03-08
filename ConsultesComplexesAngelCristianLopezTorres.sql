CREATE TABLE EDITORIAL(
    ID number generated as identity primary key,
    nom varchar2(50)
);

CREATE TABLE LLIBRE (
    ID number generated as identity primary key,
    titol varchar2(50),
    an number,
    exemplars number,
    ID_editorial number NOT NULL,
    ID_sequela_de number,
    foreign key (ID_editorial) references EDITORIAL(ID),
    foreign key (ID_sequela_de) references LLIBRE(ID)
);

CREATE TABLE AUTOR (
    ID number generated as identity primary key,
    nom varchar2(50),
    cognoms varchar2(50),
    data_naix date,
    nacionalitat varchar2(3)
);

CREATE TABLE AUTOR_LLIBRE(
    ID_autor number,
    ID_llibre number,
    primary key(ID_autor, ID_llibre),
    foreign key (ID_autor) references AUTOR(ID),
    foreign key (ID_llibre) references LLIBRE(ID)
);

CREATE TABLE GENERE(
    nom varchar2(50) primary key
);

CREATE TABLE LLIBRE_GENERE(
    ID_llibre number,
    nom_genere varchar2(50),
    foreign key (ID_llibre) references LLIBRE(ID),
    foreign key (nom_genere) references GENERE(nom),
    primary key (ID_llibre, nom_genere)
);

--Sobre Biblioteca_U6.sql

--Sense JOIN
--1. Llista els llibres (títol) amb el seu gènere (nom).
--Columnes: títol del llibre, nom del gènere
SELECT llib.titol, gen.nom FROM LLIBRE llib, LLIBRE_GENERE llibgen, GENERE gen WHERE llib.ID = llibgen.ID_llibre AND llibgen.nom_genere = gen.nom;
--2. Llista els títols i autor (nom i llinatge) dels llibres d'autors no espanyols.
--Columnes: títol llibre, nom i llinatge autor
SELECT llib.titol, aut.nom || ' ' || aut.cognoms FROM LLIBRE llib, AUTOR aut, AUTOR_LLIBRE autllib where autllib.id_autor = aut.id AND autllib.id_llibre = llib.id AND aut.nacionalitat != 'ESP';
--3. Llista els títols, el gènere (nom) i l'autor (nom i llinatges) de cada llibre. (Si un llibre té més d'un autor o gènere, el seu títol sortirà repetit).
--Columnes: títol llibre, nom gènere, nom i llinatges autor
SELECT llib.titol, gen.nom, aut.nom || ' ' || aut.cognoms FROM LLIBRE llib, AUTOR aut, AUTOR_LLIBRE autllib, GENERE gen, LLIBRE_GENERE llibgen where autllib.id_autor = aut.id AND autllib.id_llibre = llib.id AND llib.id = llibgen.id_llibre AND gen.nom = llibgen.nom_genere;
--4. Llista els llibres (títol) amb només un autor.
--Columnes: títol llibre
SELECT llib.titol FROM LLIBRE llib, AUTOR aut, AUTOR_LLIBRE autllib where llib.id = autllib.id_llibre AND autllib.id_autor = aut.id GROUP BY llib.titol having COUNT(aut.id) = 1;
--5. Llista el nombre d'exemplars totals de cada autor (nom i llinatges).
--Columnes: nom i llinatges autor, número d'exemplars d'entre tots els seus llibres
SELECT aut.nom || ' ' || aut.cognoms ,SUM(llib.exemplars) FROM LLIBRE llib, AUTOR aut, AUTOR_LLIBRE autllib where autllib.id_autor = aut.id AND autllib.id_llibre = llib.id GROUP BY aut.nom, aut.cognoms;
--Amb JOIN
--6. Llista els autors (nom i llinatges) sense llibres.
--Columnes: nom i llinatges autor
SELECT aut.nom, aut.cognoms FROM AUTOR aut 
LEFT JOIN AUTOR_LLIBRE autllib ON aut.id = autllib.id_autor
where autllib.id_llibre is null;
--7. Llista els llibres (títol) amb el seu gènere (nom).
--Columnes: títol llibre, nom gènere
SELECT llib.titol, gen.nom FROM LLIBRE llib
JOIN LLIBRE_GENERE llibgen ON llib.id = llibgen.id_llibre
JOIN GENERE gen ON gen.nom = llibgen.nom_genere;
--8. Llista els gèneres (nom) sense llibres.
--Columnes: nom gènere
SELECT gen.nom FROM GENERE gen
LEFT JOIN LLIBRE_GENERE llibgen ON gen.nom = llibgen.nom_genere where llibgen.id_llibre is null;
--9. Llista els títols i autor (nom i llinatge) dels llibres d'autors espanyols.
--Columnes: títol llibre, nom i llinatge autor
SELECT llib.titol,aut.nom|| ' ' || aut.cognoms FROM LLIBRE llib
JOIN AUTOR_LLIBRE autllib ON llib.id = autllib.id_llibre
JOIN AUTOR aut ON autllib.id_autor = aut.id where UPPER(aut.nacionalitat) = UPPER('ESP');

--10. Llista els títols, el gènere (nom) i l'autor (nom i llinatges) de cada llibre. (Si un llibre té més d'un autor o gènere, el seu títol sortirà repetit). Mostra només els que tenen autor conegut i gènere.
--Columnes: títol llibre, nom gènere, nom i llinatges autor
SELECT llib.titol, gen.nom, aut.nom|| ' ' || aut.cognoms FROM LLIBRE llib
JOIN AUTOR_LLIBRE autllib ON llib.id = autllib.id_llibre
JOIN AUTOR aut ON aut.id = autllib.id_autor
JOIN LLIBRE_GENERE llibgen ON llibgen.id_llibre = llib.id
JOIN GENERE gen ON gen.nom = llibgen.nom_genere;
--11. Repeteix la consulta anterior, però també han de poder sortir els llibres sense gènere ni autor.
--Columnes: títol llibre, nom gènere, nom i llinatges autor
SELECT llib.titol, gen.nom, aut.nom|| ' ' || aut.cognoms FROM LLIBRE llib
LEFT JOIN AUTOR_LLIBRE autllib ON llib.id = autllib.id_llibre
LEFT JOIN AUTOR aut ON aut.id = autllib.id_autor
LEFT JOIN LLIBRE_GENERE llibgen ON llibgen.id_llibre = llib.id
LEFT JOIN GENERE gen ON gen.nom = llibgen.nom_genere;
--12. Llista els llibres (títol) amb més d'un autor.
--Columnes: títol llibre
SELECT llib.titol FROM LLIBRE llib
JOIN AUTOR_LLIBRE autllib ON llib.id = autllib.id_llibre GROUP BY llib.titol HAVING COUNT(autllib.id_autor) > 1;
--13. Llista el nombre d'exemplars totals de l'autor "Federico García Lorca".
--Columnes: número d'exemplars
SELECT SUM(llib.exemplars) FROM LLIBRE llib
JOIN AUTOR_LLIBRE autllib ON llib.id = autllib.id_llibre
JOIN AUTOR aut ON aut.id = autllib.id_autor where UPPER(aut.nom) = UPPER('Federico') AND UPPER(aut.cognoms) = UPPER('García Lorca');
--14. Llista el nombre d'exemplars totals de cada autor. Si un autor no té cap llibre (i per tant, exemplars), ha de sortir un 0.
--Columnes: nom i llinatges autor, número d'exemplars total
SELECT aut.nom, aut.cognoms, NVL(SUM(llib.exemplars),0) FROM AUTOR aut
LEFT JOIN AUTOR_LLIBRE autllib ON aut.id = autllib.id_autor
LEFT JOIN LLIBRE llib ON llib.id = autllib.id_llibre GROUP BY aut.nom, aut.cognoms;
--15. Llista el primer i darrer any en que va treure un llibre cada autor, només d'aquells autors que tenen llibres.
--Columnes: nom i llinatges autor, primer any de llançament d'un llibre, darrer any de llançament d'un llibre
SELECT aut.nom, aut.cognoms, MIN(llib.an), MAX(llib.an) FROM autor aut
JOIN autor_llibre autllib ON aut.id = autllib.id_autor
JOIN LLIBRE llib ON llib.id = autllib.id_llibre 
GROUP BY aut.nom, aut.cognoms;