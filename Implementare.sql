--exercitiul 6
--Sa se afiseze pentru fiecare sector din oras numarul total de orfelinate
--respectiv numarul de orfeliante care au cel putin un angajat cu salariul mai mare ca jumatatea
--mediei salariilor tuturor angajatilor(din orice orfelinat)

create or replace procedure p6 is
    type sect is table of sectoare.nr_sector%type index by pls_integer; --primul tip de colectie
    type orfe is table of orfelinate.cod_orfelinat%type; --al doilea tip de colectie
    type ang is varray(12) of angajati%rowtype; --al treilea tip de colectie
    s sect ; 
    o orfe := orfe(); 
    a ang := ang();
    c number(2) := 0;
    nr number(2) := 0;
begin
    --aflam angajatii care care au salariul mai mare ca jumatate din media salariilor tuturor angajatilor din toate orfelinatele
    select an.*
    bulk collect into a
    from angajati an
    where  an.salariu > (select avg(salariu)/2
                         from angajati);
    --aflam toate sectoarele din oras
    for i in (select nr_sector from sectoare) loop
        c := c + 1;
        s(c) := i.nr_sector;
    end loop;
    --acum afisam pentru fiecare sector
    for i in 1..s.count loop
        o.delete; 
        nr := 0;
        --aici cautam toate codurile orfelinatelor care se afla in sectorul respectiv
        select cod_orfelinat
        bulk collect into o
        from orfelinate orf
        where orf.nr_sector = s(i);
        --acum aflam pentru fiecare orfelinat din sector(pt a vedea cate respecte conditia)
        for j in 1..o.count loop
            for l in 1..a.count loop
                if o(j) = a(l).cod_orfelinat then
                    nr := nr + 1;--am gasit 
                    exit;
                end if;
            end loop;
        end loop;
        DBMS_OUTPUT.PUT_LINE('Sectorul cu numarul '|| s(i));
        DBMS_OUTPUT.PUT_LINE('    -> '||o.count|| ' orfelinate');
        DBMS_OUTPUT.PUT_LINE('    ->' ||nr||' orfelinate care respecta conditia');
    end loop;  
end;
/       
begin
    p6;
end;


--Pentru fiecare orfelinat din sectorul 2 sau 6 care au au media angajatiilor mare de 2500 de lei
-- sa se afiseze detaliile lor(numele,codul,media salariilor angjatiilor) si pt fiecare din acestea
--sa se afiseze toti orfanii cu varsta de peste 10 ani care participat la cel putin un eveniment de tip masa
create or replace procedure p7 is
    --aici avem cursorul parametrizat care afla orfanii cu varsta mai mare de 10
    --ani care au participat la un eveniment de tip masa(la orfelinatul respectiv)
    cursor orf(cod orfelinate.cod_orfelinat%type) is
            select distinct orfan.nume_orfan, orfan.prenume_orfan, orfan.varsta
            from orfani orfan, participa_la_evenimente p
            where p.cnp_orfan = orfan.cnp_orfan 
            and p.tip_eveniment = 'masa'
            and orfan.varsta > 10
            and orfan.cod_orfelinat = cod;
            
    orfanul orf%rowtype;
    valid NUMBER(1) := 0;
begin
    --aici vom folosi un ciclu cursor cu subcereri nepramatreziat
    for i in(select o.nume_orfelinat, o.cod_orfelinat, avg(a.salariu) medie
             from orfelinate o, angajati a
             where o.cod_orfelinat = a.cod_orfelinat
             and o.nr_sector in(2,6)
             group by o.nume_orfelinat, o.cod_orfelinat
             having avg(a.salariu) > 2500) loop
            
        --pt fiecare oorfelinat din sectorul 2 sau 6 cu media salariilor  angajataillor mai amre de 2
        DBMS_OUTPUT.PUT_LINE('-> '||i.nume_orfelinat || ' cu codul : '|| i.cod_orfelinat||' are media salariilor angajatilor de : ' ||i.medie || ' lei');
        valid := 0;
        --deschidem cursorul explict parametrizat dependent de primul cursor
        open orf(i.cod_orfelinat);
            loop
                fetch orf into orfanul;
                exit when orf%notfound;
                --inseamna ca are cel putin unul deci e valid
                valid := 1;
                DBMS_OUTPUT.PUT_LINE('              * '||orfanul.nume_orfan ||' ' || orfanul.prenume_orfan || ' cu varsta de '||orfanul.varsta||' ani' );
            end loop;
            --in cazul in care nu are niciun orfan
            if valid = 0 then
                DBMS_OUTPUT.PUT_LINE('              *fara orfani' );
            end if;
        close orf;
    end loop;
end;
/
begin
    p7;
end;


--Pentru un nume de orfan dat sa se afle numarul de angajati care au varsta de
--peste 20 de ani si salariul mai mare de 4000 care lucreaza in orfelinatul
--unde locuieste orfanul cu numele dat 
create or replace function p8(nume in varchar2) return varchar2 is
    cnp orfani.cnp_orfan%type;
    orfa orfani.prenume_orfan%type;
    nr NUMBER(2);
begin  
    --verficam daca exista numele dat sau daca sunt mai multi orfani cu acelasi nume
    select cnp_orfan
    into cnp
    from orfani
    where nume_orfan = nume;
    --daca nu sunt 2 orfani cu acelasi nume si exista un orfan cu acest cnp aflam in
    --in continuare numarul de angajati care respecta conditia
    select orf.prenume_orfan,count(*)ang
    into orfa,nr
    from orfani orf, orfelinate o,angajati a
    where orf.cod_orfelinat = o.cod_orfelinat
    and o.cod_orfelinat = a.cod_orfelinat
    and orf.cnp_orfan = cnp
    and a.varsta > 20
    and a.salariu > 4000
    group by orf.cnp_orfan,orf.nume_orfan,orf.prenume_orfan,orf.sex,orf.varsta,orf.cod_orfelinat;
    --daca numarul de angajati care respecta conditia este mai mare ca 0 return mesajul urmator
    return 'Orfanul ' || nume || ' ' || orfa || ' se afla intr-un orfelinat care are '|| nr||' angajati care respecta conditia'; 
    --verificam daca s a produs o exceptie no_data_found, too_many_rows sau others
    exception
        when no_data_found then
            return 'nu exista un orfan cu acest cnp/nu exista angajati care respecta conditia';
        when too_many_rows then
            return 'exista mai multi orfani cu acest nume';
        when others then
            return 's-a produs o alta eroare';
end;
/

begin
    DBMS_OUTPUT.PUT_LINE('-> '||p8('Ioan'));
    DBMS_OUTPUT.PUT_LINE('-> '||p8('Dinica'));
    DBMS_OUTPUT.PUT_LINE('-> '||p8('Birdau'));
    DBMS_OUTPUT.PUT_LINE('-> '||p8('Scintei'));
end;
    

--Pentru un nume de proprietar dat ca parametru, un buget si un numar minim de orfani
--sa se afle detaliile despre firma proprietarului care trebuie sa aibe bugetul anual mai mare ca cel dat
--ca parametru si numarul orfanilor care fac parte dintr-un orfelinat care a avut donatii de la firma respectiv
--(orfanii trebuie sa fii avut cel putin un eveniment si sa aibe varsta mai mare ca media varstelor orfanilor de sex masculin)
create or replace procedure p9(nume donatori.nume_firma%type, buget donatori.buget_anual%type, nr2 NUMBER) is
    firma donatori.nume_firma%type;
    prenume donatori.prenume_proprietar%type;
    tel donatori.telefon%type;
    nr number(2);
    buge donatori.buget_anual%type;
    buge2 donatori.buget_anual%type;
    buget_incorect exception;--prima exceptie proprie
    buget_mic exception;--a 2 exceptie proprie
    nr_minim exception;--a 3 exceptie proprie
begin
    --verificam daca bugetul este valid(prima exceptie proprie
    if buget < 0 or buget > 9999999 then
        raise buget_incorect;
    end if;
    --aici verificam daca nume de proprietar este existent si nu exista 2 proprietari cu aceasi nume
    select nume_firma,buget_anual
    into firma,buge2
    from donatori
    where nume_proprietar = nume;
    --aici verificam daca bugetul e mai mare ca cel dat
    if buge2 < buget then
        raise buget_mic;
    end if;
    --acum daca bugetul este in regula pt toate cazurile vrem sa vedem cati orfani respecta conditia necesara
    select d.prenume_proprietar, d.telefon,d.buget_anual,count(distinct p.cnp_orfan)
    into prenume,tel,buge,nr
    from donatori d, doneaza don, orfelinate o, orfani orf, participa_la_evenimente p
    where d.nume_firma = don.nume_firma
    and don.cod_orfelinat = o.cod_orfelinat
    and o.cod_orfelinat = orf.cod_orfelinat
    and p.cnp_orfan = orf.cnp_orfan
    and d.nume_firma = firma
    and d.buget_anual>0
    and orf.varsta > (select avg(varsta)
                  from orfani 
                  where sex = 'F')
    group by d.prenume_proprietar, d.telefon,d.buget_anual, d.nume_firma;
    --verificam daca numarul de orfani este mai mare ca cel dat ca parametru
    if nr < nr2 then
        raise nr_minim;
    end if;
    --dupa toate testele trecute afisam detaliile
    DBMS_OUTPUT.PUT_LINE('Firma '||firma||' cu proprietarul '||nume||' '||prenume||' a donat catre orfelinate care in total au numarul de orfani care respecta cerinta =  '||nr);
    --verificam exceptiile predefinite din sistem si cele proprii de mine
    exception
        when buget_incorect then
            DBMS_OUTPUT.PUT_LINE('bugetul este mai mic ca 0 sau mai mare ca 9999999');
        when buget_mic then
            DBMS_OUTPUT.PUT_LINE('bugetul firmei este mai mic decat cel dat ca parametru');
        when nr_minim then
            DBMS_OUTPUT.PUT_LINE('Firma a fost gasita dar nu respecta numarul minim de orfani dat ca parametru');
        when no_data_found then
            DBMS_OUTPUT.PUT_LINE('nu exista un proprietar cu acest nume/firma proprietarului nu are niciun orfan care indeplineste cerinta');  
        when too_many_rows then
            DBMS_OUTPUT.PUT_LINE('exista mai multi proprietari cu acest nume');
        when others then
            DBMS_OUTPUT.PUT_LINE('s-a produs o alta eroare');
end;
/

begin
    DBMS_OUTPUT.PUT_LINE('--------------------');
    p9('Giani',2,0);
    DBMS_OUTPUT.PUT_LINE('--------------------');
    p9('Ioan',3,0);
    DBMS_OUTPUT.PUT_LINE('--------------------');
    p9('Filip',-1,0);
    DBMS_OUTPUT.PUT_LINE('--------------------');
    p9('Filip',999999999,0);
    DBMS_OUTPUT.PUT_LINE('--------------------');
    p9('Eugenia',100000,0);
    DBMS_OUTPUT.PUT_LINE('--------------------');
    p9('Filip',2000,5);
    DBMS_OUTPUT.PUT_LINE('--------------------');
    p9('Filip',2000,1);
end;

--Sa se creeze un trigger care sa nu permita folosirea tabelului orfani(insert,update,delete)
--in ultima zi a anului, de ziua Romaniei si in zilele de marti si duminica
create or replace trigger zile_libere
before insert or update or delete on orfani
    begin
        --verificam ca ziua sa nu fie 31 decembrie
        if to_char(sysdate, 'MM-DD') = '12-31' then
            raise_application_error(-20001, 'Nu se poate utiliza tabelul orfani de ziua de revelion');
        --verificam ca ziua sa nu fie 1 decembrie   
        ELSIF TO_CHAR(SYSDATE, 'MM-DD') = '12-01' then
             raise_application_error(-20002, 'Nu se poate utiliza tabelul orfani de ziua Romaniei');
        --verificam ca ziua sa nu fie marti sau duminica   
        elsif trim(to_char(sysdate, 'day')) IN ('tuesday', 'sunday') then
             raise_application_error(-20003, 'Nu se poate utiliza tabelul orfani in ziua de marti sau duminica');
        end if;
end;

INSERT INTO ORFANI (cnp_orfan, nume_orfan, prenume_orfan, sex, varsta,cod_orfelinat)
VALUES ('1334225835385', 'Dinaca','Marian', 'M', 11,111);


--Sa se creeze un trigger care sa nu permita inserarea in tabelul angajati
--a unui angajat cu varsta mai mica de 18 ani sau cu salariul mai mic decat o treime din media angajatilor sub 25 de ani
--din toate orfelinatele
create or replace trigger varsta_salariu_minim
before insert on angajati
for each row
    declare
        medie number(5);
    begin
        select avg(salariu)/3
        into medie
        from angajati
        where varsta <25;
        
        --verificam ca noul angajat sa nu aiba varsta mai mica de 18 ani
        if :NEW.varsta <= 17 then
            raise_application_error(-20004, 'Un angajat intr-un orfelinat nu are voie sa aiba varsta mai mica de 18 ani');
        end if;
        --verificam ca salariul noului angajat sa nu fie mai mic de 1000 de lei
        if :NEW.salariu <= medie then
            raise_application_error(-20005, 'Un angajat intr-un orfelinat nu are voie sa aiba salariul mai mic de o treime din media angajatiilor din toate orfelinatele');
        end if;
end;

INSERT INTO ANGAJATI (cnp_angajat, nume_angajat, prenume_angajat, salariu, varsta,cod_orfelinat)
VALUES ('1930225123496', 'Test1','Test1', 4500, 17,111);

INSERT INTO ANGAJATI (cnp_angajat, nume_angajat, prenume_angajat, salariu, varsta,cod_orfelinat)
VALUES ('1930295123456', 'Test2','Test2', 900, 25,111);


--Sa se creeze un trigger care sa observe operatiile de tip LDD
create table orfelinate_audit(
    numele_utilizatorului varchar2(50), 
    numele_bazei_de_date varchar2(50), 
    evenimentul varchar2(50), 
    numele_obiectului varchar2(50), 
    ziua DATE);
    
create or replace trigger orfelinate_trigger
after create or drop or alter on schema
begin 
   insert into orfelinate_audit  VALUES (SYS.LOGIN_USER, SYS.DATABASE_NAME, SYS.SYSEVENT, 
   SYS.DICTIONARY_OBJ_NAME, SYSDATE); 
end;
/

create table orfelinate_copie(
    cod_orfelinat NUMBER(3) CONSTRAINT orfelinate3_pk PRIMARY KEY,
    nume_orfelinat VARCHAR2(20) NOT NULL,
    adresa_orfelinat VARCHAR2(50) NOT NULL
);

create table orfelinate_copie2(
    cod_orfelinat NUMBER(3) CONSTRAINT orfelinate3_pk PRIMARY KEY,
    nume_orfelinat VARCHAR2(20) NOT NULL,
    adresa_orfelinat VARCHAR2(50) NOT NULL
);

drop table orfelinate_copie2;

select * from orfelinate_audit;


