--delete from contact;
--delete from inchiriere;
--delete from articole;
--Delete from client;
ACCEPT v_cnp PROMPT 'Introduceți CNP-ul: ';
ACCEPT v_serie_ci PROMPT 'Introduceți seria CI: ';
ACCEPT v_numar_ci PROMPT 'Introduceți numărul CI: ';
ACCEPT v_nume PROMPT 'Introduceți numele: ';
ACCEPT v_prenume PROMPT 'Introduceți prenumele: ';

INSERT INTO client (cnp, serie_ci, numar_ci, nume, prenume)
VALUES ('&v_cnp', '&v_serie_ci', &v_numar_ci, '&v_nume', '&v_prenume');

ACCEPT v_oras PROMPT 'Introduceți orașul: ';
ACCEPT v_strada PROMPT 'Introduceți strada: ';
ACCEPT v_email PROMPT 'Introduceți emailul: ';
ACCEPT v_telefon PROMPT 'Introduceți telefonul: ';

INSERT INTO contact (oras, strada, email, telefon, cnp)
VALUES ('&v_oras', '&v_strada', '&v_email', '&v_telefon', '&v_cnp');

ACCEPT v_tip PROMPT 'Introduceți tipul bicicletei: ';
ACCEPT v_model PROMPT 'Introduceți modelul bicicletei: ';
ACCEPT v_data_inceput PROMPT 'Introduceți data de început (YYYY-MM-DD): ';

INSERT INTO inchiriere (data_inceput, cnp, tip, model)
SELECT TO_DATE('&v_data_inceput', 'YYYY-MM-DD'), '&v_cnp', '&v_tip', '&v_model'
FROM bicicleta
WHERE tip = '&v_tip' 
  AND model = '&v_model' 
  AND stoc > 0;

UPDATE bicicleta
SET stoc = stoc - 1
WHERE tip = '&v_tip' AND model = '&v_model' AND stoc > 0;

ACCEPT v_nr_accesorii PROMPT 'Introduceți numărul de accesorii (0 dacă nu aveți accesorii): ';

DECLARE
    v_id_accesoriu NUMBER;
BEGIN
    IF &v_nr_accesorii > 0 THEN
        FOR i IN 1..&v_nr_accesorii LOOP
            ACCEPT v_id_accesoriu PROMPT 'Introduceți ID-ul accesoriului: ';
            INSERT INTO articole (cnp, data_inceput, tip, model, id_acesoriu)
            SELECT '&v_cnp', TO_DATE('&v_data_inceput', 'YYYY-MM-DD'), '&v_tip', '&v_model', &v_id_accesoriu
            FROM accesoriu
            WHERE id_acesoriu = &v_id_accesoriu AND stoc > 0;

            -- Reducere stoc accesorii
            UPDATE accesoriu
            SET stoc = stoc - 1
            WHERE id_acesoriu = &v_id_accesoriu AND stoc > 0;
        END LOOP;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Nu s-au adăugat accesorii.');
    END IF;
END;
/

-- Afișare toate tabelele înainte de inserarea datei de sfârșit
SELECT * FROM client;
SELECT * FROM contact;
SELECT * FROM bicicleta;
SELECT * FROM inchiriere;
SELECT * FROM accesoriu;
SELECT * FROM articole;

ACCEPT v_data_sfarsit PROMPT 'Introduceți data de sfârșit (YYYY-MM-DD): ';

UPDATE inchiriere
SET 
    data_sfarsit = TO_DATE('&v_data_sfarsit', 'YYYY-MM-DD'),
    cost = (
        CASE 
            WHEN TO_DATE('&v_data_sfarsit', 'YYYY-MM-DD') >= data_inceput
            THEN (TO_DATE('&v_data_sfarsit', 'YYYY-MM-DD') - data_inceput)
            ELSE 0
        END
        *
        (
            SELECT tarif
            FROM bicicleta
            WHERE tip = '&v_tip' AND model = '&v_model'
        )
        +
        (
            SELECT NVL(SUM(a.tarif * 
                           CASE 
                               WHEN TO_DATE('&v_data_sfarsit', 'YYYY-MM-DD') >= data_inceput
                               THEN (TO_DATE('&v_data_sfarsit', 'YYYY-MM-DD') - data_inceput)
                               ELSE 0
                           END), 0)
            FROM articole ar
            JOIN accesoriu a ON ar.id_acesoriu = a.id_acesoriu
            WHERE ar.cnp = '&v_cnp'
              AND ar.tip = '&v_tip'
              AND ar.model = '&v_model'
              AND ar.data_inceput = TO_DATE('&v_data_inceput', 'YYYY-MM-DD')
        )
    )
WHERE cnp = '&v_cnp'
  AND tip = '&v_tip'
  AND model = '&v_model'
  AND data_inceput = TO_DATE('&v_data_inceput', 'YYYY-MM-DD');

UPDATE bicicleta
SET stoc = stoc + 1
WHERE tip = '&v_tip' AND model = '&v_model';

UPDATE accesoriu
SET stoc = stoc + 1 
WHERE id_acesoriu IN (
    SELECT id_acesoriu
    FROM articole
    WHERE cnp = '&v_cnp'
      AND tip = '&v_tip'
      AND model = '&v_model'
      AND data_inceput = TO_DATE('&v_data_inceput', 'YYYY-MM-DD')
);

-- Afișare doar tabelele inchiriere și accesoriu
SELECT * FROM inchiriere;
SELECT * FROM accesoriu;
