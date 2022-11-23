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
ALTER TABLE BORDERS
ADD CONSTRAINT CK_BORDERS_LENGTH_POSITIVE
CHECK(LENGTH > 0);
```

**Question 1.8**

```
ALTER TABLE CITY
ADD CONSTRAINT CK_CITY_LAT_LON_DIFF
CHECK(LATITUDE <> LONGITUDE);
```

# Problème 2