--Procedura, która sprawdz¹ czy dany aktor bierze ju¿ udzia³a w danym spektaklu jeœli nie to go do niego dodaje

CREATE PROCEDURE DodajAktorDoSpektaklu
    @Id_aktora int,
    @Id_spektaklu int,
    @Id_roli int
AS
BEGIN
    DECLARE @nazwisko varchar(30)

    IF EXISTS (
        SELECT 1
        FROM AktorSpektakl
        WHERE Aktor_Id = @Id_aktora AND Spektakl_Id = @Id_spektaklu
    )
    BEGIN
     
        SELECT @nazwisko = Nazwisko
        FROM Osoba
        WHERE Id = (
            SELECT Osoba_Id
            FROM Aktor
            WHERE Id_aktora = @Id_aktora
        )

   
        PRINT 'Aktor o nazwisku ' + @nazwisko + ' jest ju¿ w obsadzie tego spektaklu.'
    END
    ELSE
    BEGIN
     
        INSERT INTO AktorSpektakl (Spektakl_Id, Aktor_Id, Id_roli)
        VALUES (@Id_spektaklu, @Id_aktora, @Id_roli)

        PRINT 'Aktor zosta³ dodany do obsady spektaklu.'
    END
END

-- Przyk³ad u¿ycia procedury
DECLARE @Id_aktora_param int = 4
DECLARE @Id_spektaklu_param int = 1
DECLARE @Id_roli_param int = 4

EXEC DodajAktorDoSpektaklu
    @Id_aktora = @Id_aktora_param,
    @Id_spektaklu = @Id_spektaklu_param,
    @Id_roli = @Id_roli_param



select * from aktor;
select * from spektakl;
select * from aktorSpektakl;
select * from rola;


--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Procedura, która wybiera osoby, które s¹ jednoczeœnie aktorem i re¿yserem i podnosi ich pensje o 10%
CREATE PROCEDURE PodniesPensjeRezyserAktor AS
BEGIN
    DECLARE @nazwisko VARCHAR(30);

    DECLARE c_RezyserAktor CURSOR FOR
        SELECT DISTINCT O.Nazwisko
        FROM Rezyser R
        JOIN Aktor A ON R.Osoba_Id = A.Osoba_Id
        JOIN Osoba O ON O.Id = R.Osoba_Id;

    OPEN c_RezyserAktor;
    FETCH NEXT FROM c_RezyserAktor INTO @nazwisko;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE Rezyser
        SET Pensja = Pensja * 1.1
        WHERE Osoba_Id IN (SELECT Id FROM Osoba WHERE Nazwisko = @nazwisko);

        UPDATE Aktor
        SET Pensja = Pensja * 1.1
        WHERE Osoba_Id IN (SELECT Id FROM Osoba WHERE Nazwisko = @nazwisko);

        PRINT 'Podniesiono pensjê dla osoby o nazwisku ' + @nazwisko + ' (re¿yser i aktor) o 10%.';

        FETCH NEXT FROM c_RezyserAktor INTO @nazwisko;
    END;

    CLOSE c_RezyserAktor;
    DEALLOCATE c_RezyserAktor;
END;

exec
    PodniesPensjeRezyserAktor;
	select * from aktor;



SELECT * FROM AKTOR;

----------------------------------------------------------------------------------------------------------------------------------------------
-- Wyzwalacz, który automatycznie aktualizuje date koñca wystawiania spektaklu na date 30 dni po premierze

/*CREATE TRIGGER AktualizujKoniecWystawiania
ON Spektakl
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Aktualizacja daty koñca wystawiania tylko jeœli KoniecWystawiania IS NULL
    UPDATE s
    SET KoniecWystawiania = DATEADD(day, 30, i.Premiera)
    FROM Spektakl s
    JOIN inserted i ON s.Id_spektaklu = i.Id_spektaklu
    WHERE (s.KoniecWystawiania IS NULL OR s.KoniecWystawiania <> DATEADD(day, 30, i.Premiera));
END



-- Przyk³ad dodania nowego spektaklu
select * from Spektakl;
-- Przyk³ad aktualizacji daty premiery dla istniej¹cego spektaklu
UPDATE Spektakl
SET Premiera = '2024-02-01'
WHERE Id_spektaklu = 5;

*/


---------------------------------------------------------------------------------------------------------------------------
-- Wyzwalacz, który sprawdza przed usuniêciem spektaklu czy nie ma on ju¿ przypisanej obsady, jeœli ma to nie pozwala na usuniêcie go


CREATE TRIGGER UsunSpektakl
ON Spektakl
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM deleted d
        LEFT JOIN AktorSpektakl a ON d.Id_spektaklu = a.Spektakl_Id
        LEFT JOIN RezyserSpektakl r ON d.Id_spektaklu = r.Spektakl_Id
        WHERE a.Spektakl_Id IS NOT NULL OR r.Spektakl_Id IS NOT NULL
    )
    BEGIN
        PRINT 'Nie mo¿na usun¹æ spektaklu, który ma obsadê';
        ROLLBACK;
    END
    ELSE
    BEGIN
       
        DELETE FROM Spektakl
        FROM Spektakl s
        JOIN deleted d ON s.Id_spektaklu = d.Id_spektaklu;
    END
END


DELETE FROM Spektakl
WHERE Id_spektaklu = 5;
select * from Spektakl;
