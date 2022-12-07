# Problème 1

**Question 1.1**

<details>
Trouver les enregistrements qui n'ont pas de capital

```
SELECT * FROM COUNTRY WHERE CAPITAL IS NULL;
```

Empêcher la capitale d'un pays d'avoir une valeur nulle
```
ALTER TABLE COUNTRY MODIFY (CAPITAL VARCHAR2(50) NOT NULL);
```

</details>

Ajouter la contrainte de la clé étrangère
``` 
ALTER TABLE COUNTRY 
ADD CONSTRAINT FK_COUNTRY_CAPITAL_CITY 
FOREIGN KEY (CAPITAL, CODE, PROVINCE) 
REFERENCES CITY(NAME, COUNTRY, PROVINCE);
``` 

**Question 1.2**

Ajouter la contrainte d'unicité
```
ALTER TABLE COUNTRY ADD CONSTRAINT U_NOM_COUNTRY UNIQUE(NAME);
```

**Question 1.3**

Empêcher le nom d'un pays d'avoir une valeur nulle
```
ALTER TABLE COUNTRY MODIFY (NAME VARCHAR2(50) NOT NULL UNIQUE);
```

**Question 1.4**

Ajouter la contrainte de la clé étrangère
```
ALTER TABLE PROVINCE
ADD CONSTRAINT FK_CAPITAL_PROVINCE
FOREIGN KEY (CAPITAL, COUNTRY, CAPPROV)
REFERENCES CITY(NAME, COUNTRY, PROVINCE);
```

**Question 1.5**

Ajouter la contrainte de la clé étrangère
```
ALTER TABLE PROVINCE
ADD CONSTRAINT FK_COUNTRY_PROVINCE
FOREIGN KEY (COUNTRY)
REFERENCES COUNTRY(CODE);
```

**Question 1.6**

Ajouter la contrainte de la clé étrangère
```
ALTER TABLE CITY
ADD CONSTRAINT FK_COUNTRY_CITY
FOREIGN KEY (COUNTRY)
REFERENCES COUNTRY(CODE);
```

**Question 1.7**

```
ALTER TABLE CITY
ADD CONSTRAINT FK_PROVINCE_CITY
FOREIGN KEY(PROVINCE, COUNTRY)
REFERENCES PROVINCE(NAME, COUNTRY);
```

**Question 1.8**

```
ALTER TABLE BORDERS
ADD CONSTRAINT CK_BORDERS_LENGTH_POSITIVE
CHECK(LENGTH > 0);
```

**Question 1.9**

```
ALTER TABLE CITY
ADD CONSTRAINT U_CITY_LAT_LON_DIFF
UNIQUE(LATITUDE, LONGITUDE);
```

# Problème 2

**Question 2.1**

```
INSERT INTO COUNTRY (NAME, CODE, CAPITAL, PROVINCE, AREA, POPULATION)
VALUES ('Basrit', 'BC', 'Demoi', 'Bascrit', 1250, 1250000);
```

-> Erreur

<details>

<summary>Solution 1 (pour l'utilisateur):</summary>
1# Créer le pays sans capital et sans province

```
INSERT INTO COUNTRY (NAME, CODE, AREA, POPULATION)
VALUES ('Bascrit', 'BC', 1250, 1250000);
```

2# Créer la province

```
INSERT INTO PROVINCE (AREA, CAPPROV, COUNTRY, NAME, POPULATION)
VALUES (1250, 'Bascrit', 'BC', 'Bascrit', 1250000);
```

3# Créer la ville avec la province

```
INSERT INTO CITY (COUNTRY, NAME, PROVINCE)
VALUES ('BC', 'Demoi', 'Bascrit');
```

4# Mettre à jour le pays et la province

```
UPDATE PROVINCE
SET CAPITAL = 'Demoi'
WHERE NAME = 'Bascrit' AND COUNTRY = 'BC';
```

```
UPDATE COUNTRY
SET CAPITAL = 'Demoi', PROVINCE = 'Bascrit'
WHERE CODE = 'BC';
```
</details>

<details>

<summary>Solution 2 (pour l'administrateur):</summary>

Supprimer les contraintes de clé étrangère sur Country
Ou sur City et Province

Puis éventuellement les remettre

</details>

<details>

<summary>Solution 3 (pour l'administrateur):</summary>

Mettre 'DEFERRABLE INITIALLY IMMEDIATE' sur la contrainte

Utiliser 'ALTER SESSION SET CONSTRAINTS = DEFERRED;' avant l'insertion

Puis 'ALTER SESSION SET CONSTRAINTS = IMMEDIATE;' après l'insertion

</details>

**Question 2.2**

```
SELECT *
FROM COUNTRY
ORDER BY NAME;
```

**Question 2.3**

```
SELECT ORGANIZATION, NAME, COUNT(ISMEMBER.COUNTRY) AS "NB MEMBRES MAX"
FROM ISMEMBER, ORGANIZATION
WHERE ISMEMBER.ORGANIZATION = ORGANIZATION.ABBREVIATION
    AND TYPE = 'member' 
GROUP BY NAME, ISMEMBER.ORGANIZATION
HAVING COUNT(ISMEMBER.COUNTRY) = (
    SELECT MAX(COUNT(COUNTRY))
    FROM ISMEMBER
    WHERE TYPE = 'member' 
    GROUP BY ISMEMBER.ORGANIZATION
);
```

**Question 2.4**

```
SELECT NAME
FROM COUNTRY C
WHERE POPULATION IS NOT NULL
ORDER BY (
    SELECT SUM(CITY.POPULATION)
    FROM CITY
    WHERE COUNTRY = C.NAME
    GROUP BY COUNTRY
) / POPULATION * 100;
```

```
SELECT COUNTRY.NAME, sum(CITY.POPULATION) / COUNTRY.POPULATION * 100 AS "pourcentage"
FROM COUNTRY, CITY, PROVINCE
WHERE CITY.COUNTRY = COUNTRY.CODE
    AND CITY.PROVINCE = PROVINCE.CAPPROV
    AND COUNTRY.PROVINCE = PROVINCE.NAME
GROUP BY COUNTRY.NAME, COUNTRY.POPULATION
ORDER BY sum(CITY.POPULATION) / COUNTRY.POPULATION * 100;
```

**Question 2.5**

```
SELECT CONTINENT.NAME, SUM(COUNTRY.POPULATION * (PERCENTAGE / 100))
FROM CONTINENT, ENCOMPASSES, COUNTRY
WHERE CONTINENT.NAME = ENCOMPASSES.CONTINENT
    AND COUNTRY.CODE = ENCOMPASSES.COUNTRY
GROUP BY CONTINENT.NAME
ORDER BY SUM(COUNTRY.POPULATION * (PERCENTAGE / 100));
```

**Question 2.6**

Version 1
```
SELECT NAME, sum(LENGTH)
FROM BORDERS, COUNTRY
WHERE COUNTRY.CODE = BORDERS.COUNTRY1 
    OR COUNTRY.CODE = BORDERS.COUNTRY2
GROUP BY NAME
HAVING sum(LENGTH) = (
          SELECT max(sum(LENGTH)) AS "somme"
          FROM BORDERS, COUNTRY
          WHERE COUNTRY.CODE = BORDERS.COUNTRY1 
            OR COUNTRY.CODE = BORDERS.COUNTRY2
          GROUP BY NAME
);
```

Version 2
```
WITH frontieres
AS (
    SELECT NAME, sum(LENGTH) AS somme
    FROM BORDERS, COUNTRY
    WHERE COUNTRY.CODE = BORDERS.COUNTRY1 
        OR COUNTRY.CODE = BORDERS.COUNTRY2
    GROUP BY NAME
)

SELECT NAME, somme
FROM frontieres
WHERE somme = (
          SELECT max(somme) 
          FROM frontieres
);
```

**Question 2.7**

```
SELECT CITY.NAME, count(DISTINCT CITY.COUNTRY) AS "Nombre de pays"
FROM CITY
GROUP BY CITY.NAME
HAVING count(DISTINCT CITY.COUNTRY) > 1
ORDER BY count(DISTINCT CITY.COUNTRY) DESC, CITY.NAME;
```

**Question 2.8**

```
SELECT P.COUNTRY, C.NAME
FROM POLITICS P JOIN COUNTRY C ON P.COUNTRY = C.CODE 
WHERE INDEPENDENCE = NULL;
```

**Question 2.9**

```
CREATE OR REPLACE VIEW codes 
AS (
          SELECT Code
          FROM COUNTRY

          MINUS 

          SELECT Country
          FROM ISMEMBER
);


SELECT R.Code, C.Name
FROM codes R 
    JOIN COUNTRY C 
    ON R.Code = C.Code;
```

**Question 2.10**

```
SELECT Code, Name, Organization
FROM COUNTRY LEFT JOIN ISMEMBER ON Code = Country;
```

**Question 2.11**

```
SELECT E.Continent, sum(LENGTH) AS "somme en KM"
FROM ENCOMPASSES E, COUNTRY, BORDERS
WHERE COUNTRY.CODE = E.COUNTRY
    
    AND (
          COUNTRY.CODE = BORDERS.COUNTRY1 
            OR COUNTRY.CODE = BORDERS.COUNTRY2
    )

    AND COUNTRY1 IN (
            SELECT Country 
            FROM ENCOMPASSES E1
            WHERE E1.Continent = E.Continent
    )
    AND COUNTRY2 IN (
            SELECT Country 
            FROM ENCOMPASSES E2
            WHERE E2.Continent = E.Continent
    )

GROUP BY E.Continent;
```

**Question 2.17**

1. 

```
SELECT Country FROM POPULATION;
```

Clé primaire : Country
Type d'index : Full Scan

2. 

```
SELECT * FROM POPULATION
WHERE Country = 'F';
```

Oui, Unique Scan sur Country

3.

```
SELECT * FROM POPULATION
WHERE Country < 'F';
```

Oui, Range Scan

4.

```
SELECT * FROM POPULATION
WHERE population_growth = 0;
```

Non, pas d'index

5.

Oui, Range Scan sur population_growth

6. 

Bitmap Index (single value)

7. 

```
SELECT * FROM POPULATION
WHERE population_growth < 0;
```

Non, car le bitmap ne supporte pas les comparaisons autres qu’une égalité.

**Question 2.18**

```
CREATE OR REPLACE FUNCTION F_NB_PAYS_FRONTALIER (
    CODE_PAYS IN country.code%type
)
RETURN NUMBER
IS
    nb NUMBER;
BEGIN
    SELECT count(*) INTO nb
    FROM BORDERS
    WHERE COUNTRY1 = CODE_PAYS 
        OR COUNTRY2 = CODE_PAYS
    GROUP BY CODE_PAYS;

    RETURN nb;
END;
/

CREATE OR REPLACE PROCEDURE P_TEST
AS
    nb number;
BEGIN
    nb := F_NB_PAYS_FRONTALIER('F');
    DBMS_OUTPUT.PUT_LINE('Nombre total de pays frontaliers: ' || nb);
END;
/

SELECT F_NB_PAYS_FRONTALIER('F') FROM DUAL;
EXECUTE P_TEST();
```

**Question 2.27**

```
SELECT TABLE_NAME FROM user_tables;
```

```
SELECT 'grant select, insert, update, delete on ' || TABLE_NAME || ' to acognot;' 
FROM user_tables;
```

```
SET ECHO OFF;
SET FEEDBACK OFF;
SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET PAGES 0;
SET HEAD OFF;

-- redirection de la sortie standard

SPOOL C:\Users\fkilic\Downloads\scriptGenereAuto.sql;

SELECT 'grant select, insert, update, delete on ' || TABLE_NAME || ' to acognot;' 
FROM user_tables;

SPOOL OFF;
-- arrêt de la redirection

@//C:\Users\fkilic\Downloads\scriptGenereAuto.sql;
```