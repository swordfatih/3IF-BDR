

**Question 1.1**

Trouver les enregistrements qui n'ont pas de capital
`SELECT * FROM COUNTRY WHERE CAPITAL IS NULL;`

Empêcher la capitale d'un pays d'avoir une valeur nulle
`ALTER TABLE COUNTRY MODIFY (CAPITAL VARCHAR2(50) NOT NULL);`

Ajouter la contrainte de la clé étrangère
`ALTER TABLE COUNTRY 
ADD CONSTRAINT FK_COUNTRY_CAPITAL_CITY 
FOREIGN KEY (CAPITAL, CODE, PROVINCE) 
REFERENCES CITY(NAME, COUNTRY, PROVINCE);`

**Question 1.2**

Ajouter la contrainte d'unicité
`ALTER TABLE COUNTRY ADD CONSTRAINT U_NOM_COUNTRY UNIQUE(NAME);`

**Question 1.3**

Empêcher le nom d'un pays d'avoir une valeur nulle
`ALTER TABLE COUNTRY MODIFY (NOM VARCHAR2(50) NOT NULL);`