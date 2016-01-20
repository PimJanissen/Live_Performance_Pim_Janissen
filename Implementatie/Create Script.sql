/*
DROP TABLEs
*/

DROP TABLE SERVICEBEURT cascade constraints;
DROP TABLE SCHOONMAAKBEURT cascade constraints;
DROP TABLE BEURT cascade constraints;
DROP TABLE ACCOUNT cascade constraints;
DROP TABLE MELDING cascade constraints;
DROP TABLE REMISE cascade constraints;
DROP TABLE REMISE_ACCOUNT cascade constraints;
DROP TABLE WAGEN cascade constraints;
DROP TABLE WAGENTYPE cascade constraints;
DROP TABLE SPOOR cascade constraints;
DROP TABLE LIJN cascade constraints;
DROP TABLE WAGENTYPE_LIJN cascade constraints;
DROP TABLE LIJN_SPOOR cascade constraints;
DROP TABLE SECTOR cascade constraints;
DROP TABLE RESERVERING cascade constraints;

/*
DROP SEQUENCES
*/
DROP SEQUENCE "SEQ_BEURTID";
DROP SEQUENCE "SEQ_ACCOUNTID";
DROP SEQUENCE "SEQ_MELDINGID";
DROP SEQUENCE "SEQ_REMISEID";
DROP SEQUENCE "SEQ_SPOORID";
DROP SEQUENCE "SEQ_SECTORID";
DROP SEQUENCE "SEQ_WAGENID";
DROP SEQUENCE "SEQ_WAGENTYPEID";
DROP SEQUENCE "SEQ_LIJNID";

/*
CREATE TABLEs
Inclusief PKs, single-column CHECKs en single-column UNIQUEs
*/

CREATE TABLE ACCOUNT(
  ID              NUMBER(10)      PRIMARY KEY,
  email           VARCHAR2(256)   NOT NULL UNIQUE,
  wachtwoord      VARCHAR2(64)    NOT NULL,
  voornaam        VARCHAR2(64)    NOT NULL,
  tussenvoegsel   VARCHAR2(64)    NULL,
  achternaam      VARCHAR2(64)    NOT NULL,
  rol             VARCHAR2(64)    NOT NULL        CHECK (rol IN ('TramDepotManager', 'Cleaner', 'Technician', 'Administrator', 'Driver')),
  status          NUMBER(1)       DEFAULT '1'     CHECK (status BETWEEN 0 AND 1)
);

CREATE TABLE REMISE(
  ID            NUMBER(10)      PRIMARY KEY,
  naam          VARCHAR2(64)    NOT NULL  UNIQUE,
  straat        VARCHAR2(256)   NOT NULL,
  huisnummer    VARCHAR2(16)    NOT NULL,
  plaats        VARCHAR2(256)   NOT NULL,
  postcode      VARCHAR2(6)     NOT NULL
);

CREATE TABLE REMISE_ACCOUNT(
  REMISE_ID     NUMBER(10)    NOT NULL,
  ACCOUNT_ID    NUMBER(10)    NOT NULL,
  CONSTRAINT pk_RemiseAccount PRIMARY KEY(REMISE_ID, ACCOUNT_ID)
);

CREATE TABLE WAGEN(
  ID              NUMBER(10)      PRIMARY KEY,
  status          VARCHAR2(64)    DEFAULT 'Depot'      CHECK (status IN ('Depot', 'Cleaning', 'Repair', 'Removed')),
  nummer          VARCHAR2(255)   NOT NULL  UNIQUE,
  WAGENTYPE_ID    NUMBER(10)      NOT NULL,
  REMISE_ID       NUMBER(10)      NOT NULL,
  LIJN_ID		  NUMBER(10)	  NULL,
  les             NUMBER(1)       DEFAULT '0'           CHECK (les BETWEEN 0 AND 1)
);

CREATE TABLE WAGENTYPE(
  ID                NUMBER(10)    NOT NULL  PRIMARY KEY,
  naam              VARCHAR2(64)  NOT NULL  UNIQUE,
  lengte            NUMBER(10)    NOT NULL,
  isDubbelzijdig    NUMBER(1)     DEFAULT '0'   CHECK (isDubbelzijdig BETWEEN 0 AND 1)
);

CREATE TABLE LIJN(
  ID        NUMBER(10)      PRIMARY KEY,  
  nummer    VARCHAR2(16)    NOT NULL UNIQUE,
  kleur     VARCHAR2(7)     NOT NULL UNIQUE
);

CREATE TABLE WAGENTYPE_LIJN(
  WAGENTYPE_ID    NUMBER(10)    NOT NULL,
  LIJN_ID         NUMBER(10)    NOT NULL,
  CONSTRAINT pk_WagentypeLijn PRIMARY KEY(WAGENTYPE_ID, LIJN_ID)
);

CREATE TABLE SPOOR(
  ID          NUMBER(10)    PRIMARY KEY,
  nummer      NUMBER(10)    NOT NULL,
  type        VARCHAR2(64)  DEFAULT 'Depot'   CHECK (type IN ('Depot', 'Repair', 'Cleaning', 'Temporary')),
  REMISE_ID   NUMBER(10)    NOT NULL
);

CREATE TABLE LIJN_SPOOR(
  LIJN_ID     NUMBER(10)    NOT NULL,
  SPOOR_ID    NUMBER(10)    NOT NULL,
  CONSTRAINT pk_LijnSpoor PRIMARY KEY(LIJN_ID, SPOOR_ID)
);

CREATE TABLE SECTOR(
  ID            NUMBER(10)    PRIMARY KEY,
  nummer        NUMBER(10)    NOT NULL,
  WAGEN_ID      NUMBER(10)    NULL UNIQUE,
  SPOOR_ID      NUMBER(10)    NOT NULL,
  geblokkeerd   NUMBER(1)     DEFAULT '0'    CHECK (geblokkeerd BETWEEN 0 AND 1)
);

CREATE TABLE RESERVERING(
  SPOOR_ID    NUMBER(10)    NOT NULL,
  WAGEN_ID    NUMBER(10)    NOT NULL UNIQUE,
  CONSTRAINT pk_SpoorWagen PRIMARY KEY(SPOOR_ID, WAGEN_ID)
);

CREATE TABLE BEURT(
  ID              NUMBER(10)      PRIMARY KEY,
  startTijdstip   DATE            NULL,
  eindTijdstip    DATE            NULL,
  WAGEN_ID        NUMBER(10)      NOT NULL,
  beschrijving    VARCHAR2(4000)  NULL,
  isGroot         NUMBER(1)       DEFAULT '0'    CHECK (isGroot BETWEEN 0 AND 1)
);

CREATE TABLE SERVICEBEURT(
  ID            NUMBER(10)    PRIMARY KEY,
  ACCOUNT_ID    NUMBER(10)    NULL
);

CREATE TABLE SCHOONMAAKBEURT(
  ID            NUMBER(10)    PRIMARY KEY,
  ACCOUNT_ID    NUMBER(10)    NULL
);

CREATE TABLE MELDING(
  ID            NUMBER(10)      PRIMARY KEY,
  WAGEN_ID      NUMBER(10)      NOT NULL,
  ACCOUNT_ID    NUMBER(10)      NOT NULL,
  type          VARCHAR2(64)    NOT NULL,
  bericht       VARCHAR2(4000)  NULL
);

/*
INSERTS
*/
INSERT INTO ACCOUNT(ID, email, wachtwoord, voornaam, tussenvoegsel, achternaam, rol, status)
VALUES(1, 'karel@gvb.nl', 'Wachtwoord1', 'Karel', null, 'Jansen', 'Driver', 1);
INSERT INTO ACCOUNT(ID, email, wachtwoord, voornaam, tussenvoegsel, achternaam, rol, status)
VALUES(2, 'annie@gvb.nl', 'Wachtwoord2', 'Annie', 'van', 'Veen', 'Cleaner', 1);
INSERT INTO ACCOUNT(ID, email, wachtwoord, voornaam, tussenvoegsel, achternaam, rol, status)
VALUES(3, 'harm@gvb.nl', 'Wachtwoord3', 'Harm', null, 'Klaasen', 'Technician', 1);
INSERT INTO ACCOUNT(ID, email, wachtwoord, voornaam, tussenvoegsel, achternaam, rol, status)
VALUES(4, 'leon@gvb.nl', 'Wachtwoord4', 'Leon', 'de', 'Groot', 'Administrator', 1);
INSERT INTO ACCOUNT(ID, email, wachtwoord, voornaam, tussenvoegsel, achternaam, rol, status)
VALUES(5, 'frank@gvb.nl', 'Wachtwoord5', 'Frank', null, 'Verstappe', 'TramDepotManager', 1);

INSERT INTO REMISE(ID, naam, straat, huisnummer, plaats, postcode)
VALUES(1, 'Remise Havenstraat', 'Havenstraat', '18', 'Amsterdam', '1075PR');
INSERT INTO REMISE(ID, naam, straat, huisnummer, plaats, postcode)
VALUES(2, 'Remise Lekstraat', 'Kromme Mijdrechtstraat', '25', 'Amsterdam', '1079KN');

INSERT INTO REMISE_ACCOUNT(REMISE_ID, ACCOUNT_ID)
VALUES(1, 1);
INSERT INTO REMISE_ACCOUNT(REMISE_ID, ACCOUNT_ID)
VALUES(1, 2);
INSERT INTO REMISE_ACCOUNT(REMISE_ID, ACCOUNT_ID)
VALUES(1, 3);
INSERT INTO REMISE_ACCOUNT(REMISE_ID, ACCOUNT_ID)
VALUES(1, 4);
INSERT INTO REMISE_ACCOUNT(REMISE_ID, ACCOUNT_ID)
VALUES(1, 5);

INSERT INTO WAGENTYPE(ID, naam, lengte, isDubbelzijdig)
VALUES(1, 'Combino', 10, 0);
INSERT INTO WAGENTYPE(ID, naam, lengte, isDubbelzijdig)
VALUES(2, '11G', 10, 0);
INSERT INTO WAGENTYPE(ID, naam, lengte, isDubbelzijdig)
VALUES(3, 'Dubbel kop combino', 10, 1);
INSERT INTO WAGENTYPE(ID, naam, lengte, isDubbelzijdig)
VALUES(4, '12G', 10, 0);
INSERT INTO WAGENTYPE(ID, naam, lengte, isDubbelzijdig)
VALUES(5, 'Opleidingstrams', 10, 0);

INSERT INTO LIJN(ID, nummer, kleur)
VALUES(1, 1, '#99CC00');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(2, 2, '#FFFF00');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(3, 5, '#CC99FF');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(4, 10, '#C0C0C0');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(5, 13, '#3366FF');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(6, 16, '#CCFFCC');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(7, 17, '#FF0000');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(8, 24, '#608A8C');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(9, 780, '#FFD000');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(10, 781, '#FF7F59');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(11, 782, '#FF00FA');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(12, 784, '#00D4FF');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(13, 785, '#FFEC99');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(14, 786, '#A06A58');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(15, 787, '#9E8C56');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(16, 797, '#9E3456');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(17, 801, '#72699B');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(18, 804, '#D4FF00');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(19, 810, '#89D2A7');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(20, 813, '#FFFFFF');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(21, 815, '#B200FF');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(22, 4, '#00FFF6');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(23, 7, '#DEE2A1');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(24, 9, '#2E7A1C');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(25, 12, '#00FFFF');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(26, 14, '#F0FFC6');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(27, 25, '#D67FFF');
INSERT INTO LIJN(ID, nummer, kleur)
VALUES(28, 1624, '#a34719');

INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(1, 'Depot', '2001', 1, 1, 4, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(2, 'Depot', '2002', 1, 1, 2, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(3, 'Depot', '2003', 1, 1, 7, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(4, 'Depot', '2004', 1, 1, 4, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les) 
VALUES(5, 'Depot','2005', 1, 1, 7, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(6, 'Depot', '2006', 1, 1, 5, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(7, 'Depot', '2007', 1, 1, 1, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(8, 'Depot', '2008', 1, 1, 2, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(9, 'Depot', '2009', 1, 1, 1, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(10, 'Depot', '2010', 1, 1, 5, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(11, 'Cleaning', '2011', 1, 1, 7, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(12, 'Depot', '2012', 1, 1, 7, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(13, 'Depot', '2013', 1, 1, 7, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(14, 'Depot', '2014', 1, 1, 4, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(15, 'Depot', '2015', 1, 1, 5, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(16, 'Depot', '2016', 1, 1, 7, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(17, 'Depot', '2017', 1, 1, 2, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(18, 'Depot', '2018', 1, 1, 2, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(19, 'Depot', '2019', 1, 1, 2, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(20, 'Depot', '2020', 1, 1, 7, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(21, 'Depot', '2021', 1, 1, 5, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(22, 'Depot', '2022', 1, 1, 7, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(23, 'Depot', '2023', 1, 1, 1, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(24, 'Depot', '2024', 1, 1, 1, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(25, 'Depot', '2025', 1, 1, 2, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(26, 'Depot', '2026', 1, 1, 7, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(27, 'Depot', '2027', 1, 1, 7, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(28, 'Depot', '2028', 1, 1, 7, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(29, 'Depot', '2029', 1, 1, 1, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(30, 'Depot', '2030', 1, 1, 5, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(31, 'Depot', '2031', 1, 1, 2, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(32, 'Depot', '2032', 1, 1, 4, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(33, 'Depot', '2033', 1, 1, 1, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(34, 'Cleaning', '2034', 1, 1, 1, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(35, 'Depot', '2035', 1, 1, 1, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(36, 'Depot', '2036', 1, 1, 2, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(37, 'Depot', '2037', 1, 1, 4, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(38, 'Depot', '2038', 1, 1, 7, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(39, 'Depot', '2039', 1, 1, 4, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(40, 'Depot', '2040', 1, 1, 5, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(41, 'Depot', '2041', 1, 1, 1, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(42, 'Depot', '2042', 1, 1, 2, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(43, 'Depot', '2043', 1, 1, 4, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(44, 'Depot', '2044', 1, 1, 7, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(45, 'Depot', '2045', 1, 1, 5, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(46, 'Depot', '2046', 1, 1, 5, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(47, 'Depot', '2047', 1, 1, 7, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(48, 'Depot', '2048', 1, 1, 5, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(49, 'Depot', '2049', 1, 1, 2, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(50, 'Depot', '2050', 1, 1, 4, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(51, 'Depot', '2051', 1, 1, 2, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(52, 'Depot', '2052', 1, 1, 1, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(53, 'Depot', '2053', 1, 1, 1, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(54, 'Depot', '2054', 1, 1, 2, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(55, 'Depot', '2055', 1, 1, 2, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(56, 'Depot', '2056', 1, 1, 5, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(57, 'Depot', '2057', 1, 1, 1, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(58, 'Depot', '2058', 1, 1, 4, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(59, 'Depot', '2059', 1, 1, 1, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(60, 'Depot', '2060', 1, 1, 7, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(61, 'Depot', '2061', 1, 1, 1, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(62, 'Depot', '2062', 1, 1, 2, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(63, 'Depot', '2063', 1, 1, 2, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(64, 'Depot', '2064', 1, 1, 1, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(65, 'Depot', '2065', 1, 1, 2, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(66, 'Depot', '2066', 1, 1, 1, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(67, 'Depot', '2067', 1, 1, 5, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(68, 'Depot', '2068', 1, 1, 1, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(69, 'Depot', '2069', 1, 1, 2, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(70, 'Depot', '2070', 1, 1, 5, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(71, 'Depot', '2071', 1, 1, 7, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(72, 'Depot', '2072', 1, 1, 4, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(73, 'Depot', '901', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(74, 'Depot', '902', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(75, 'Depot', '903', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(76, 'Depot', '904', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(77, 'Depot', '905', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(78, 'Cleaning', '906', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(79, 'Depot', '907', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(80, 'Depot', '908', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(81, 'Depot', '909', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(82, 'Depot', '910', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(83, 'Depot', '911', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(84, 'Depot', '912', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les) 
VALUES(85, 'Depot', '913', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(86, 'Depot', '914', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(87, 'Depot', '915', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(88, 'Depot', '916', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(89, 'Depot', '917', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(90, 'Depot', '918', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(91, 'Depot', '919', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(92, 'Depot', '920', 2, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(93, 'Depot', '2201', 3, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(94, 'Depot', '2202', 3, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(95, 'Depot', '2203', 3, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(96, 'Depot', '2204', 3, 1, 3, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(97, 'Depot', '817', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(98, 'Depot', '818', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(99, 'Depot', '819', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(100, 'Depot', '820', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(101, 'Depot', '821', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(102, 'Depot', '822', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(103, 'Depot', '823', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(104, 'Depot', '824', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(105, 'Depot', '825', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(106, 'Depot', '826', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(107, 'Depot', '827', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(108, 'Depot', '828', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(109, 'Depot', '829', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(110, 'Depot', '830', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(111, 'Depot', '831', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(112, 'Depot', '832', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(113, 'Depot', '833', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(114, 'Depot', '834', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(115, 'Depot', '835', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(116, 'Depot', '836', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(117, 'Depot', '837', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(118, 'Depot', '838', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(119, 'Depot', '839', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(120, 'Depot', '840', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(121, 'Depot', '841', 4, 1, 28, 0);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(122, 'Depot', '809', 5, 1, NULL, 1);
INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(123, 'Depot', '816', 5, 1, NULL, 1);

INSERT INTO WAGEN(ID, status, nummer, WAGENTYPE_ID, REMISE_ID, LIJN_ID, les)
VALUES(124, 'Depot', '999', 1, 2, NULL, 0);

INSERT INTO WAGENTYPE_LIJN(WAGENTYPE_ID, LIJN_ID)
VALUES(2, 3);
INSERT INTO WAGENTYPE_LIJN(WAGENTYPE_ID, LIJN_ID)
VALUES(4, 6);
INSERT INTO WAGENTYPE_LIJN(WAGENTYPE_ID, LIJN_ID)
VALUES(4, 8);

INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(1, 38, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(2, 37, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(3, 36, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(4, 35, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(5, 34, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(6, 33, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(7, 32, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(8, 31, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(9, 30, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(10, 40, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(11, 41, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(12, 42, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(13, 43, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(14, 44, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(15, 45, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(16, 58, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(17, 57, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(18, 56, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(19, 55, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(20, 54, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(21, 53, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(22, 52, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(23, 51, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(24, 64, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(25, 63, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(26, 62, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(27, 61, 'Temporary', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(28, 74, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(29, 75, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(30, 76, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(31, 77, 'Depot', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(32, 12, 'Cleaning', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(33, 13, 'Cleaning', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(34, 14, 'Cleaning', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(35, 15, 'Cleaning', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(36, 16, 'Cleaning', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(37, 17, 'Repair', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(38, 18, 'Repair', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(39, 19, 'Repair', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(40, 20, 'Repair', 1);
INSERT INTO SPOOR(ID, nummer, type, REMISE_ID)
VALUES(41, 21, 'Repair', 1);

INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(2, 1);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(3, 2);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(1, 3);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(28, 4);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(2, 5);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(28, 6);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(4, 7);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(28, 9);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(4, 11);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(4, 12);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(1, 13);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(5, 14);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(7, 15);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(28, 17);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(3, 18);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(2, 19);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(3, 20);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(5, 21);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(7, 22);
INSERT INTO LIJN_SPOOR(LIJN_ID, SPOOR_ID)
VALUES(2, 25);

INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(1, 1, null, 1, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(2, 2, null, 1, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(3, 3, null, 1, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(4, 4, null, 1, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(5, 1, null, 2, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(6, 2, null, 2, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(7, 3, null, 2, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(8, 4, null, 2, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(9, 1, null, 3, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(10, 2, null, 3, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(11, 3, null, 3, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(12, 4, null, 3, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(13, 1, null, 4, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(14, 2, null, 4, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(15, 3, null, 4, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(16, 4, null, 4, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(17, 1, null, 5, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(18, 2, null, 5, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(19, 3, null, 5, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(20, 4, null, 5, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(21, 1, null, 6, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(22, 2, null, 6, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(23, 3, null, 6, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(24, 4, null, 6, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(25, 1, null, 7, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(26, 2, null, 7, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(27, 3, null, 7, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(28, 4, null, 7, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(29, 1, 11, 8, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(30, 2, 34, 8, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(31, 3, 78, 8, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(32, 1, null, 9, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(33, 2, null, 9, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(34, 3, null, 9, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(35, 1, null, 10, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(36, 2, null, 10, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(37, 3, null, 10, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(38, 4, null, 10, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(39, 5, null, 10, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(40, 6, null, 10, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(41, 7, null, 10, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(42, 8, null, 10, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(43, 1, null, 11, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(44, 2, null, 11, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(45, 3, null, 11, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(46, 4, null, 11, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(47, 1, null, 12, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(48, 2, null, 12, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(49, 3, null, 12, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(50, 4, null, 12, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(51, 1, null, 13, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(52, 2, null, 13, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(53, 3, null, 13, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(54, 4, null, 13, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(55, 1, null, 14, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(56, 2, null, 14, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(57, 3, null, 14, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(58, 4, null, 14, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(59, 1, null, 15, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(60, 2, null, 15, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(61, 3, null, 15, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(62, 4, null, 15, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(63, 5, null, 15, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(64, 6, null, 15, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(65, 7, null, 15, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(66, 8, null, 15, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(67, 9, null, 15, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(68, 1, null, 16, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(69, 2, null, 16, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(70, 3, null, 16, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(71, 4, null, 16, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(72, 5, null, 16, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(73, 1, null, 17, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(74, 2, null, 17, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(75, 3, null, 17, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(76, 4, null, 17, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(77, 5, null, 17, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(78, 6, null, 17, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(79, 7, null, 17, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(80, 8, null, 17, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(81, 1, null, 18, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(82, 2, null, 18, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(83, 3, null, 18, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(84, 4, null, 18, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(85, 5, null, 18, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(86, 6, null, 18, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(87, 7, null, 18, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(88, 8, null, 18, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(89, 1, null, 19, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(90, 2, null, 19, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(91, 3, null, 19, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(92, 4, null, 19, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(93, 5, null, 19, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(94, 6, null, 19, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(95, 7, null, 19, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(96, 8, null, 19, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(97, 1, null, 20, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(98, 2, null, 20, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(99, 3, null, 20, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(100, 4, null, 20, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(101, 5, null, 20, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(102, 6, null, 20, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(103, 7, null, 20, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(104, 1, null, 21, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(105, 2, null, 21, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(106, 3, null, 21, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(107, 4, null, 21, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(108, 5, null, 21, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(109, 6, null, 21, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(110, 7, null, 21, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(111, 1, null, 22, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(112, 2, null, 22, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(113, 3, null, 22, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(114, 4, null, 22, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(115, 5, null, 22, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(116, 6, null, 22, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(117, 7, null, 22, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(118, 1, null, 23, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(119, 2, null, 23, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(120, 3, null, 23, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(121, 4, null, 23, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(122, 5, null, 23, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(123, 6, null, 23, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(124, 1, null, 24, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(125, 2, null, 24, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(126, 3, null, 24, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(127, 4, null, 24, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(128, 5, null, 24, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(129, 6, null, 24, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(130, 1, null, 25, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(131, 2, null, 25, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(132, 3, null, 25, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(133, 4, null, 25, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(134, 1, null, 26, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(135, 2, null, 26, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(136, 3, null, 26, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(137, 1, 124, 27, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(138, 2, null, 27, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(139, 3, null, 27, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(140, 1, null, 28, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(141, 2, null, 28, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(142, 3, null, 28, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(143, 4, null, 28, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(144, 5, null, 28, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(145, 1, null, 29, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(146, 2, null, 29, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(147, 3, null, 29, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(148, 4, null, 29, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(149, 1, null, 30, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(150, 2, null, 30, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(151, 3, null, 30, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(152, 4, null, 30, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(153, 5, null, 30, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(154, 1, null, 31, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(155, 2, null, 31, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(156, 3, null, 31, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(157, 4, null, 31, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(158, 5, null, 31, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(159, 1, null, 32, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(160, 1, null, 33, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(161, 1, null, 34, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(162, 1, null, 35, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(163, 1, null, 36, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(164, 1, null, 37, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(165, 1, null, 38, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(166, 1, null, 39, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(167, 1, null, 40, 1);
INSERT INTO SECTOR(ID, nummer, WAGEN_ID, SPOOR_ID, geblokkeerd)
VALUES(168, 1, null, 41, 1);

INSERT INTO BEURT(ID, startTijdstip, eindTijdstip, WAGEN_ID, beschrijving, isGroot)
VALUES(1, to_date('10/09/2015 12:15', 'dd/mm/yyyy mi:ss'), null, 11, null, 0);
INSERT INTO BEURT(ID, startTijdstip, eindTijdstip, WAGEN_ID, beschrijving, isGroot)
VALUES(2, to_date('16/11/2015 17:54', 'dd/mm/yyyy mi:ss'), null, 34, null, 0);
INSERT INTO BEURT(ID, startTijdstip, eindTijdstip, WAGEN_ID, beschrijving, isGroot)
VALUES(3, to_date('08/09/2015 05:18', 'dd/mm/yyyy mi:ss'), null, 78, null, 0);
INSERT INTO BEURT(ID, startTijdstip, eindTijdstip, WAGEN_ID, beschrijving, isGroot)
VALUES(4, to_date('12/11/2015 16:00', 'dd/mm/yyyy mi:ss'), null, 101, null, 1);

INSERT INTO SERVICEBEURT(ID, ACCOUNT_ID)
VALUES(1, 3);
INSERT INTO SERVICEBEURT(ID, ACCOUNT_ID)
VALUES(2, 3);

INSERT INTO SCHOONMAAKBEURT(ID, ACCOUNT_ID)
VALUES(3, 2);
INSERT INTO SCHOONMAAKBEURT(ID, ACCOUNT_ID)
VALUES(4, 2);

/

/*
FKs
*/

ALTER TABLE SERVICEBEURT ADD FOREIGN KEY (ID) REFERENCES BEURT(ID);
ALTER TABLE SERVICEBEURT ADD FOREIGN KEY (ACCOUNT_ID) REFERENCES ACCOUNT(ID);
ALTER TABLE SCHOONMAAKBEURT ADD FOREIGN KEY (ID) REFERENCES BEURT(ID);
ALTER TABLE SCHOONMAAKBEURT ADD FOREIGN KEY (ACCOUNT_ID) REFERENCES ACCOUNT(ID);
ALTER TABLE BEURT ADD FOREIGN KEY (WAGEN_ID) REFERENCES WAGEN(ID);
ALTER TABLE MELDING ADD FOREIGN KEY (WAGEN_ID) REFERENCES WAGEN(ID);
ALTER TABLE MELDING ADD FOREIGN KEY (ACCOUNT_ID) REFERENCES ACCOUNT(ID);
ALTER TABLE REMISE_ACCOUNT ADD FOREIGN KEY (REMISE_ID) REFERENCES REMISE(ID);
ALTER TABLE REMISE_ACCOUNT ADD FOREIGN KEY (ACCOUNT_ID) REFERENCES ACCOUNT(ID);
ALTER TABLE WAGEN ADD FOREIGN KEY (WAGENTYPE_ID) REFERENCES WAGENTYPE(ID);
ALTER TABLE WAGEN ADD FOREIGN KEY (REMISE_ID) REFERENCES REMISE(ID);
ALTER TABLE WAGEN ADD FOREIGN KEY (LIJN_ID) REFERENCES LIJN(ID);
ALTER TABLE WAGENTYPE_LIJN ADD FOREIGN KEY (WAGENTYPE_ID) REFERENCES WAGENTYPE(ID);
ALTER TABLE WAGENTYPE_LIJN ADD FOREIGN KEY (LIJN_ID) REFERENCES LIJN(ID);
ALTER TABLE SPOOR ADD FOREIGN KEY (REMISE_ID) REFERENCES REMISE(ID);
ALTER TABLE LIJN_SPOOR ADD FOREIGN KEY (LIJN_ID) REFERENCES LIJN(ID);
ALTER TABLE LIJN_SPOOR ADD FOREIGN KEY (SPOOR_ID) REFERENCES SPOOR(ID);
ALTER TABLE RESERVERING ADD FOREIGN KEY (WAGEN_ID) REFERENCES WAGEN(ID);
ALTER TABLE RESERVERING ADD FOREIGN KEY (SPOOR_ID) REFERENCES SPOOR(ID);
ALTER TABLE SECTOR ADD FOREIGN KEY (WAGEN_ID) REFERENCES WAGEN(ID);
ALTER TABLE SECTOR ADD FOREIGN KEY (SPOOR_ID) REFERENCES SPOOR(ID);

/*
SEQUENCES
Auto-IDs - Let op dat START WITH één groter moet zijn dan de hoogste waarde in de bovenstaande INSERTs voor de tabel.
*/

CREATE SEQUENCE  "SEQ_BEURTID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 5 CACHE 20 NOORDER NOCYCLE;
CREATE SEQUENCE  "SEQ_ACCOUNTID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 6 CACHE 20 NOORDER NOCYCLE;
CREATE SEQUENCE  "SEQ_MELDINGID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;
CREATE SEQUENCE  "SEQ_REMISEID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 3 CACHE 20 NOORDER NOCYCLE;
CREATE SEQUENCE  "SEQ_SPOORID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 42 CACHE 20 NOORDER NOCYCLE;
CREATE SEQUENCE  "SEQ_SECTORID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 169 CACHE 20 NOORDER NOCYCLE;
CREATE SEQUENCE  "SEQ_WAGENID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 125 CACHE 20 NOORDER NOCYCLE;
CREATE SEQUENCE  "SEQ_WAGENTYPEID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 6 CACHE 20 NOORDER NOCYCLE;
CREATE SEQUENCE  "SEQ_LIJNID"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 28 CACHE 20 NOORDER NOCYCLE;

COMMIT;