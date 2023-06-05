drop table server_person cascade;
drop table datenbank cascade;
drop table server cascade;
drop table fachverfahren cascade;
drop table person cascade;
drop table auswahl_cpu cascade;
drop table auswahl_typ cascade;
drop table auswahl_os cascade;
drop table auswahl_nic cascade;
drop table auswahl_server cascade;
drop table auswahl_datenbank cascade;
drop table auswahl_speicher cascade;
drop table auswahl_erreichbarkeit cascade;
drop table auswahl_ram cascade;
drop table auswahl_umgebung cascade;

create or replace function ins_timestamp () returns trigger as
$$
  BEGIN
    NEW.zeitpunkt_ins := now();
    NEW.user_ins := current_user;
    NEW.zeitpunkt_upd := NULL;
    NEW.user_upd := NULL;
    RETURN NEW;
  END
$$ LANGUAGE 'plpgsql';

create or replace function upd_timestamp () returns trigger as
$$
  BEGIN
    NEW.zeitpunkt_upd := now();
    NEW.user_upd := current_user;
    NEW.zeitpunkt_ins := OLD.zeitpunkt_ins;
    NEW.user_ins := OLD.user_ins;
    RETURN NEW;
  END
$$ LANGUAGE 'plpgsql';

create table auswahl_cpu
(
	cpu	varchar PRIMARY KEY
);

create table auswahl_typ
(
	typ	varchar PRIMARY KEY
);

create table auswahl_os
(
	os	varchar PRIMARY KEY
);

create table auswahl_nic(nic text PRIMARY KEY);

CREATE TABLE auswahl_server(
	server	text PRIMARY KEY
);

CREATE TABLE auswahl_datenbank(
	datenbank 	text PRIMARY KEY
	);

create table auswahl_speicher
	 (   speicher text PRIMARY KEY );


create table auswahl_erreichbarkeit
	( erreichbarkeit text PRIMARY KEY );

create table auswahl_ram 
	(ram    text   PRIMARY KEY);

create table auswahl_umgebung (umgebung text primary key);

create table person
	( 
	name		varchar NOT NULL,
	telefonnummer 	varchar,
	dez 		varchar,
	vornam		varchar,
	person_id 	serial PRIMARY KEY,
	zeitpunkt_ins	timestamp,
	user_ins	text,
	zeitpunkt_upd	timestamp,
	user_upd	text
);

create trigger ins_person before insert on person for each row execute procedure ins_timestamp();
create trigger upd_person before update on person for each row execute procedure upd_timestamp();

create table fachverfahren
(
	name                   text,
  	verf_id                text PRIMARY KEY,
	tag                    text,
	vewendungszweck        text,
	laufzeitverfahren      text,
	auftraggeber           integer REFERENCES person ON UPDATE CASCADE,
	verf_betreuung         integer REFERENCES person ON UPDATE CASCADE,
	kundenmanagement       integer REFERENCES person ON UPDATE CASCADE,
	fachadministation      integer REFERENCES person ON UPDATE CASCADE
);


create TABLE server
(
server_id 			serial PRIMARY KEY,
fachverfahren			text NOT NULL REFERENCES fachverfahren ON UPDATE CASCADE,
name				varchar UNIQUE,
umgebung 			text REFERENCES auswahl_umgebung ON UPDATE CASCADE,
laufzeit_Server 		text,
bereitstellungszeitpunkt 	timestamp,
verwendungszweck 		varchar REFERENCES auswahl_server ON UPDATE CASCADE,
typ 				varchar REFERENCES auswahl_typ ON UPDATE CASCADE,
netzwerk		 	varchar REFERENCES auswahl_nic ON UPDATE CASCADE,
ram 				varchar REFERENCES auswahl_ram ON UPDATE CASCADE,
cpu 				varchar REFERENCES auswahl_cpu ON UPDATE CASCADE,
os 				varchar REFERENCES auswahl_os ON UPDATE CASCADE,
speichertyp 			varchar REFERENCES auswahl_speicher ON UPDATE CASCADE,
kapazität 			text,
erreichbarkeit 			varchar REFERENCES auswahl_erreichbarkeit ON UPDATE CASCADE,
"hochverfügbarkeit"		boolean,
vertraulichkeit			text,
"verfügbarkeit"			text,
"integrität"			text,
anmerkungen			text,
zeitpunkt_ins			timestamp,
user_ins			text,
zeitpunkt_upd			timestamp,
user_upd			text
);

create trigger ins_server before insert on server for each row execute procedure ins_timestamp();
create trigger upd_server before update on server for each row execute procedure upd_timestamp();

create table datenbank
(
	name			varchar UNIQUE,
	"clusterlösung"		text,
	instanz			integer,	-- RAM in GB
	"größe"			integer,	-- in GB
	typ			varchar REFERENCES auswahl_datenbank ON UPDATE CASCADE,
	fachverfahren		text NOT NULL REFERENCES fachverfahren ON UPDATE CASCADE,
	server			integer REFERENCES server ON UPDATE CASCADE,
	zeitpunkt_ins		timestamp,
	user_ins		text,
	zeitpunkt_upd		timestamp,
	user_upd		text
);

create trigger ins_datenbank before insert on datenbank for each row execute procedure ins_timestamp();
create trigger upd_datenbank before update on datenbank for each row execute procedure upd_timestamp();

create table server_person
(
	server_id	integer REFERENCES server ON UPDATE CASCADE,
	person_id	integer REFERENCES person ON UPDATE CASCADE
);



create view datenbank_gesamt as
 select fachverfahren.name as verf_name, verf_id, tag as verf_tag, vewendungszweck as verf_verwendungszweck, laufzeitverfahren,
	p_auftr.name as name_auftraggeber, p_auftr.vornam as vornam_auftraggeber, p_auftr.telefonnummer as telefonnummer_auftraggeber, p_auftr.dez as dez_auftraggeber,
	p_betr.name as name_verfahrensbetreuung, p_betr.vornam as vornam_verfahrensbetreuung,
		p_betr.telefonnummer as telefonnummer_verfahrensbetreuung, p_betr.dez as dez_verfahrensbetreuung,
	p_kmgmt.name as name_kundenmanagement, p_kmgmt.vornam as vornam_kundenmanagement,
		p_kmgmt.telefonnummer as telefonnummer_kundenmanagement, p_kmgmt.dez as dez_kundenmanagement,
	p_admin.name as name_fachadministration, p_admin.vornam as vornam_fachadministration,
		p_admin.telefonnummer as telefonnummer_fachadministration, p_admin.dez as dez_fachadministration,
	datenbank.name as db_name, datenbank.typ as db_typ,
	p_user.name as name_user, p_user.vornam as vornam_user,
		p_user.telefonnummer as telefonnummer_user, p_user.dez as dez_user
	from fachverfahren
	left outer join person as p_auftr on auftraggeber=p_auftr.person_id
	left outer join person as p_betr on verf_betreuung=p_betr.person_id
	left outer join person as p_kmgmt on kundenmanagement=p_kmgmt.person_id
	left outer join person as p_admin on fachadministation=p_admin.person_id
	join datenbank on datenbank.fachverfahren=fachverfahren.verf_id
	left outer join server_person on datenbank.server=server_id
	join person as p_user on p_user.person_id=server_person.person_id;


create view server_gesamt as SELECT
fachverfahren.name as fachverfahren_name, tag, verwendungszweck, laufzeitverfahren, kundenmanagement, fachadministation,
server.name as server_name, umgebung, laufzeit_server, bereitstellungszeitpunkt, verwendungszweck as server_verwendungszweck, typ, ram, cpu, netzwerk, os, 
speichertyp, "kapazität", erreichbarkeit, "hochverfügbarkeit", vertraulichkeit, verfügbarkeit, "integrität", anmerkungen, 
person_auftraggeber.name name_auftraggeber, person_auftraggeber.telefonnummer as telefonnummer_auftraggeber, person_auftraggeber.dez as dez_auftraggeber, person_auftraggeber.vornam as vornam_auftraggeber, 
person_kundenmanagement.name as name_kundenmanagement, person_kundenmanagement.telefonnummer as telefonnummer_kundenmanagement, person_kundenmanagement.dez as dez_kundenmanagement, person_kundenmanagement.vornam as vornam_kundenmanagement, 
person_fachadministation.name as name_fachadministation, person_fachadministation.telefonnummer as telefonnummer_fachadministation, person_fachadministation.dez as dez_fachadministation, person_fachadministation.vornam as vornam_fachadministation,
person_verf_betreuung.name as name_betreuung, person_verf_betreuung.telefonnummer as telefonnummer_betreuung, person_verf_betreuung.dez as dez_betreuung, person_verf_betreuung.vornam as vornam_betreuung
FROM fachverfahren 
INNER JOIN server ON server.fachverfahren=fachverfahren.verf_id 
LEFT JOIN person as person_auftraggeber ON fachverfahren.auftraggeber=person_auftraggeber.person_id 
LEFT JOIN person as person_kundenmanagement ON fachverfahren.kundenmanagement=person_kundenmanagement.person_id 
LEFT JOIN person as person_fachadministation ON fachverfahren.fachadministation=person_fachadministation.person_id
LEFT JOIN person as person_verf_betreuung ON fachverfahren.verf_betreuung=person_verf_betreuung.person_id;


create view verfahrenuser as select fachverfahren.name as fachverfahren_name, server.name as server_name, vornam, person.name as personen_name, dez,telefonnummer from server join fachverfahren on verf_id = fachverfahren join server_person using (server_id) join person using (person_id);


create view serveruser as select person.name as personen_name ,vornam ,dez,telefonnummer,server.name as server_name, server_id from server_person join person using (person_id) join server using (server_id); 

----------------------------------------------------------------------------------------------

	insert into auswahl_nic values ('<= 1Gbps');
	insert into auswahl_nic values ('nx 1Gbps');
	insert into auswahl_nic values ('nx 10Gbps');
	insert into auswahl_nic values ('=10Gbps');
	insert into auswahl_nic values ('andere Bandbreite');



INSERT INTO auswahl_server VALUES ('Applikationserver (AP)');
INSERT INTO auswahl_server VALUES ('Citrixserver CX');
INSERT INTO auswahl_server VALUES ('Connectoren (SMB-, NFS-Storagegateways) (CO)');
INSERT INTO auswahl_server VALUES ('Datenbankserver (DB)');
INSERT INTO auswahl_server VALUES ('Domain-Controller (DC)');
INSERT INTO auswahl_server VALUES ('Fileserver (FS)');
INSERT INTO auswahl_server VALUES ('Firewall (FW)');
INSERT INTO auswahl_server VALUES ('Housingsysteme (HQ)');
INSERT INTO auswahl_server VALUES ('Infrastruktursysteme (IS)');
INSERT INTO auswahl_server VALUES ('Load-Balancer (LB)');
INSERT INTO auswahl_server VALUES ('Monitor-/Managementserver (MS)');
INSERT INTO auswahl_server VALUES ('Mailserver (MX)');
INSERT INTO auswahl_server VALUES ('Printserver (PS)');
INSERT INTO auswahl_server VALUES ('Domain-Controller Root-Domain (RD)');
INSERT INTO auswahl_server VALUES ('Terminsalserver');
INSERT INTO auswahl_server VALUES ('Webserver (WE)');


INSERT INTO auswahl_datenbank VALUES ('Informik');
INSERT INTO auswahl_datenbank VALUES ('MSSQL');
INSERT INTO auswahl_datenbank VALUES ('MySQL');
INSERT INTO auswahl_datenbank VALUES ('Oracle');
INSERT INTO auswahl_datenbank VALUES ('PostgreSQL');
INSERT INTO auswahl_datenbank VALUES ('embedded DB');



insert into auswahl_speicher values ('class-A');
insert into auswahl_speicher values ('class-B');
insert into auswahl_speicher values ('class-C');
insert into auswahl_speicher values ('class-D');
insert into auswahl_speicher values ('class-E');
insert into auswahl_speicher values ('class-F');
insert into auswahl_speicher values ('lokale Disk');


	insert into auswahl_erreichbarkeit values  ('Internet(DMZ)');
	insert into auswahl_erreichbarkeit values ('Nur Intern.(Kernnetz)');


	
 insert into auswahl_os values ('Windows Server 2016');
 insert into auswahl_os  values ('Windows Server 2019');
 insert into auswahl_os  values ('Red Hat 8.x');
 insert into auswahl_os  values ('Red Hat 9.x');
 insert into auswahl_os  values ('SLES 12 SP5');
 insert into auswahl_os  values ('SLES 12 SP4');
 insert into auswahl_os  values ('Ubuntu (nur Test)');



INSERT INTO auswahl_ram VALUES ('1 GB');
INSERT INTO auswahl_ram VALUES ('2 GB');
INSERT INTO auswahl_ram VALUES ('4 GB');
INSERT INTO auswahl_ram VALUES ('8 GB');
INSERT INTO auswahl_ram VALUES ('16 GB');
INSERT INTO auswahl_ram VALUES ('32 GB');
INSERT INTO auswahl_ram VALUES ('64 GB');
INSERT INTO auswahl_ram VALUES ('128 GB');
INSERT INTO auswahl_ram VALUES ('256 GB');

insert into auswahl_umgebung values ('physisch');
insert into auswahl_umgebung values ('virtuell');
insert into auswahl_umgebung values ('Container');

INSERT INTO auswahl_cpu VALUES ('1 Core');
INSERT INTO auswahl_cpu VALUES ('2 Core');
INSERT INTO auswahl_cpu VALUES ('4 Core');
INSERT INTO auswahl_cpu VALUES ('8 Core');
INSERT INTO auswahl_cpu VALUES ('>8 Core');
INSERT INTO auswahl_cpu VALUES ('1 vCPU');
INSERT INTO auswahl_cpu VALUES ('2 vCPU');
INSERT INTO auswahl_cpu VALUES ('4 vCPU');
INSERT INTO auswahl_cpu VALUES ('8 vCPU');
INSERT INTO auswahl_cpu VALUES ('>8 vCPU');
