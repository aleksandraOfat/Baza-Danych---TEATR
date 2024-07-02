CREATE OR REPLACE PROCEDURE CheckActorParticipation(
actorId IN INTEGER,
    spektaklId IN INTEGER,
    rolaId IN INTEGER
) IS
    udzial INTEGER;
    nazwisko VARCHAR2(50);
BEGIN
    BEGIN
        SELECT COUNT(*), O.Nazwisko
        INTO udzial, nazwisko
        FROM AktorSpektakl ASp
        JOIN Osoba O ON O.Id = ASp.Aktor_Id
        WHERE Aktor_Id = actorId AND Spektakl_Id = spektaklId
        GROUP BY O.Nazwisko;

     EXCEPTION
       WHEN NO_DATA_FOUND THEN
            udzial := 0;
    END;

    IF udzial = 0 THEN
        INSERT INTO AktorSpektakl (Aktor_Id, Spektakl_Id, Id_roli)
        VALUES (actorId, spektaklId, rolaId);
        DBMS_OUTPUT.PUT_LINE('Aktor o nazwisku '  || nazwisko||' został dodany do obsady spektaklu.');
    ELSE
        -- Actor is already participating
        DBMS_OUTPUT.PUT_LINE('Aktor o nazwisku '  || nazwisko||' jest już w obsadzie tego spektaklu.');
    END IF;
END
 CheckActorParticipation;


DECLARE
    aktorId INTEGER := 1;
    spektaklID INTEGER := 3;
    rolaId INTEGER := 2;
BEGIN
    CheckActorParticipation(aktorId, spektaklID, rolaId);
END;

select * from AKTORSPEKTAKL;




CREATE OR REPLACE PROCEDURE PodniesPensjeRezyserAktor AS
    CURSOR c_RezyserAktor IS
        SELECT DISTINCT O.Nazwisko
        FROM Rezyser R
        JOIN Aktor A ON R.Osoba_Id = A.Osoba_Id
        JOIN Osoba O ON O.Id = R.Osoba_Id;

    nazwisko VARCHAR2(30);
BEGIN
    FOR c IN c_RezyserAktor LOOP
        nazwisko := c.Nazwisko;

        UPDATE Rezyser
        SET Pensja = Pensja * 1.1
        WHERE Osoba_Id IN (SELECT Id FROM Osoba WHERE Nazwisko = nazwisko);

        UPDATE Aktor
        SET Pensja = Pensja * 1.1
        WHERE Osoba_Id IN (SELECT Id FROM Osoba WHERE Nazwisko = nazwisko);

        DBMS_OUTPUT.PUT_LINE('Podniesiono pensję dla osoby o nazwisku ' || nazwisko || ' (reżyser i aktor) o 10%.');
    END LOOP;
END;

BEGIN
    PodniesPensjeRezyserAktor;
END;

select * from AKTOR;




/*
CREATE OR REPLACE TRIGGER TrgAktualizujDateZakonczenia
BEFORE INSERT OR UPDATE OF Premiera ON Spektakl
FOR EACH ROW
DECLARE
    v_LiczbaDni NUMBER := 30;
BEGIN
    IF :OLD.Premiera IS NULL OR :NEW.Premiera <> :OLD.Premiera THEN
        :NEW.KoniecWystawiania := :NEW.Premiera + v_LiczbaDni;
        DBMS_OUTPUT.PUT_LINE('Zaktualizowano datę zakończenia wystawiania spektaklu.');
    END IF;
END;


-- Aktualizacja daty premiery dla istniejącego spektaklu
UPDATE Spektakl
SET Premiera = TO_DATE('2024-12-01', 'YYYY-MM-DD')
WHERE Id_spektaklu = 1;
select * from SPEKTAKL;

*/


CREATE OR REPLACE TRIGGER TrgSprawdzSpektakl
BEFORE INSERT OR UPDATE ON Spektakl
FOR EACH ROW
DECLARE
    v_IloscAktorow INTEGER;
    v_IloscScenarzystow INTEGER;
BEGIN
    -- Sprawdzenie warunku 1: Przynajmniej jeden aktor musi być przypisany do spektaklu
    SELECT COUNT(DISTINCT Aktor_Id)
    INTO v_IloscAktorow
    FROM AktorSpektakl
    WHERE Spektakl_Id = :NEW.Id_spektaklu;

    IF v_IloscAktorow = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Spektakl musi mieć przynajmniej jednego aktora!');
    END IF;

    -- Sprawdzenie warunku 2: Przynajmniej jeden scenarzysta musi być przypisany do spektaklu
    SELECT COUNT(DISTINCT Scenarzysta_Id)
    INTO v_IloscScenarzystow
    FROM ScenarzystaSpektakl
    WHERE Spektakl_Id = :NEW.Id_spektaklu;

    IF v_IloscScenarzystow = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Spektakl musi mieć przynajmniej jednego scenarzystę!');
    END IF;
END;

-- Aktualizacja Spektaklu, nie powinno zgłosić błędu
UPDATE Spektakl SET Tytul = 'Inny Spektakl' WHERE Id_spektaklu = 1;

-- wstawienie nowego Spektaklu, nie ma aktora ani spenarzysty- powinno zgłosić błąd
INSERT INTO Spektakl (Id_spektaklu, Tytul, Premiera, KoniecWystawiania, Sala_Id)
VALUES (9, 'Nowy Spektakl', TO_DATE('2024-03-01', 'YYYY-MM-DD'), TO_DATE('2024-03-15', 'YYYY-MM-DD'), 3);

select * from AKTORSPEKTAKL;
select * from SCENARZYSTASPEKTAKL;
select * from SPEKTAKL;


