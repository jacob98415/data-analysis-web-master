#!/bin/bash
personenabfrage()
{
	while true; do
		read -p "Name $2 > " NAME
		read -p "Vorname $2 > " VNAME
		AUSGB=$(psql $1 -qAtc "SELECT name||COALESCE(', '||vornam,'')||'; Dez. '||dez||', Tel: '||telefonnummer FROM person where name ~* '$NAME' and vornam ~* '$VNAME' LIMIT 1;")
		if [ x"$AUSGB" == 'x' ]; then
			echo "Es konnte niemand gefunden werden - bitte Person neu anlegen"
			read -p "Name > " NAME
			read -p "Vorname > " VNAME
			read -p "Dezernat > " DEZ
			read -p "Telefon > " TEL
			return $(psql $1 -qAtc "INSERT INTO person (name,vornam,dez,telefonnummer) VALUES ('$NAME','$VNAME','$DEZ','$TEL') RETURNING person_id;")
		else
			read -p "gefunden wurde $AUSGB - ist das richtig? [j/n] > "
			if [ x$REPLY == 'xj' ]; then
				return $(psql $1 -qAtc "SELECT person_id FROM person WHERE name ~* '$NAME' and vornam ~* '$VNAME' LIMIT 1;")
			fi
		fi
	done
}

read -s -p "Bitte Passwort eingeben > "
CONN="postgresql://$USER:$REPLY@10.128.201.127/statzy"

echo
psql $CONN -c "SELECT count(*) FROM person;" > /dev/null
if [ $? -ne 0 ]; then
	echo Abbruch....
	exit 1
fi

#*********************************** Lukas *****************************************************
echo
echo "Fachverfahren"
while true; do
	read -p "Verfahrens-ID > " VERF
	VNAME=$(psql $CONN -qAtc "SELECT name FROM fachverfahren WHERE verf_id='$VERF';")
	if [ "x$VNAME" == "x" ]; then
		echo "Das Verfahren ist noch nicht bekannt, es muss neu angelegt werden"
                read -p "Verfahrensname > " VFNAME
                read -p "Tag (Kurzname) > " TAG
                read -p "Verwendungszweck > " ZWECK
                read -p "Voraussichtliche Laufzeit > " LZV
		personenabfrage $CONN Kundenmanager
		kundenmanagement=$?
		personenabfrage $CONN Fachadministrator
		fachadministration=$?
		personenabfrage $CONN Auftraggeber 
		auftraggeber=$?
		personenabfrage $CONN Verfahrensbetreuer
		verfahrensbetreuer=$?

        psql $CONN -qAtc "INSERT INTO Fachverfahren (Verf_id,Name,Tag,Vewendungszweck,Laufzeitverfahren,kundenmanagement,fachadministation,auftraggeber,verf_betreuung) VALUES ('$VERF','$VFNAME','$TAG','$ZWECK','$LZV','$kundenmanagement','$fachadministration','$auftraggeber','$verfahrensbetreuer')"

		break
	else
		read -p "Es gibt das Verfahren \"$VNAME\", ist dieses gemeint? [j/n] > "
		if [ "x$REPLY" == "xj" ]; then break; fi
	fi
done
#************************************* Ende Lukas ****************************************************
	MITSERVER=j
	SERV_ID='NULL'
	read -p "Ist eine Datenbank vorhanden? [j/n] > " MITDATENBANK
	if [ "x$MITDATENBANK" == "xj" ];then
	read -p "Läuft die Datenbank auf einem eigenen Server? [j/n] > " MITSERVER
	fi
#************************************* Martin ********************************************************
if [ "x$MITSERVER" == "xj" ];then
echo
echo "Serverdaten"
#while true; do


        read -p "Name des Servers > " NAME

	echo "Bitte Umgebung auswählen (Zahl eingeben)"
	echo
	mapfile -t OSS < <(psql $CONN -qAtc "SELECT umgebung FROM auswahl_umgebung;")
	select UMGEBUNG in "${OSS[@]}"; do break; done
	echo $OS


        read -p "Voraussichtliche Laufzeit > " LAUFZEIT


        read -p "Bereitstellungszeitpunkt > " BEREITZEIT


        echo "Bitte Servertyp auswählen (Zahl eingeben)"
        echo
        mapfile -t OSS < <(psql $CONN -qAtc "SELECT server FROM auswahl_server;")
        select server in "${OSS[@]}"; do break; done
        echo $OS

	echo "Bitte Netzwerktyp auswählen > "
        echo
        mapfile -t OSS < <(psql $CONN -qAtc "SELECT nic FROM auswahl_nic;")
        select NIC in "${OSS[@]}"; do break; done
        echo $NIC

        echo "Bitte RAM auswählen (Zahl eingeben)"
        echo
        mapfile -t OSS < <(psql $CONN -qAtc "SELECT ram FROM auswahl_ram;")
        select ram in "${OSS[@]}"; do break; done
        echo $OS


	echo "Bitte CPU auswählen > "
        echo
        mapfile -t OSS < <(psql $CONN -qAtc "SELECT cpu FROM auswahl_cpu;")
        select CPU in "${OSS[@]}"; do break; done
        echo $OS


        echo "Bitte Betriebssystem auswählen (Zahl eingeben)"
        echo
        mapfile -t OSS < <(psql $CONN -qAtc "SELECT os FROM auswahl_os;")
        select OS in "${OSS[@]}"; do break; done
        echo $OS


        echo "Bitte die Nummer des Festplattentyps auswählen > "
        echo
        mapfile -t OSS < <(psql $CONN -qAtc "SELECT speicher FROM auswahl_speicher;")
        select SPEICHERTYP in "${OSS[@]}"; do break; done
        echo $OS


        read -p "Bitte die Größe der Festplatte angeben > " Kappa


        echo "Bitte Erreichbarkeit auswählen (Zahl eingeben)"
        echo
        mapfile -t OSS < <(psql $CONN -qAtc "SELECT erreichbarkeit FROM auswahl_erreichbarkeit;")
        select ERREICHBARKEIT in "${OSS[@]}"; do break; done
        echo $OS


        


	read -p "Hochverfügbar?[j/n] > "
	HOCHVERFUEGBARKEIT="false"
	if [ "x$REPLY" == "xj" ]; then HOCHVERFUEGBARKEIT="true"; fi
	read -p "Vertraulichkeit > " VERTRAULICHKEIT
        read -p "Verfügbarkeit > " VERFUEGBARKEIT
        read -p "Integrität > " INTEGRITAET
        read -p "Anmerkung > " ANMERKUNG

	SERV_ID=$(psql $CONN -qAtc "INSERT INTO Server (name,fachverfahren,umgebung,laufzeit_server,bereitstellungszeitpunkt,verwendungszweck,netzwerk,ram,cpu,os,speichertyp,\"kapazität\",erreichbarkeit,\"hochverfügbarkeit\",vertraulichkeit,\"verfügbarkeit\",\"integrität\",anmerkungen) VALUES ('$NAME','$VERF','$UMGEBUNG','$LAUFZEIT','$BEREITZEIT','$server','$NIC','$ram','$CPU','$OS','$SPEICHERTYP','$Kappa','$ERREICHBARKEIT','$HOCHVERFUEGBARKEIT','$VERTRAULICHKEIT','$VERFUEGBARKEIT','$INTEGRITAET','$ANMERKUNG') RETURNING server_id;")
#********************************** Ende Martin *****************************************************

#******************************** Tanja *************************************************************

	read -p "Sollen User hinzugefügt werden? [j/n] > "

let I=1
while [ "x$REPLY" == "xj" ];
	do
                personenabfrage $CONN "$I. User"
                Serveruser=$?
		psql $CONN -qAtc "INSERT INTO server_person (server_id, person_id) VALUES ($SERV_ID,$Serveruser);"
	read -p " Weitere User? [j/n] > "
done
fi





if [ "x$MITDATENBANK" == "xj" ];then
echo
echo "Datenbank"

	read -p "Clusterlösung > " CLU
	read -p "Name der Datenbank > " DBNAM

echo "Bitte wählen Sie eine Datenbank aus > "
echo
mapfile -t DBS < <(psql $CONN -qAtc "SELECT Datenbank FROM auswahl_datenbank;")
select DB in "${DBS[@]}"; do break; done
echo $DB
	read -p "Größe der Instanz in GB (Zahl) > " INSZ
	read -p "Größe der Datenbank in GB (Zahl) > " VOL
	psql $CONN -qAtc "INSERT INTO datenbank (name,\"clusterlösung\",instanz,\"größe\",typ,fachverfahren,server) VALUES ('$DBNAM','$CLU','$INSZ', '$VOL', '$DB', '$VERF', $SERV_ID);"
fi
#******************************** Ende Tanja ********************************************************
exit 
