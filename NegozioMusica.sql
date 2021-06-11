CREATE DATABASE NegozioMusica

CREATE TABLE Band(
   ID INT IDENTITY(1,1),
   Nome VARCHAR(80) NOT NULL,
   NumComponenti INT NOT NULL,
   PRIMARY KEY(ID),
   UNIQUE (Nome,NumComponenti)
)

CREATE TABLE Album(
   ID INT IDENTITY(1,1),
   Titolo VARCHAR(80) NOT NULL,
   AnnoPubb DATE NOT NULL,
   CasaDiscografica VARCHAR(80) NOT NULL,
   Genere VARCHAR(30) NOT NULL,
   SupportoDistribuzione VARCHAR(30) NOT NULL,
   AlbumID INT NOT NULL, --Volevo scrivere BandID
   PRIMARY KEY(ID),
   UNIQUE(Titolo,AnnoPubb,CasaDiscografica,Genere,SupportoDistribuzione),
   CHECK(Genere IN ('Classico','Jazz','Pop','Rock','Metal')),
   CHECK(SupportoDistribuzione IN ('CD','Vinile','Streaming')),
   FOREIGN KEY (AlbumID) REFERENCES Album(ID)
)

CREATE TABLE Brano(
   ID INT IDENTITY(1,1),
   Titolo VARCHAR(80) NOT NULL,
   Durata INT NOT NULL,
   PRIMARY KEY(ID),
   UNIQUE(Titolo,Durata),
   CHECK(Durata > 0)
)

CREATE TABLE BrAlb(
   AlbumID INT NOT NULL,
   BranoID INT NOT NULL,
   FOREIGN KEY(AlbumID) REFERENCES Album(ID),
   FOREIGN KEY(BranoID) REFERENCES Brano(ID)
)

--BAND:
INSERT INTO Band VALUES ('883', 2)
INSERT INTO Band VALUES ('Maneskin', 4)
INSERT INTO Band VALUES ('Abba', 4)
INSERT INTO Band VALUES ('Queen', 4)
INSERT INTO Band VALUES ('AC/DC', 5)
INSERT INTO Band VALUES ('Led Zeppelin', 4)
--ALBUM:
INSERT INTO Album VALUES ('BimBumBam','1999-02-01','JellySco','Metal','CD', 1)
INSERT INTO Album VALUES ('BimBumBam','1999-02-01','JellySco','Metal','Streaming', 2)
INSERT INTO Album VALUES ('ParaPara','2005-03-11','DiScott','Rock','Vinile', 3)
INSERT INTO Album VALUES ('TickiTicki','1989-12-21','AB_Disco','Pop','CD', 4)
INSERT INTO Album VALUES ('PilliPolli','1972-03-05','Pamperography','Jazz','Vinile', 1)
INSERT INTO Album VALUES ('MimmiLù','1998-08-05','Moon&Co','Jazz','CD', 5)
INSERT INTO Album VALUES ('EasyPeasy','1998-08-05','LemonSqueezy','Classico','Streaming', 3)
INSERT INTO Album VALUES ('Poppidù','2000-02-02','LuTunz','Pop','CD', 2)
INSERT INTO Album VALUES ('PimPiriPimTucTuc','2010-09-15','PomGoMusic','Rock','Vinile', 4)
--BRANI:
INSERT INTO Brano VALUES ('Il Pellicano', 186)
INSERT INTO Brano VALUES ('Vasettino ino ino', 345)
INSERT INTO Brano VALUES ('PolloFritto', 277)
INSERT INTO Brano VALUES ('AEIOUY', 302)
INSERT INTO Brano VALUES ('Il Papero Felice', 318)
INSERT INTO Brano VALUES ('WhyNot?', 412)
INSERT INTO Brano VALUES ('Coccodè', 236)
INSERT INTO Brano VALUES ('Ullalà', 210)
INSERT INTO Brano VALUES ('Cotoletta', 410)
--BRALB:
INSERT INTO BrAlb VALUES (1,2)
INSERT INTO BrAlb VALUES (2,3)
INSERT INTO BrAlb VALUES (4,5)
INSERT INTO BrAlb VALUES (5,1)
INSERT INTO BrAlb VALUES (7,2)
INSERT INTO BrAlb VALUES (4,3)
INSERT INTO BrAlb VALUES (3,9)
INSERT INTO BrAlb VALUES (2,1)
INSERT INTO BrAlb VALUES (6,7)

--Scrivere una query che restituisca i titoli degli album degli “883”:
SELECT a.Titolo AS 'Nome Brano', b.Nome AS 'Nome Band'
FROM Band b
JOIN Album a
ON a.AlbumID = b.ID --Volevo scrivere BandID
WHERE b.Nome ='883'

--Selezionare tutti gli album editi dalla casa editrice nell’anno specificato:
SELECT a.Titolo AS 'Nome Album', a.CasaDiscografica AS 'Casa Discografica', a.AnnoPubb AS 'Anno Pubblicazione'
FROM Album a
WHERE a.CasaDiscografica = 'JellySco' AND a.AnnoPubb = '1999-02-01'

--Scrivere una query che restituisca tutti i titoli delle canzoni dei “Maneskin” appartenenti ad album pubblicati prima del 2019:
SELECT br.Titolo AS 'Nome Brano', b.Nome AS 'Nome Band', a.Titolo AS 'Nome Album', a.AnnoPubb AS 'Anno Pubblicazione Album'
FROM Band b
JOIN Album a
ON a.AlbumID = b.ID --Volevo scrivere BandID
JOIN BrAlb bra
ON bra.AlbumID = a.ID
JOIN Brano br
ON bra.BranoID = br.ID
WHERE b.Nome = 'Maneskin' AND YEAR(a.AnnoPubb) < 2019

--Individuare tutti gli album in cui è contenuta la canzone “Imagine”:
SELECT br.Titolo AS 'Nome Brano', a.Titolo AS 'Nome Album'
FROM Album A
JOIN BrAlb bra
ON bra.AlbumID = a.ID
JOIN Brano br
ON bra.BranoID = br.ID
WHERE br.Titolo = 'Imagine'

--Restituire il numero totale di canzoni eseguite dalla band “The Giornalisti”:
SELECT COUNT(*) AS 'Numero Canzoni'
FROM Band b
JOIN Album a
ON a.AlbumID = b.ID --Volevo scrivere BandID
JOIN BrAlb bra
ON bra.AlbumID = a.ID
JOIN Brano br
ON bra.BranoID = br.ID
WHERE b.Nome = 'The Giornalisti'

--Contare per ogni album, la somma dei minuti dei brani contenuti:
SELECT a.Titolo AS 'Album', SUM(br.Durata) AS 'Durata Totale Album'
FROM Album a
JOIN BrAlb bra
ON bra.AlbumID = a.ID
JOIN Brano br
ON bra.BranoID = br.ID
GROUP BY a.Titolo

--Creare una view che mostri i dati completi dell’album, dell’artista e dei brani contenuti in essa:
CREATE VIEW [Info Musica] AS(
SELECT a.Titolo AS 'Nome Album', a.AnnoPubb AS 'Anno Pubblicazione Album', a.Genere AS 'Genere Album', 
a.CasaDiscografica AS 'Casa Discografica', a.SupportoDistribuzione AS 'Supporto di Distribuzione', 
b.Nome AS 'Nome Band', b.NumComponenti AS 'Numero Membri della Band', br.Titolo AS 'Nome Brano', br.Durata AS 'Durata del brano'
FROM Band b
JOIN Album a
ON a.AlbumID = b.ID --Volevo scrivere BandID
JOIN BrAlb bra
ON bra.AlbumID = a.ID
JOIN Brano br
ON bra.BranoID = br.ID
)
SELECT * FROM [Info Musica]

--Scrivere una funzione utente che calcoli per ogni genere musicale quanti album sono inseriti in catalogo:
CREATE FUNCTION ufnNumeroAlbumPerGenere(@Genere VARCHAR(30))
RETURNS INT
AS
BEGIN
	RETURN (SELECT a.Genere AS 'Genere Album', COUNT(*) AS 'Numero di Album'
	FROM Album a
	--WHERE a.Genere = @Genere
	GROUP BY a.Genere)
END

SELECT *, dbo.ufnNumeroAlbumPerGenere(a.Genere) FROM Album a
