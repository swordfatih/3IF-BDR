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
ADD CONSTRAINT CK_CITY_LAT_LON_DIFF
CHECK(LATITUDE <> LONGITUDE);
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