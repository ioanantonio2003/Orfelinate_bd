CREATE TABLE SECTOARE (
    nr_sector NUMBER(2) CONSTRAINT sectoare_pk PRIMARY KEY,
    cod_postal VARCHAR2(10) NOT NULL
);

CREATE TABLE ORFELINATE (
    cod_orfelinat NUMBER(3) CONSTRAINT orfelinate_pk PRIMARY KEY,
    nume_orfelinat VARCHAR2(20) NOT NULL,
    adresa_orfelinat VARCHAR2(50) NOT NULL,
    nr_sector NUMBER(2) NOT NULL,
    CONSTRAINT orfelinate_fk_sectoare FOREIGN KEY (nr_sector) REFERENCES SECTOARE(nr_sector)
);


CREATE TABLE DONATORI (
    nume_firma VARCHAR2(20) CONSTRAINT donatori_pk PRIMARY KEY,
    nume_proprietar VARCHAR2(20) NOT NULL,
    prenume_proprietar VARCHAR2(20) NOT NULL,
    telefon VARCHAR2(10),
    buget_anual NUMBER(7) NOT NULL
);


CREATE TABLE DONEAZA (
    nume_firma VARCHAR2(20),
    cod_orfelinat NUMBER(3),
    data_donatie DATE NOT NULL,
    suma NUMBER(7) NOT NULL,
    CONSTRAINT doneaza_fk_donatori FOREIGN KEY (nume_firma) REFERENCES DONATORI(nume_firma),
    CONSTRAINT doneaza_fk_orfelinate FOREIGN KEY (cod_orfelinat) REFERENCES ORFELINATE(cod_orfelinat),
    CONSTRAINT sponsorizeaza_pk PRIMARY KEY (nume_firma, cod_orfelinat,data_donatie)
);

CREATE TABLE ANGAJATI (
    cnp_angajat VARCHAR2(14) CONSTRAINT angajati_pk PRIMARY KEY,
    nume_angajat VARCHAR2(20) NOT NULL,
    prenume_angajat VARCHAR2(20) NOT NULL,
    salariu NUMBER(7) NOT NULL,
    varsta NUMBER(3) NOT NULL, 
    cod_orfelinat NUMBER(3) NOT NULL, 
    CONSTRAINT angajati_fk_orfelinate FOREIGN KEY (cod_orfelinat) REFERENCES ORFELINATE(cod_orfelinat)
);


CREATE TABLE ORFANI (
    cnp_orfan VARCHAR2(14) CONSTRAINT orfani_pk PRIMARY KEY,
    nume_orfan VARCHAR2(20) NOT NULL,
    prenume_orfan VARCHAR2(20) NOT NULL,
    sex NUMBER(7) NOT NULL,
    varsta NUMBER(3) NOT NULL, 
    cod_orfelinat NUMBER(3) NOT NULL, 
    CONSTRAINT orfani_fk_orfelinate FOREIGN KEY (cod_orfelinat) REFERENCES ORFELINATE(cod_orfelinat)
);

ALTER TABLE ORFANI MODIFY sex VARCHAR2(10);

CREATE TABLE ORGANIZATORI (
    nume_organizator VARCHAR2(20) CONSTRAINT organizatori_pk PRIMARY KEY,
    data_infinate NUMBER(5) NOT NULL,
    telefon VARCHAR2(10)
);

ALTER TABLE ORGANIZATORI RENAME COLUMN data_infinate TO data_infiintare;


CREATE TABLE PARTICIPA_LA_EVENIMENTE (
    cnp_orfan VARCHAR2(14),
    nume_organizator VARCHAR2(20),
    data_eveniment DATE,
    tip_eveniment VARCHAR2(20) NOT NULL,
    CONSTRAINT pla_fk_orfani FOREIGN KEY (cnp_orfan) REFERENCES ORFANI(cnp_orfan),
    CONSTRAINT pla_fk_organizatori FOREIGN KEY (nume_organizator) REFERENCES ORGANIZATORI(nume_organizator),
    CONSTRAINT pla_pk PRIMARY KEY (cnp_orfan, nume_organizator,data_eveniment)
);


INSERT INTO SECTOARE (nr_sector, cod_postal)
VALUES (1, '100000');

INSERT INTO SECTOARE (nr_sector, cod_postal)
VALUES (2, '200000');

INSERT INTO SECTOARE (nr_sector, cod_postal)
VALUES (3, '300000');

INSERT INTO SECTOARE (nr_sector, cod_postal)
VALUES (4, '400000');

INSERT INTO SECTOARE (nr_sector, cod_postal)
VALUES (5, '500000');

INSERT INTO SECTOARE (nr_sector, cod_postal)
VALUES (6, '600000');

select * from sectoare;




INSERT INTO ORFELINATE (cod_orfelinat, nume_orfelinat, adresa_orfelinat, nr_sector)
VALUES (111, 'Happy Place', 'Strada Doamna Ghica 6', 2);

INSERT INTO ORFELINATE (cod_orfelinat, nume_orfelinat, adresa_orfelinat, nr_sector)
VALUES (222, 'Kids Up', 'Cetatea de balta 112', 6);

INSERT INTO ORFELINATE (cod_orfelinat, nume_orfelinat, adresa_orfelinat, nr_sector)
VALUES (333, 'Orfeliantul Copiilor', 'Strada Vasile Dica 112', 6);

INSERT INTO ORFELINATE (cod_orfelinat, nume_orfelinat, adresa_orfelinat, nr_sector)
VALUES (444, 'Nevoiasii Fericiti', 'Aleea Florilor 21', 1);

INSERT INTO ORFELINATE (cod_orfelinat, nume_orfelinat, adresa_orfelinat, nr_sector)
VALUES (555, 'Inima Mare', 'Soseaua Colentina 2', 2);

select *from orfelinate;



INSERT INTO DONATORI (nume_firma, nume_proprietar, prenume_proprietar, telefon, buget_anual)
VALUES ('Shaorma Antonio', 'Ioan', 'Antonio', '0770448901', 15000);

INSERT INTO DONATORI (nume_firma, nume_proprietar, prenume_proprietar, telefon, buget_anual)
VALUES ('Pizza Max', 'Ioan', 'Maxim', '0770448904', 14000);

INSERT INTO DONATORI (nume_firma, nume_proprietar, prenume_proprietar, telefon, buget_anual)
VALUES ('MiauFit', 'Viorica', 'Antocel', '0778986678', 10000);

INSERT INTO DONATORI (nume_firma, nume_proprietar, prenume_proprietar, telefon, buget_anual)
VALUES ('Leguminos', 'Filip', 'Filipov', '0798899876', 90000);

INSERT INTO DONATORI (nume_firma, nume_proprietar, prenume_proprietar, telefon, buget_anual)
VALUES ('Fantastic', 'Eugenia', 'Draghici', '0770448902', 6000);

select * from donatori;




INSERT INTO DONEAZA (cod_orfelinat, nume_firma,data_donatie, suma)
VALUES (111, 'Shaorma Antonio' ,to_date('25-10-2024', 'DD-MM-YYYY'),  1000);

INSERT INTO DONEAZA (cod_orfelinat, nume_firma,data_donatie, suma)
VALUES (111, 'MiauFit' ,to_date('26-10-2024', 'DD-MM-YYYY'),  2000);

INSERT INTO DONEAZA (cod_orfelinat, nume_firma,data_donatie, suma)
VALUES (111, 'Pizza Max' ,to_date('27-10-2024', 'DD-MM-YYYY'),  1000);

INSERT INTO DONEAZA (cod_orfelinat, nume_firma,data_donatie, suma)
VALUES (222, 'Shaorma Antonio' ,to_date('28-10-2024', 'DD-MM-YYYY'),  2000);

INSERT INTO DONEAZA (cod_orfelinat, nume_firma,data_donatie, suma)
VALUES (222, 'Pizza Max' ,to_date('29-10-2024', 'DD-MM-YYYY'),  4000);

INSERT INTO DONEAZA (cod_orfelinat, nume_firma,data_donatie, suma)
VALUES (222, 'Leguminos' ,to_date('30-10-2024', 'DD-MM-YYYY'),  9000);

INSERT INTO DONEAZA (cod_orfelinat, nume_firma,data_donatie, suma)
VALUES (333, 'Leguminos' ,to_date('31-10-2024', 'DD-MM-YYYY'),  10000);

INSERT INTO DONEAZA (cod_orfelinat, nume_firma,data_donatie, suma)
VALUES (333, 'Fantastic' ,to_date('11-11-2024', 'DD-MM-YYYY'),  900);

INSERT INTO DONEAZA (cod_orfelinat, nume_firma,data_donatie, suma)
VALUES (444, 'Fantastic' ,to_date('12-11-2024', 'DD-MM-YYYY'),  900);

INSERT INTO DONEAZA (cod_orfelinat, nume_firma,data_donatie, suma)
VALUES (555, 'Shaorma Antonio' ,to_date('13-11-2024', 'DD-MM-YYYY'),  5000);

select * from doneaza;




INSERT INTO ANGAJATI (cnp_angajat, nume_angajat, prenume_angajat, salariu, varsta,cod_orfelinat)
VALUES ('1930225123456', 'Andronache','Claudiu', 4500, 25,111);

INSERT INTO ANGAJATI (cnp_angajat, nume_angajat, prenume_angajat, salariu, varsta,cod_orfelinat)
VALUES ('1930564123456', 'Gica','Marian', 6500, 35,111);

INSERT INTO ANGAJATI (cnp_angajat, nume_angajat, prenume_angajat, salariu, varsta,cod_orfelinat)
VALUES ('1859425123456', 'Mironica','Anto', 5000, 20,111);

INSERT INTO ANGAJATI (cnp_angajat, nume_angajat, prenume_angajat, salariu, varsta,cod_orfelinat)
VALUES ('2232225123111', 'Dobre','Miruna', 2000, 40,222);

INSERT INTO ANGAJATI (cnp_angajat, nume_angajat, prenume_angajat, salariu, varsta,cod_orfelinat)
VALUES ('12202251234232', 'Catalescu','Catalin', 2500, 50,222);

INSERT INTO ANGAJATI (cnp_angajat, nume_angajat, prenume_angajat, salariu, varsta,cod_orfelinat)
VALUES ('29898225123456', 'Nastase','Nana', 10000, 31,333);

INSERT INTO ANGAJATI (cnp_angajat, nume_angajat, prenume_angajat, salariu, varsta,cod_orfelinat)
VALUES ('1232328382818', 'Dragu','Marinica', 9000, 78,333);

INSERT INTO ANGAJATI (cnp_angajat, nume_angajat, prenume_angajat, salariu, varsta,cod_orfelinat)
VALUES ('1334225123455', 'Suciu','Dragos', 4750, 29,444);

select * from angajati;




INSERT INTO ORFANI (cnp_orfan, nume_orfan, prenume_orfan, sex, varsta,cod_orfelinat)
VALUES ('1334225835385', 'Dinica','Eduard', 'M', 11,111);

INSERT INTO ORFANI (cnp_orfan, nume_orfan, prenume_orfan, sex, varsta,cod_orfelinat)
VALUES ('1998925123455', 'Birdau','Axel', 'M', 12,111);

INSERT INTO ORFANI (cnp_orfan, nume_orfan, prenume_orfan, sex, varsta,cod_orfelinat)
VALUES ('2224225123455', 'Dinica','Maria', 'F', 15,111);

INSERT INTO ORFANI (cnp_orfan, nume_orfan, prenume_orfan, sex, varsta,cod_orfelinat)
VALUES ('1234567891919', 'Scintei','Cristian', 'M', 17,222);

INSERT INTO ORFANI (cnp_orfan, nume_orfan, prenume_orfan, sex, varsta,cod_orfelinat)
VALUES ('2848293949203', 'Ruxandra','Petrescu', 'F', 17,222);

INSERT INTO ORFANI (cnp_orfan, nume_orfan, prenume_orfan, sex, varsta,cod_orfelinat)
VALUES ('1929392049375', 'Mihnea','Velcea', 'M', 11,222);

INSERT INTO ORFANI (cnp_orfan, nume_orfan, prenume_orfan, sex, varsta,cod_orfelinat)
VALUES ('2394930320002', 'Irina','Diaconu', 'F', 8,333);

INSERT INTO ORFANI (cnp_orfan, nume_orfan, prenume_orfan, sex, varsta,cod_orfelinat)
VALUES ('2039392020090', 'Florentin','Mirela', 'F', 12,333);

INSERT INTO ORFANI (cnp_orfan, nume_orfan, prenume_orfan, sex, varsta,cod_orfelinat)
VALUES ('1929292929009', 'Suc','Dadi', 'M', 5,333);

INSERT INTO ORFANI (cnp_orfan, nume_orfan, prenume_orfan, sex, varsta,cod_orfelinat)
VALUES ('1999999999922', 'Trastor','Laurentiu', 'M', 4,444);

select *from orfani; 




INSERT INTO ORGANIZATORI (nume_organizator,data_infiintare,telefon)
VALUES('Asociatia Copiilor',2015 ,'0789223455');

INSERT INTO ORGANIZATORI (nume_organizator,data_infiintare,telefon)
VALUES('Multumesc Romania',2020 ,'0798876543');

INSERT INTO ORGANIZATORI (nume_organizator,data_infiintare,telefon)
VALUES('Virgil Frizerul',2024 ,'0712221112');

INSERT INTO ORGANIZATORI (nume_organizator,data_infiintare,telefon)
VALUES('Hai Nevoiasii',2001 ,'0756776592');

INSERT INTO ORGANIZATORI (nume_organizator,data_infiintare,telefon)
VALUES('Kids Grow',2009 ,'0711122211');

select * from organizatori;





INSERT INTO PARTICIPA_LA_EVENIMENTE (cnp_orfan, nume_organizator, data_eveniment, tip_eveniment)
VALUES ('1334225835385', 'Asociatia Copiilor', to_date('23-12-2024', 'DD-MM-YYYY') , 'jocuri');

INSERT INTO PARTICIPA_LA_EVENIMENTE (cnp_orfan, nume_organizator, data_eveniment, tip_eveniment)
VALUES ('1999999999922', 'Asociatia Copiilor', to_date('23-12-2024', 'DD-MM-YYYY') , 'jocuri');

INSERT INTO PARTICIPA_LA_EVENIMENTE (cnp_orfan, nume_organizator, data_eveniment, tip_eveniment)
VALUES ('2848293949203', 'Multumesc Romania', to_date('26-12-2024', 'DD-MM-YYYY') , 'masa');

INSERT INTO PARTICIPA_LA_EVENIMENTE (cnp_orfan, nume_organizator, data_eveniment, tip_eveniment)
VALUES ('1234567891919', 'Multumesc Romania', to_date('26-12-2024', 'DD-MM-YYYY') , 'masa');

INSERT INTO PARTICIPA_LA_EVENIMENTE (cnp_orfan, nume_organizator, data_eveniment, tip_eveniment)
VALUES ('1998925123455', 'Virgil Frizerul', to_date('27-12-2024', 'DD-MM-YYYY') , 'masa');

INSERT INTO PARTICIPA_LA_EVENIMENTE (cnp_orfan, nume_organizator, data_eveniment, tip_eveniment)
VALUES ('1334225835385', 'Virgil Frizerul', to_date('27-12-2024', 'DD-MM-YYYY') , 'masa');

INSERT INTO PARTICIPA_LA_EVENIMENTE (cnp_orfan, nume_organizator, data_eveniment, tip_eveniment)
VALUES ('2039392020090', 'Virgil Frizerul', to_date('27-12-2024', 'DD-MM-YYYY') , 'masa');

INSERT INTO PARTICIPA_LA_EVENIMENTE (cnp_orfan, nume_organizator, data_eveniment, tip_eveniment)
VALUES ('1999999999922', 'Hai Nevoiasii', to_date('10-12-2024', 'DD-MM-YYYY') , 'jocuri');

INSERT INTO PARTICIPA_LA_EVENIMENTE (cnp_orfan, nume_organizator, data_eveniment, tip_eveniment)
VALUES ('1999999999922', 'Asociatia Copiilor', to_date('11-12-2024', 'DD-MM-YYYY') , 'masa');

INSERT INTO PARTICIPA_LA_EVENIMENTE (cnp_orfan, nume_organizator, data_eveniment, tip_eveniment)
VALUES ('2224225123455', 'Kids Grow', to_date('12-12-2024', 'DD-MM-YYYY') , 'jocuri');

select * from participa_la_evenimente;
