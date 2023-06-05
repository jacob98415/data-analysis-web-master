--
-- PostgreSQL database dump
--

-- Dumped from database version 11.18 (Raspbian 11.18-0+deb10u1)
-- Dumped by pg_dump version 11.18 (Raspbian 11.18-0+deb10u1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: ins_timestamp(); Type: FUNCTION; Schema: public; Owner: helmar
--

CREATE FUNCTION public.ins_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    NEW.zeitpunkt_ins := now();
    NEW.user_ins := current_user;
    NEW.zeitpunkt_upd := NULL;
    NEW.user_upd := NULL;
    RETURN NEW;
  END
$$;


ALTER FUNCTION public.ins_timestamp() OWNER TO helmar;

--
-- Name: upd_timestamp(); Type: FUNCTION; Schema: public; Owner: helmar
--

CREATE FUNCTION public.upd_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    NEW.zeitpunkt_upd := now();
    NEW.user_upd := current_user;
    NEW.zeitpunkt_ins := OLD.zeitpunkt_ins;
    NEW.user_ins := OLD.user_ins;
    RETURN NEW;
  END
$$;


ALTER FUNCTION public.upd_timestamp() OWNER TO helmar;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auswahl_cpu; Type: TABLE; Schema: public; Owner: helmar
--

CREATE TABLE public.auswahl_cpu (
    cpu character varying NOT NULL
);


ALTER TABLE public.auswahl_cpu OWNER TO helmar;

--
-- Name: auswahl_datenbank; Type: TABLE; Schema: public; Owner: helmar
--

CREATE TABLE public.auswahl_datenbank (
    datenbank text NOT NULL
);


ALTER TABLE public.auswahl_datenbank OWNER TO helmar;

--
-- Name: auswahl_erreichbarkeit; Type: TABLE; Schema: public; Owner: helmar
--

CREATE TABLE public.auswahl_erreichbarkeit (
    erreichbarkeit text NOT NULL
);


ALTER TABLE public.auswahl_erreichbarkeit OWNER TO helmar;

--
-- Name: auswahl_nic; Type: TABLE; Schema: public; Owner: helmar
--

CREATE TABLE public.auswahl_nic (
    nic text NOT NULL
);


ALTER TABLE public.auswahl_nic OWNER TO helmar;

--
-- Name: auswahl_os; Type: TABLE; Schema: public; Owner: helmar
--

CREATE TABLE public.auswahl_os (
    os character varying NOT NULL
);


ALTER TABLE public.auswahl_os OWNER TO helmar;

--
-- Name: auswahl_ram; Type: TABLE; Schema: public; Owner: helmar
--

CREATE TABLE public.auswahl_ram (
    ram text NOT NULL
);


ALTER TABLE public.auswahl_ram OWNER TO helmar;

--
-- Name: auswahl_server; Type: TABLE; Schema: public; Owner: helmar
--

CREATE TABLE public.auswahl_server (
    server text NOT NULL
);


ALTER TABLE public.auswahl_server OWNER TO helmar;

--
-- Name: auswahl_speicher; Type: TABLE; Schema: public; Owner: helmar
--

CREATE TABLE public.auswahl_speicher (
    speicher text NOT NULL
);


ALTER TABLE public.auswahl_speicher OWNER TO helmar;

--
-- Name: auswahl_typ; Type: TABLE; Schema: public; Owner: helmar
--

CREATE TABLE public.auswahl_typ (
    typ character varying NOT NULL
);


ALTER TABLE public.auswahl_typ OWNER TO helmar;

--
-- Name: auswahl_umgebung; Type: TABLE; Schema: public; Owner: helmar
--

CREATE TABLE public.auswahl_umgebung (
    umgebung text NOT NULL
);


ALTER TABLE public.auswahl_umgebung OWNER TO helmar;

--
-- Name: datenbank; Type: TABLE; Schema: public; Owner: helmar
--

CREATE TABLE public.datenbank (
    name character varying,
    "clusterlösung" text,
    instanz integer,
    "größe" integer,
    typ character varying,
    fachverfahren text NOT NULL,
    server integer,
    zeitpunkt_ins timestamp without time zone,
    user_ins text,
    zeitpunkt_upd timestamp without time zone,
    user_upd text
);


ALTER TABLE public.datenbank OWNER TO helmar;

--
-- Name: fachverfahren; Type: TABLE; Schema: public; Owner: helmar
--

CREATE TABLE public.fachverfahren (
    name text,
    verf_id text NOT NULL,
    tag text,
    vewendungszweck text,
    laufzeitverfahren text,
    auftraggeber integer,
    verf_betreuung integer,
    kundenmanagement integer,
    fachadministration integer
);


ALTER TABLE public.fachverfahren OWNER TO helmar;

--
-- Name: person; Type: TABLE; Schema: public; Owner: helmar
--

CREATE TABLE public.person (
    name character varying NOT NULL,
    telefonnummer character varying,
    dez character varying,
    vornam character varying,
    person_id integer NOT NULL,
    zeitpunkt_ins timestamp without time zone,
    user_ins text,
    zeitpunkt_upd timestamp without time zone,
    user_upd text
);


ALTER TABLE public.person OWNER TO helmar;

--
-- Name: server_person; Type: TABLE; Schema: public; Owner: helmar
--

CREATE TABLE public.server_person (
    server_id integer,
    person_id integer
);


ALTER TABLE public.server_person OWNER TO helmar;

--
-- Name: datenbank_gesamt; Type: VIEW; Schema: public; Owner: helmar
--

CREATE VIEW public.datenbank_gesamt AS
 SELECT fachverfahren.name AS verf_name,
    fachverfahren.verf_id,
    fachverfahren.tag AS verf_tag,
    fachverfahren.vewendungszweck AS verf_verwendungszweck,
    fachverfahren.laufzeitverfahren,
    p_auftr.name AS name_auftraggeber,
    p_auftr.vornam AS vornam_auftraggeber,
    p_auftr.telefonnummer AS telefonnummer_auftraggeber,
    p_auftr.dez AS dez_auftraggeber,
    p_betr.name AS name_verfahrensbetreuung,
    p_betr.vornam AS vornam_verfahrensbetreuung,
    p_betr.telefonnummer AS telefonnummer_verfahrensbetreuung,
    p_betr.dez AS dez_verfahrensbetreuung,
    p_kmgmt.name AS name_kundenmanagement,
    p_kmgmt.vornam AS vornam_kundenmanagement,
    p_kmgmt.telefonnummer AS telefonnummer_kundenmanagement,
    p_kmgmt.dez AS dez_kundenmanagement,
    p_admin.name AS name_fachadministration,
    p_admin.vornam AS vornam_fachadministration,
    p_admin.telefonnummer AS telefonnummer_fachadministration,
    p_admin.dez AS dez_fachadministration,
    datenbank.name AS db_name,
    datenbank.typ AS db_typ,
    p_user.name AS name_user,
    p_user.vornam AS vornam_user,
    p_user.telefonnummer AS telefonnummer_user,
    p_user.dez AS dez_user
   FROM (((((((public.fachverfahren
     LEFT JOIN public.person p_auftr ON ((fachverfahren.auftraggeber = p_auftr.person_id)))
     LEFT JOIN public.person p_betr ON ((fachverfahren.verf_betreuung = p_betr.person_id)))
     LEFT JOIN public.person p_kmgmt ON ((fachverfahren.kundenmanagement = p_kmgmt.person_id)))
     LEFT JOIN public.person p_admin ON ((fachverfahren.fachadministration = p_admin.person_id)))
     JOIN public.datenbank ON ((datenbank.fachverfahren = fachverfahren.verf_id)))
     LEFT JOIN public.server_person ON ((datenbank.server = server_person.server_id)))
     JOIN public.person p_user ON ((p_user.person_id = server_person.person_id)));


ALTER TABLE public.datenbank_gesamt OWNER TO helmar;

--
-- Name: person_person_id_seq; Type: SEQUENCE; Schema: public; Owner: helmar
--

CREATE SEQUENCE public.person_person_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.person_person_id_seq OWNER TO helmar;

--
-- Name: person_person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helmar
--

ALTER SEQUENCE public.person_person_id_seq OWNED BY public.person.person_id;


--
-- Name: server; Type: TABLE; Schema: public; Owner: helmar
--

CREATE TABLE public.server (
    server_id integer NOT NULL,
    fachverfahren text NOT NULL,
    name character varying,
    umgebung text,
    laufzeit_server text,
    bereitstellungszeitpunkt timestamp without time zone,
    verwendungszweck character varying,
    typ character varying,
    netzwerk character varying,
    ram character varying,
    cpu character varying,
    os character varying,
    speichertyp character varying,
    "kapazität" text,
    erreichbarkeit character varying,
    "hochverfügbarkeit" boolean,
    vertraulichkeit text,
    "verfügbarkeit" text,
    "integrität" text,
    anmerkungen text,
    zeitpunkt_ins timestamp without time zone,
    user_ins text,
    zeitpunkt_upd timestamp without time zone,
    user_upd text
);


ALTER TABLE public.server OWNER TO helmar;

--
-- Name: server_gesamt; Type: VIEW; Schema: public; Owner: helmar
--

CREATE VIEW public.server_gesamt AS
 SELECT fachverfahren.name AS fachverfahren_name,
    fachverfahren.tag,
    server.verwendungszweck,
    fachverfahren.laufzeitverfahren,
    fachverfahren.kundenmanagement,
    fachverfahren.fachadministration AS fachadministation,
    server.name AS server_name,
    server.umgebung,
    server.laufzeit_server,
    server.bereitstellungszeitpunkt,
    server.verwendungszweck AS server_verwendungszweck,
    server.typ,
    server.ram,
    server.cpu,
    server.netzwerk,
    server.os,
    server.speichertyp,
    server."kapazität",
    server.erreichbarkeit,
    server."hochverfügbarkeit",
    server.vertraulichkeit,
    server."verfügbarkeit",
    server."integrität",
    server.anmerkungen,
    person_auftraggeber.name AS name_auftraggeber,
    person_auftraggeber.telefonnummer AS telefonnummer_auftraggeber,
    person_auftraggeber.dez AS dez_auftraggeber,
    person_auftraggeber.vornam AS vornam_auftraggeber,
    person_kundenmanagement.name AS name_kundenmanagement,
    person_kundenmanagement.telefonnummer AS telefonnummer_kundenmanagement,
    person_kundenmanagement.dez AS dez_kundenmanagement,
    person_kundenmanagement.vornam AS vornam_kundenmanagement,
    person_fachadministation.name AS name_fachadministation,
    person_fachadministation.telefonnummer AS telefonnummer_fachadministation,
    person_fachadministation.dez AS dez_fachadministation,
    person_fachadministation.vornam AS vornam_fachadministation,
    person_verf_betreuung.name AS name_betreuung,
    person_verf_betreuung.telefonnummer AS telefonnummer_betreuung,
    person_verf_betreuung.dez AS dez_betreuung,
    person_verf_betreuung.vornam AS vornam_betreuung
   FROM (((((public.fachverfahren
     JOIN public.server ON ((server.fachverfahren = fachverfahren.verf_id)))
     LEFT JOIN public.person person_auftraggeber ON ((fachverfahren.auftraggeber = person_auftraggeber.person_id)))
     LEFT JOIN public.person person_kundenmanagement ON ((fachverfahren.kundenmanagement = person_kundenmanagement.person_id)))
     LEFT JOIN public.person person_fachadministation ON ((fachverfahren.fachadministration = person_fachadministation.person_id)))
     LEFT JOIN public.person person_verf_betreuung ON ((fachverfahren.verf_betreuung = person_verf_betreuung.person_id)));


ALTER TABLE public.server_gesamt OWNER TO helmar;

--
-- Name: server_server_id_seq; Type: SEQUENCE; Schema: public; Owner: helmar
--

CREATE SEQUENCE public.server_server_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.server_server_id_seq OWNER TO helmar;

--
-- Name: server_server_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: helmar
--

ALTER SEQUENCE public.server_server_id_seq OWNED BY public.server.server_id;


--
-- Name: serveruser; Type: VIEW; Schema: public; Owner: helmar
--

CREATE VIEW public.serveruser AS
 SELECT person.name AS personen_name,
    person.vornam,
    person.dez,
    person.telefonnummer,
    server.name AS server_name,
    server_person.server_id
   FROM ((public.server_person
     JOIN public.person USING (person_id))
     JOIN public.server USING (server_id));


ALTER TABLE public.serveruser OWNER TO helmar;

--
-- Name: verfahrenuser; Type: VIEW; Schema: public; Owner: helmar
--

CREATE VIEW public.verfahrenuser AS
 SELECT fachverfahren.name AS fachverfahren_name,
    server.name AS server_name,
    person.vornam,
    person.name AS personen_name,
    person.dez,
    person.telefonnummer
   FROM (((public.server
     JOIN public.fachverfahren ON ((fachverfahren.verf_id = server.fachverfahren)))
     JOIN public.server_person USING (server_id))
     JOIN public.person USING (person_id));


ALTER TABLE public.verfahrenuser OWNER TO helmar;

--
-- Name: person person_id; Type: DEFAULT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.person ALTER COLUMN person_id SET DEFAULT nextval('public.person_person_id_seq'::regclass);


--
-- Name: server server_id; Type: DEFAULT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.server ALTER COLUMN server_id SET DEFAULT nextval('public.server_server_id_seq'::regclass);


--
-- Data for Name: auswahl_cpu; Type: TABLE DATA; Schema: public; Owner: helmar
--

COPY public.auswahl_cpu (cpu) FROM stdin;
1 Core
2 Core
4 Core
8 Core
>8 Core
1 vCPU
2 vCPU
4 vCPU
8 vCPU
>8 vCPU
\.


--
-- Data for Name: auswahl_datenbank; Type: TABLE DATA; Schema: public; Owner: helmar
--

COPY public.auswahl_datenbank (datenbank) FROM stdin;
MSSQL
MySQL
Oracle
PostgreSQL
embedded DB
Informix
\.


--
-- Data for Name: auswahl_erreichbarkeit; Type: TABLE DATA; Schema: public; Owner: helmar
--

COPY public.auswahl_erreichbarkeit (erreichbarkeit) FROM stdin;
Internet(DMZ)
Nur Intern.(Kernnetz)
\.


--
-- Data for Name: auswahl_nic; Type: TABLE DATA; Schema: public; Owner: helmar
--

COPY public.auswahl_nic (nic) FROM stdin;
<= 1Gbps
nx 1Gbps
nx 10Gbps
=10Gbps
andere Bandbreite
\.


--
-- Data for Name: auswahl_os; Type: TABLE DATA; Schema: public; Owner: helmar
--

COPY public.auswahl_os (os) FROM stdin;
Windows Server 2016
Windows Server 2019
Red Hat 8.x
Red Hat 9.x
SLES 12 SP5
SLES 12 SP4
Ubuntu (nur Test)
\.


--
-- Data for Name: auswahl_ram; Type: TABLE DATA; Schema: public; Owner: helmar
--

COPY public.auswahl_ram (ram) FROM stdin;
1 GB
2 GB
4 GB
8 GB
16 GB
32 GB
64 GB
128 GB
256 GB
\.


--
-- Data for Name: auswahl_server; Type: TABLE DATA; Schema: public; Owner: helmar
--

COPY public.auswahl_server (server) FROM stdin;
Applikationserver (AP)
Citrixserver CX
Connectoren (SMB-, NFS-Storagegateways) (CO)
Datenbankserver (DB)
Domain-Controller (DC)
Fileserver (FS)
Firewall (FW)
Housingsysteme (HQ)
Infrastruktursysteme (IS)
Load-Balancer (LB)
Monitor-/Managementserver (MS)
Mailserver (MX)
Printserver (PS)
Domain-Controller Root-Domain (RD)
Terminsalserver
Webserver (WE)
\.


--
-- Data for Name: auswahl_speicher; Type: TABLE DATA; Schema: public; Owner: helmar
--

COPY public.auswahl_speicher (speicher) FROM stdin;
class-A
class-B
class-C
class-D
class-E
class-F
lokale Disk
\.


--
-- Data for Name: auswahl_typ; Type: TABLE DATA; Schema: public; Owner: helmar
--

COPY public.auswahl_typ (typ) FROM stdin;
physisch
virtuell
container
\.


--
-- Data for Name: auswahl_umgebung; Type: TABLE DATA; Schema: public; Owner: helmar
--

COPY public.auswahl_umgebung (umgebung) FROM stdin;
physisch
virtuell
Container
\.


--
-- Data for Name: datenbank; Type: TABLE DATA; Schema: public; Owner: helmar
--

COPY public.datenbank (name, "clusterlösung", instanz, "größe", typ, fachverfahren, server, zeitpunkt_ins, user_ins, zeitpunkt_upd, user_upd) FROM stdin;
DB-4711	n	12	250	PostgreSQL	471123	1	2022-11-10 20:54:24.279295	helmar	2023-05-15 12:57:55.643059	helmar
nö	brauche wir nicht	66	666	Informix	333	3	2022-11-11 00:28:06.261737	lukas	2023-05-17 11:10:36.208994	helmar
\.


--
-- Data for Name: fachverfahren; Type: TABLE DATA; Schema: public; Owner: helmar
--

COPY public.fachverfahren (name, verf_id, tag, vewendungszweck, laufzeitverfahren, auftraggeber, verf_betreuung, kundenmanagement, fachadministration) FROM stdin;
dertest	333	trt	zum testen	55 sek.	5	3	3	4
test	4444	hhh	das ist ein test	54 Jahre	1	3	6	7
Test244	4712	T-2	auch Test	10 Jahre	3	1	1	1
BananaTest2344	234	T2	324	234	4	2	4	6
sdfg	sdfg	fgn	sdfg	sdfg	1	1	1	1
Test3	123	T3	Zum Testen	7 Tage	2	3	4	2
IrgendEIn Name	2345	T23	nutzlos	6 monate	2	2	2	2
Test 6	87345	T6	kfjdgj	df.gjhdf	6	5	4	2
ewt	234432	g34	wer	wer	1	1	1	1
wre	fe	Tfgh	fe	wre	1	1	1	1
de	67	Tfgd	sda	sda	1	1	1	1
rr	rr	fffff	rr	rr	1	1	1	1
Test4	213	T4	Test4 für leon	7sec	2	2	2	1
fasdfdf	sfsfsadf	12345	sfdfasd	fasdfsad	1	3	4	2
Test741	aaaaaaaaaa	T11	aaaaaaaaaa	aaaaaaaaa	1	1	1	1
Leon	aaaaaaaa	LK	aaaaaaaa	aaaaaaaaaa	1	1	1	1
äö	#äö#äö	äöü?#	ä#öö	#öüö	1	1	1	1
Banenanatest	471123	T1	ein Test mit Banana	1 Jahr	5	4	4	2
saddadad	ersd	bruh	aaaa	aaaaaaaa	5	4	5	2
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: helmar
--

COPY public.person (name, telefonnummer, dez, vornam, person_id, zeitpunkt_ins, user_ins, zeitpunkt_upd, user_upd) FROM stdin;
Friedrich	123456	2.5	Ernst	2	2022-11-10 20:53:55.375626	helmar	\N	\N
ines	0331...	2.7	valentina\b	5	2022-11-11 00:23:28.71645	lukas	\N	\N
ttt	0331.	2.5	ttt	7	2022-11-11 01:17:34.162773	lukas	\N	\N
Peter	0331....	2.6	Lukas	4	2022-11-11 00:23:04.840872	lukas	2023-05-16 11:23:45.982844	postgres
Peter	0331....	2.6	Lukas	6	2022-11-11 01:17:05.281641	lukas	2023-05-16 11:23:45.982844	postgres
Maurich	1234567	1.5	Gerlinde	3	2022-11-10 21:03:26.490883	helmar	2023-05-16 11:50:48.84955	postgres
Vierstein	123456	2.1	Albert	1	2022-11-10 20:50:04.074879	helmar	2023-05-16 13:06:20.032252	postgres
Friedrich	123456	2.5	Ernst	8	2023-05-16 13:56:33.42085	postgres	\N	\N
asdasd				9	2023-05-16 14:05:35.753602	postgres	\N	\N
aad				10	2023-05-16 14:05:37.201886	postgres	\N	\N
aad				11	2023-05-16 14:05:49.703127	postgres	\N	\N
aad				12	2023-05-16 14:06:25.108132	postgres	\N	\N
adadadasda				13	2023-05-16 14:06:29.678696	postgres	\N	\N
sdad				14	2023-05-16 14:06:30.743731	postgres	\N	\N
ddddd				15	2023-05-16 14:07:22.117644	postgres	\N	\N
adasdasd				16	2023-05-16 14:11:05.900863	postgres	\N	\N
adasdasd				17	2023-05-16 14:11:25.287622	postgres	\N	\N
sssss				18	2023-05-16 14:12:30.095513	postgres	\N	\N
Klaus	0987654321	3.4	Klaus	19	2023-05-16 14:24:04.670643	postgres	\N	\N
Möppel	Uff	9.9.9.9	Lollo	20	2023-05-16 14:26:58.870936	postgres	\N	\N
Fünfstein	123456	2.1	Albert	21	2023-05-17 08:11:37.056621	postgres	\N	\N
Peter	019274^	5.5	Klaus	22	2023-05-17 08:12:05.994327	postgres	\N	\N
aad	5464352524			23	2023-05-17 08:36:02.017364	postgres	\N	\N
lEOMN	§&%"§"§%	Dez 66	Leon	24	2023-05-17 08:36:26.905985	postgres	\N	\N
aad				25	2023-05-17 10:05:14.634919	postgres	\N	\N
aad				26	2023-05-17 10:07:22.784292	postgres	\N	\N
Peter-Schlägel				27	2023-05-17 10:09:10.147042	postgres	\N	\N
Peter-Schlägel				28	2023-05-17 10:09:14.307568	postgres	\N	\N
aad				29	2023-05-17 10:09:41.471091	postgres	\N	\N
Fünfstein	547443636241	2.1	Albert	30	2023-05-17 11:58:39.633587	postgres	\N	\N
\.


--
-- Data for Name: server; Type: TABLE DATA; Schema: public; Owner: helmar
--

COPY public.server (server_id, fachverfahren, name, umgebung, laufzeit_server, bereitstellungszeitpunkt, verwendungszweck, typ, netzwerk, ram, cpu, os, speichertyp, "kapazität", erreichbarkeit, "hochverfügbarkeit", vertraulichkeit, "verfügbarkeit", "integrität", anmerkungen, zeitpunkt_ins, user_ins, zeitpunkt_upd, user_upd) FROM stdin;
3	333	beap044	virtuell	3000 Jahre	2001-02-03 00:00:00	Applikationserver (AP)	physisch	andere Bandbreite	256 GB	4 Core	Windows Server 2019	class-A	555gb	Nur Intern.(Kernnetz)	t	niedrig	hoch	kein plan	mäßig	2022-11-11 00:26:38.366717	lukas	2023-05-17 12:13:27.306193	postgres
1	471123	beap-00188-091	virtuell	1 Jahr	2022-10-10 00:00:00	Applikationserver (AP)	container	<= 1Gbps	32 GB	4 vCPU	SLES 12 SP5	class-A	12 GB	Nur Intern.(Kernnetz)	f	hoch	hoch	-	keine weiteren Anmerkungen	2022-11-10 20:53:13.198074	helmar	2023-05-17 12:06:46.533599	postgres
\.


--
-- Data for Name: server_person; Type: TABLE DATA; Schema: public; Owner: helmar
--

COPY public.server_person (server_id, person_id) FROM stdin;
1	2
3	3
\.


--
-- Name: person_person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helmar
--

SELECT pg_catalog.setval('public.person_person_id_seq', 30, true);


--
-- Name: server_server_id_seq; Type: SEQUENCE SET; Schema: public; Owner: helmar
--

SELECT pg_catalog.setval('public.server_server_id_seq', 2, true);


--
-- Name: auswahl_cpu auswahl_cpu_pkey; Type: CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.auswahl_cpu
    ADD CONSTRAINT auswahl_cpu_pkey PRIMARY KEY (cpu);


--
-- Name: auswahl_datenbank auswahl_datenbank_pkey; Type: CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.auswahl_datenbank
    ADD CONSTRAINT auswahl_datenbank_pkey PRIMARY KEY (datenbank);


--
-- Name: auswahl_erreichbarkeit auswahl_erreichbarkeit_pkey; Type: CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.auswahl_erreichbarkeit
    ADD CONSTRAINT auswahl_erreichbarkeit_pkey PRIMARY KEY (erreichbarkeit);


--
-- Name: auswahl_nic auswahl_nic_pkey; Type: CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.auswahl_nic
    ADD CONSTRAINT auswahl_nic_pkey PRIMARY KEY (nic);


--
-- Name: auswahl_os auswahl_os_pkey; Type: CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.auswahl_os
    ADD CONSTRAINT auswahl_os_pkey PRIMARY KEY (os);


--
-- Name: auswahl_ram auswahl_ram_pkey; Type: CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.auswahl_ram
    ADD CONSTRAINT auswahl_ram_pkey PRIMARY KEY (ram);


--
-- Name: auswahl_server auswahl_server_pkey; Type: CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.auswahl_server
    ADD CONSTRAINT auswahl_server_pkey PRIMARY KEY (server);


--
-- Name: auswahl_speicher auswahl_speicher_pkey; Type: CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.auswahl_speicher
    ADD CONSTRAINT auswahl_speicher_pkey PRIMARY KEY (speicher);


--
-- Name: auswahl_typ auswahl_typ_pkey; Type: CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.auswahl_typ
    ADD CONSTRAINT auswahl_typ_pkey PRIMARY KEY (typ);


--
-- Name: auswahl_umgebung auswahl_umgebung_pkey; Type: CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.auswahl_umgebung
    ADD CONSTRAINT auswahl_umgebung_pkey PRIMARY KEY (umgebung);


--
-- Name: datenbank datenbank_name_key; Type: CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.datenbank
    ADD CONSTRAINT datenbank_name_key UNIQUE (name);


--
-- Name: fachverfahren fachverfahren_pkey; Type: CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.fachverfahren
    ADD CONSTRAINT fachverfahren_pkey PRIMARY KEY (verf_id);


--
-- Name: person person_pkey; Type: CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (person_id);


--
-- Name: server server_name_key; Type: CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.server
    ADD CONSTRAINT server_name_key UNIQUE (name);


--
-- Name: server server_pkey; Type: CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.server
    ADD CONSTRAINT server_pkey PRIMARY KEY (server_id);


--
-- Name: datenbank ins_datenbank; Type: TRIGGER; Schema: public; Owner: helmar
--

CREATE TRIGGER ins_datenbank BEFORE INSERT ON public.datenbank FOR EACH ROW EXECUTE PROCEDURE public.ins_timestamp();


--
-- Name: person ins_person; Type: TRIGGER; Schema: public; Owner: helmar
--

CREATE TRIGGER ins_person BEFORE INSERT ON public.person FOR EACH ROW EXECUTE PROCEDURE public.ins_timestamp();


--
-- Name: server ins_server; Type: TRIGGER; Schema: public; Owner: helmar
--

CREATE TRIGGER ins_server BEFORE INSERT ON public.server FOR EACH ROW EXECUTE PROCEDURE public.ins_timestamp();


--
-- Name: datenbank upd_datenbank; Type: TRIGGER; Schema: public; Owner: helmar
--

CREATE TRIGGER upd_datenbank BEFORE UPDATE ON public.datenbank FOR EACH ROW EXECUTE PROCEDURE public.upd_timestamp();


--
-- Name: person upd_person; Type: TRIGGER; Schema: public; Owner: helmar
--

CREATE TRIGGER upd_person BEFORE UPDATE ON public.person FOR EACH ROW EXECUTE PROCEDURE public.upd_timestamp();


--
-- Name: server upd_server; Type: TRIGGER; Schema: public; Owner: helmar
--

CREATE TRIGGER upd_server BEFORE UPDATE ON public.server FOR EACH ROW EXECUTE PROCEDURE public.upd_timestamp();


--
-- Name: datenbank datenbank_fachverfahren_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.datenbank
    ADD CONSTRAINT datenbank_fachverfahren_fkey FOREIGN KEY (fachverfahren) REFERENCES public.fachverfahren(verf_id) ON UPDATE CASCADE;


--
-- Name: datenbank datenbank_server_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.datenbank
    ADD CONSTRAINT datenbank_server_fkey FOREIGN KEY (server) REFERENCES public.server(server_id) ON UPDATE CASCADE;


--
-- Name: datenbank datenbank_typ_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.datenbank
    ADD CONSTRAINT datenbank_typ_fkey FOREIGN KEY (typ) REFERENCES public.auswahl_datenbank(datenbank) ON UPDATE CASCADE;


--
-- Name: fachverfahren fachverfahren_auftraggeber_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.fachverfahren
    ADD CONSTRAINT fachverfahren_auftraggeber_fkey FOREIGN KEY (auftraggeber) REFERENCES public.person(person_id) ON UPDATE CASCADE;


--
-- Name: fachverfahren fachverfahren_fachadministation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.fachverfahren
    ADD CONSTRAINT fachverfahren_fachadministation_fkey FOREIGN KEY (fachadministration) REFERENCES public.person(person_id) ON UPDATE CASCADE;


--
-- Name: fachverfahren fachverfahren_kundenmanagement_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.fachverfahren
    ADD CONSTRAINT fachverfahren_kundenmanagement_fkey FOREIGN KEY (kundenmanagement) REFERENCES public.person(person_id) ON UPDATE CASCADE;


--
-- Name: fachverfahren fachverfahren_verf_betreuung_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.fachverfahren
    ADD CONSTRAINT fachverfahren_verf_betreuung_fkey FOREIGN KEY (verf_betreuung) REFERENCES public.person(person_id) ON UPDATE CASCADE;


--
-- Name: server server_cpu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.server
    ADD CONSTRAINT server_cpu_fkey FOREIGN KEY (cpu) REFERENCES public.auswahl_cpu(cpu) ON UPDATE CASCADE;


--
-- Name: server server_erreichbarkeit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.server
    ADD CONSTRAINT server_erreichbarkeit_fkey FOREIGN KEY (erreichbarkeit) REFERENCES public.auswahl_erreichbarkeit(erreichbarkeit) ON UPDATE CASCADE;


--
-- Name: server server_fachverfahren_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.server
    ADD CONSTRAINT server_fachverfahren_fkey FOREIGN KEY (fachverfahren) REFERENCES public.fachverfahren(verf_id) ON UPDATE CASCADE;


--
-- Name: server server_netzwerk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.server
    ADD CONSTRAINT server_netzwerk_fkey FOREIGN KEY (netzwerk) REFERENCES public.auswahl_nic(nic) ON UPDATE CASCADE;


--
-- Name: server server_os_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.server
    ADD CONSTRAINT server_os_fkey FOREIGN KEY (os) REFERENCES public.auswahl_os(os) ON UPDATE CASCADE;


--
-- Name: server_person server_person_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.server_person
    ADD CONSTRAINT server_person_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(person_id) ON UPDATE CASCADE;


--
-- Name: server_person server_person_server_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.server_person
    ADD CONSTRAINT server_person_server_id_fkey FOREIGN KEY (server_id) REFERENCES public.server(server_id) ON UPDATE CASCADE;


--
-- Name: server server_ram_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.server
    ADD CONSTRAINT server_ram_fkey FOREIGN KEY (ram) REFERENCES public.auswahl_ram(ram) ON UPDATE CASCADE;


--
-- Name: server server_speichertyp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.server
    ADD CONSTRAINT server_speichertyp_fkey FOREIGN KEY (speichertyp) REFERENCES public.auswahl_speicher(speicher) ON UPDATE CASCADE;


--
-- Name: server server_typ_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.server
    ADD CONSTRAINT server_typ_fkey FOREIGN KEY (typ) REFERENCES public.auswahl_typ(typ) ON UPDATE CASCADE;


--
-- Name: server server_umgebung_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.server
    ADD CONSTRAINT server_umgebung_fkey FOREIGN KEY (umgebung) REFERENCES public.auswahl_umgebung(umgebung) ON UPDATE CASCADE;


--
-- Name: server server_verwendungszweck_fkey; Type: FK CONSTRAINT; Schema: public; Owner: helmar
--

ALTER TABLE ONLY public.server
    ADD CONSTRAINT server_verwendungszweck_fkey FOREIGN KEY (verwendungszweck) REFERENCES public.auswahl_server(server) ON UPDATE CASCADE;


--
-- PostgreSQL database dump complete
--

