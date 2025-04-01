--Verificare inserturi tabela Accesoriu
--1.Verificare autoincrement
INSERT INTO accesoriu (denumire, tarif, stoc)
VALUES ('Casca', 25, 10);--ID_acesoriu = 1000
INSERT INTO accesoriu (denumire, tarif, stoc)
VALUES ('Claxon', 75, 10);--ID_acesoriu = 1037
--2.Verificare denumire accesoriu care are o lista de valori predefinita
INSERT INTO accesoriu (denumire, tarif, stoc)
VALUES ('Oglinzi', 25, 10);--Eroare pentru ca nu e in lista
--3.Verificare tarif accesoriu care are o lista de valori predefinita
INSERT INTO accesoriu (denumire, tarif, stoc)
VALUES ('Genunghiere', 63, 10);--Eroare pentru ca nu e in lista
--4.Verificare stoc accesoriu care este >= 0
INSERT INTO accesoriu (denumire, tarif, stoc)
VALUES ('Lumini', 75, -3);--Eroare pentru ca este negativ

--Verificare insert uri tabela Client
--Insert simplu
INSERT INTO client (cnp,serie_ci, numar_ci, nume, prenume)
VALUES ('1960226818181','XT', 123456, 'Popescu', 'Ion');
INSERT INTO client (cnp,serie_ci, numar_ci, nume, prenume)
VALUES ('5030815226728','XT', 987222, 'Oancea', 'Cosmin-Marian');
--1.Verificare constangere NN
INSERT INTO client (serie_ci, numar_ci, nume, prenume)
VALUES ('XT', 123456, 'Popescu', 'Ion');  -- CNP este omis.
--2.Verificare constrangere UK
--a.UK este format dintr un singura coloana(CNP)
INSERT INTO client (cnp,serie_ci, numar_ci, nume, prenume)
VALUES ('1960226818181','ZT', 987621, 'Alibec', 'Denis'); -- Are acelasi cnp ca si insert ul anterior
--b.UK este format din doua atribute diferite(perechea serie_ci - numar_ci)
INSERT INTO client (cnp,serie_ci, numar_ci, nume, prenume)
VALUES ('2891103070065','XT', 123456, 'Alibec', 'Denis'); -- Are acelasi tuplu (serie_ci,numar-ci) ca primul insert
--3.Verificare constangere CNP
--a.Verificare prima cifra (1,2,5,6)
INSERT INTO client (cnp,serie_ci, numar_ci, nume, prenume)
VALUES ('4030815226728','XT', 987332, 'Oancea', 'Cosmin-Marian');--Are prima cifra din CNP 4
--b.Verificare luna in range (1,12)
INSERT INTO client (cnp,serie_ci, numar_ci, nume, prenume)
VALUES ('5031315226728','XT', 987332, 'Oancea', 'Cosmin-Marian');--Are luna 13 in CNP
--c.Verificare ziua in range (1,31)
INSERT INTO client (cnp,serie_ci, numar_ci, nume, prenume)
VALUES ('5031248226728','XT', 987332, 'Oancea', 'Cosmin-Marian');--Are ziua 48 in CNP
--d.Verificare ziua sa nu poata sa fie 31 in lunile aprilie, iunie, septembrie, noiembrie
INSERT INTO client (cnp,serie_ci, numar_ci, nume, prenume)
VALUES ('5030431226728','XT', 987332, 'Oancea', 'Cosmin-Marian');--Are ziua 31 in luna aprilie
--e.Verificare posibilitate insert 29 februarie doar in an bisec
INSERT INTO client (cnp,serie_ci, numar_ci, nume, prenume)
VALUES ('5040229226728','XT', 564003, 'Dumea', 'Emilian');--Insert reusit
INSERT INTO client (cnp,serie_ci, numar_ci, nume, prenume)
VALUES ('2920229005643','ZT', 987332, 'Timisag', 'Crina');--Insert reusit
INSERT INTO client (cnp,serie_ci, numar_ci, nume, prenume)
VALUES ('2910229005643','ZT', 111111, 'Topita', 'Andreea');--Insert esuat

--Verificare insert uri tabela Contact
--Insert simplu
INSERT INTO contact (oras, strada, email, telefon, cnp)
VALUES ('Bucuresti', 'Str. Unirii 10', 'test@test.com', '0712345678', '1960226818181');
--1.Verificare regex oras REGEXP_LIKE(oras, '^[A-Za-z0-9 -]+$')
INSERT INTO contact (oras, strada, email, telefon, cnp)
VALUES ('@#$%^&%$#', 'Str. Unirii 10', 'Test@test.com', '0712345674', '5030815226728');--Eroare s-au folosit carecatere speciale
--2.Verificare regex numar de telefon REGEXP_LIKE(telefon, '^07[0-9]{8}$')
INSERT INTO contact (oras, strada, email, telefon, cnp)
VALUES ('Bucuresti', 'Str. Unirii 10', 'Test@test.com', '0512345674', '5030815226728');--Eroare numarul de telefon nu incepe cu 07
--3.Verificare regex email REGEXP_LIKE(email, '[a-z0-9._%-]+@[a-z0-9._%-]+\.[a-z]{2,4}')
INSERT INTO contact (oras, strada, email, telefon, cnp)
VALUES ('Bucuresti', 'Str. Unirii 10', 'Test@test,com', '0712345674', '5030815226728');--Eroare emailul nu respecta 

--Verificare insert uri tabela Inchiriere
--1.Verificare trigger data inceput
INSERT INTO inchiriere (data_inceput, cnp, tip, model)
VALUES (TO_DATE('2024-12-07', 'YYYY-MM-DD'), '1960226818181', 'mountain ', 'barbati');--Data de la care se incearca pornirea inchirierii este in trecut
--2.Verificare constangere data sfarsit
INSERT INTO inchiriere (data_inceput,data_sfarsit, cnp, tip, model)
VALUES (TO_DATE('2024-12-10', 'YYYY-MM-DD'), TO_DATE('2024-12-09', 'YYYY-MM-DD'),'1960226818181', 'mountain', 'barbati');--Data de sfarsit este mai veche decat data inceput    