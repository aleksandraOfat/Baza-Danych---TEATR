
-- tables
-- Table: Akcesorium
CREATE TABLE Akcesorium (
    Id int  NOT NULL,
    typ_akcesorium varchar(15)  NOT NULL,
    Nazwa varchar(20)  NOT NULL,
    Opis varchar(60)  NOT NULL,
    Rozmiar varchar(15)  NULL,
    CONSTRAINT Akcesorium_pk PRIMARY KEY  (Id)
);

-- Table: AkcesoriumSpektakl
CREATE TABLE AkcesoriumSpektakl (
    Akcesorium_Id int  NOT NULL,
    Spektakl_Id_spektaklu int  NOT NULL,
    CONSTRAINT AkcesoriumSpektakl_pk PRIMARY KEY  (Akcesorium_Id,Spektakl_Id_spektaklu)
);

-- Table: Aktor
CREATE TABLE Aktor (
    Id_aktora int  NOT NULL,
    Osoba_Id int  NOT NULL,
    Pensja int  NOT NULL,
    CONSTRAINT Aktor_pk PRIMARY KEY  (Id_aktora)
);

-- Table: AktorSpektakl
CREATE TABLE AktorSpektakl (
    Spektakl_Id int  NOT NULL,
    Aktor_Id int  NOT NULL,
    Id_roli int  NOT NULL,
    CONSTRAINT AktorSpektakl_pk PRIMARY KEY  (Spektakl_Id,Aktor_Id)
);

-- Table: Osoba
CREATE TABLE Osoba (
    Id int  NOT NULL,
    Imie varchar(20)  NOT NULL,
    Nazwisko varchar(30)  NOT NULL,
    Plec char(1)  NOT NULL,
    DataUrodzenia date  NOT NULL,
    CONSTRAINT Osoba_pk PRIMARY KEY  (Id)
);

-- Table: Rezyser
CREATE TABLE Rezyser (
    Id_rezysera int  NOT NULL,
    Osoba_Id int  NOT NULL,
    Pensja int  NOT NULL,
    CONSTRAINT Rezyser_pk PRIMARY KEY  (Id_rezysera)
);

-- Table: RezyserSpektakl
CREATE TABLE RezyserSpektakl (
    Rezyser_Id int  NOT NULL,
    Spektakl_Id int  NOT NULL,
    CONSTRAINT RezyserSpektakl_pk PRIMARY KEY  (Rezyser_Id,Spektakl_Id)
);

-- Table: Rola
CREATE TABLE Rola (
    Id_roli int  NOT NULL,
    Nazwa varchar(20)  NOT NULL,
    Aktor_Id int  NOT NULL,
    CONSTRAINT Rola_pk PRIMARY KEY  (Id_roli)
);

-- Table: Sala
CREATE TABLE Sala (
    Id int  NOT NULL,
    IloscMiejsc int  NOT NULL,
    CONSTRAINT Sala_pk PRIMARY KEY  (Id)
);

-- Table: Scenarzysta
CREATE TABLE Scenarzysta (
    Id_scenarzysty int  NOT NULL,
    Osoba_Id int  NOT NULL,
    Pensja int  NOT NULL,
    CONSTRAINT Scenarzysta_pk PRIMARY KEY  (Id_scenarzysty)
);

-- Table: ScenarzystaSpektakl
CREATE TABLE ScenarzystaSpektakl (
    Scenarzysta_Id int  NOT NULL,
    Spektakl_Id int  NOT NULL,
    CONSTRAINT ScenarzystaSpektakl_pk PRIMARY KEY  (Scenarzysta_Id,Spektakl_Id)
);

-- Table: Spektakl
CREATE TABLE Spektakl (
    Id_spektaklu int  NOT NULL,
    Tytul varchar(20)  NOT NULL,
    Opis varchar(100)  NOT NULL,
    Premiera date  NOT NULL,
    KoniecWystawiania date  NOT NULL,
    Sala_Id int  NOT NULL,
    CONSTRAINT Spektakl_pk PRIMARY KEY  (Id_spektaklu)
);

-- foreign keys
-- Reference: AkcesoriumSpektakl_Akcesorium (table: AkcesoriumSpektakl)
ALTER TABLE AkcesoriumSpektakl ADD CONSTRAINT AkcesoriumSpektakl_Akcesorium
    FOREIGN KEY (Akcesorium_Id)
    REFERENCES Akcesorium (Id);

-- Reference: AkcesoriumSpektakl_Spektakl (table: AkcesoriumSpektakl)
ALTER TABLE AkcesoriumSpektakl ADD CONSTRAINT AkcesoriumSpektakl_Spektakl
    FOREIGN KEY (Spektakl_Id_spektaklu)
    REFERENCES Spektakl (Id_spektaklu);

-- Reference: AktorSpektakl_Aktor (table: AktorSpektakl)
ALTER TABLE AktorSpektakl ADD CONSTRAINT AktorSpektakl_Aktor
    FOREIGN KEY (Aktor_Id)
    REFERENCES Aktor (Id_aktora);

-- Reference: AktorSpektakl_Rola (table: AktorSpektakl)
ALTER TABLE AktorSpektakl ADD CONSTRAINT AktorSpektakl_Rola
    FOREIGN KEY (Id_roli)
    REFERENCES Rola (Id_roli);

-- Reference: AktorSpektakl_Spektakl (table: AktorSpektakl)
ALTER TABLE AktorSpektakl ADD CONSTRAINT AktorSpektakl_Spektakl
    FOREIGN KEY (Spektakl_Id)
    REFERENCES Spektakl (Id_spektaklu);

-- Reference: Aktor_Osoba (table: Aktor)
ALTER TABLE Aktor ADD CONSTRAINT Aktor_Osoba
    FOREIGN KEY (Osoba_Id)
    REFERENCES Osoba (Id);

-- Reference: RezyserSpektakl_Rezyser (table: RezyserSpektakl)
ALTER TABLE RezyserSpektakl ADD CONSTRAINT RezyserSpektakl_Rezyser
    FOREIGN KEY (Rezyser_Id)
    REFERENCES Rezyser (Id_rezysera);

-- Reference: RezyserSpektakl_Spektakl (table: RezyserSpektakl)
ALTER TABLE RezyserSpektakl ADD CONSTRAINT RezyserSpektakl_Spektakl
    FOREIGN KEY (Spektakl_Id)
    REFERENCES Spektakl (Id_spektaklu);

-- Reference: Rezyser_Osoba (table: Rezyser)
ALTER TABLE Rezyser ADD CONSTRAINT Rezyser_Osoba
    FOREIGN KEY (Osoba_Id)
    REFERENCES Osoba (Id);

-- Reference: ScenarzySpekt_Scenarzysta (table: ScenarzystaSpektakl)
ALTER TABLE ScenarzystaSpektakl ADD CONSTRAINT ScenarzySpekt_Scenarzysta
    FOREIGN KEY (Scenarzysta_Id)
    REFERENCES Scenarzysta (Id_scenarzysty);

-- Reference: ScenarzystaSpektakl_Spektakl (table: ScenarzystaSpektakl)
ALTER TABLE ScenarzystaSpektakl ADD CONSTRAINT ScenarzystaSpektakl_Spektakl
    FOREIGN KEY (Spektakl_Id)
    REFERENCES Spektakl (Id_spektaklu);

-- Reference: Scenarzysta_Osoba (table: Scenarzysta)
ALTER TABLE Scenarzysta ADD CONSTRAINT Scenarzysta_Osoba
    FOREIGN KEY (Osoba_Id)
    REFERENCES Osoba (Id);

-- Reference: Spektakl_Sala (table: Spektakl)
ALTER TABLE Spektakl ADD CONSTRAINT Spektakl_Sala
    FOREIGN KEY (Sala_Id)
    REFERENCES Sala (Id);


