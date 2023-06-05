from flask import Blueprint, render_template, request, session, redirect, url_for, json
from helper import get_cursor, db_execute, connection_pool, personValidate, get_db

bp_server = Blueprint('server', __name__)


@bp_server.route('/serverSuche')
def serverSuche():
    return render_template('serverSuche.html', warning=0)


@bp_server.route('/serverAnsehen', methods=['GET', 'POST'])
def serverAnsehen():
    if request.method == 'POST':
        name = request.form['name']
        try:
            query = "SELECT server_id, fachverfahren, name, umgebung, laufzeit_server, bereitstellungszeitpunkt, verwendungszweck, typ, netzwerk, ram, cpu, os, speichertyp, ""kapazität"", erreichbarkeit, ""hochverfügbarkeit"", vertraulichkeit, ""verfügbarkeit"", ""integrität"", anmerkungen, zeitpunkt_ins, user_ins, zeitpunkt_upd, user_upd  FROM server WHERE name ~* '" + name + "' ORDER BY name "
            results = db_execute(query)

            if not results:
                return render_template('serverSuche.html', warning=1, name=name)

            server_id, fachverfahren, name, umgebung, laufzeit_server, bereitstellungszeitpunkt, verwendungszweck, typ, netzwerk, ram, cpu, os, speichertyp, kapazität, erreichbarkeit, hochverfügbarkeit, vertraulichkeit, verfügbarkeit, integrität, anmerkungen, zeitpunkt_ins, user_ins, zeitpunkt_upd, user_upd = results[
                0]

            return render_template('serverAnsehen.html', name=name, server_id=server_id, fachverfahren=fachverfahren, umgebung=umgebung, laufzeit_server=laufzeit_server, bereitstellungszeitpunkt=bereitstellungszeitpunkt, verwendungszweck=verwendungszweck, typ=typ, netzwerk=netzwerk, ram=ram, cpu=cpu, os=os, speichertyp=speichertyp, kapazität=kapazität, erreichbarkeit=erreichbarkeit, hochverfügbarkeit=hochverfügbarkeit, vertraulichkeit=vertraulichkeit, verfügbarkeit=verfügbarkeit, integrität=integrität, anmerkungen=anmerkungen, zeitpunkt_ins=zeitpunkt_ins, user_ins=user_ins, zeitpunkt_upd=zeitpunkt_upd, user_upd=user_upd)
        except Exception as e:
            return 'Fehler: ' + str(e)
    else:
        name = request.args.get('name')
        try:
            query = "SELECT server_id, fachverfahren, name, umgebung, laufzeit_server, bereitstellungszeitpunkt, verwendungszweck, typ, netzwerk, ram, cpu, os, speichertyp, ""kapazität"", erreichbarkeit, ""hochverfügbarkeit"", vertraulichkeit, ""verfügbarkeit"", ""integrität"", anmerkungen, zeitpunkt_ins, user_ins, zeitpunkt_upd, user_upd  FROM server WHERE name ~* '" + name + "' ORDER BY name "
            results = db_execute(query)

            if not results:
                return render_template('serverSuche.html', warning=1, name=name)

            server_id, fachverfahren, name, umgebung, laufzeit_server, bereitstellungszeitpunkt, verwendungszweck, typ, netzwerk, ram, cpu, os, speichertyp, kapazität, erreichbarkeit, hochverfügbarkeit, vertraulichkeit, verfügbarkeit, integrität, anmerkungen, zeitpunkt_ins, user_ins, zeitpunkt_upd, user_upd = results[
                0]

            return render_template('serverAnsehen.html', name=name, server_id=server_id, fachverfahren=fachverfahren, umgebung=umgebung, laufzeit_server=laufzeit_server, bereitstellungszeitpunkt=bereitstellungszeitpunkt, verwendungszweck=verwendungszweck, typ=typ, netzwerk=netzwerk, ram=ram, cpu=cpu, os=os, speichertyp=speichertyp, kapazität=kapazität, erreichbarkeit=erreichbarkeit, hochverfügbarkeit=hochverfügbarkeit, vertraulichkeit=vertraulichkeit, verfügbarkeit=verfügbarkeit, integrität=integrität, anmerkungen=anmerkungen, zeitpunkt_ins=zeitpunkt_ins, user_ins=user_ins, zeitpunkt_upd=zeitpunkt_upd, user_upd=user_upd)
        except Exception as e:
            return 'Fehler: ' + str(e)


@bp_server.route('/serverErstellen', methods=['POST'])
def serverErstellen():
    name = request.form['name']
    edit = request.form['edit']
    if edit == '1':
        server_id = request.form['server_id']
        fachverfahren = request.form['fachverfahren']
        umgebung = request.form['umgebung']
        laufzeit_server = request.form['laufzeit_server']
        verwendungszweck = request.form['verwendungszweck']
        typ = request.form['typ']
        netzwerk = request.form['netzwerk']
        ram = request.form['ram']
        cpu = request.form['cpu']
        os = request.form['os']
        speichertyp = request.form['speichertyp']
        kapazität = request.form['kapazität']
        erreichbarkeit = request.form['erreichbarkeit']
        hochverfügbarkeit = request.form['hochverfügbarkeit']
        vertraulichkeit = request.form['vertraulichkeit']
        verfügbarkeit = request.form['verfügbarkeit']
        integrität = request.form['integrität']
        anmerkungen = request.form['anmerkungen']
        # ? wenn auftraggeber, verf_betreuung, kundenmanagement, fachadministration in der person Datenbank vorhanden sind, dann wird das form in die Datenbank fachverfahren geschrieben

        cursor = get_cursor()
        cursor.execute("SELECT cpu FROM auswahl_cpu")
        cpu_options = [row[0] for row in cursor.fetchall()]
            
        cursor.execute("SELECT erreichbarkeit FROM auswahl_erreichbarkeit")
        erreichbarkeit_options = [row[0] for row in cursor.fetchall()]

        cursor.execute("SELECT nic FROM auswahl_nic")
        nic_options = [row[0] for row in cursor.fetchall()]

        cursor.execute("SELECT os FROM auswahl_os")
        os_options = [row[0] for row in cursor.fetchall()]

        cursor.execute("SELECT ram FROM auswahl_ram")
        ram_options = [row[0] for row in cursor.fetchall()]

        cursor.execute("SELECT speicher FROM auswahl_speicher")
        speicher_options = [row[0] for row in cursor.fetchall()]

        cursor.execute("SELECT typ FROM auswahl_typ")
        typ_options = [row[0] for row in cursor.fetchall()]
            
        selected_cpu = cpu if cpu in cpu_options else None

        return render_template('serverAnsehen.html', name=name, server_id=server_id, fachverfahren=fachverfahren, umgebung=umgebung, laufzeit_server=laufzeit_server, verwendungszweck=verwendungszweck, typ=typ, netzwerk=netzwerk, ram=ram, cpu_options=cpu_options, selected_cpu=selected_cpu, os=os, speichertyp=speichertyp, kapazität=kapazität, erreichbarkeit=erreichbarkeit, hochverfügbarkeit=hochverfügbarkeit, vertraulichkeit=vertraulichkeit, verfügbarkeit=verfügbarkeit, integrität=integrität, anmerkungen=anmerkungen, erreichbarkeit_options=erreichbarkeit_options, nic_options=nic_options, os_options=os_options, ram_options=ram_options, speicher_options=speicher_options, typ_options=typ_options)


    else:
        server_id = ''
        fachverfahren = ''
        umgebung = ''
        laufzeit_server = ''
        verwendungszweck = ''
        typ = ''
        netzwerk = ''
        ram = ''
        cpu = ''
        os = ''
        speichertyp = ''
        kapazität = ''
        erreichbarkeit = ''
        hochverfügbarkeit = ''
        vertraulichkeit = ''
        verfügbarkeit = ''
        integrität = ''
        anmerkungen = ''
    try:
        # ? wenn ein fehler bei der validierung auftritt werden die bereits eingetragen daten wieder angezeigt
        return render_template('serverErstellen.html', name=name, server_id=server_id, fachverfahren=fachverfahren, umgebung=umgebung, laufzeit_server=laufzeit_server, verwendungszweck=verwendungszweck, typ=typ, netzwerk=netzwerk, ram=ram, cpu=cpu, os=os, speichertyp=speichertyp, kapazität=kapazität, erreichbarkeit=erreichbarkeit, hochverfügbarkeit=hochverfügbarkeit, vertraulichkeit=vertraulichkeit, verfügbarkeit=verfügbarkeit, integrität=integrität, anmerkungen=anmerkungen)

    except:
        return 'Fehler'


@bp_server.route('/serverEditieren', methods=['POST'])
def serverEditieren():
    name = request.form['name']
    try:
        query = "SELECT server_id, fachverfahren, name, umgebung, laufzeit_server, bereitstellungszeitpunkt, verwendungszweck, typ, netzwerk, ram, cpu, os, speichertyp, kapazität, erreichbarkeit, hochverfügbarkeit, vertraulichkeit, verfügbarkeit, integrität, anmerkungen, zeitpunkt_ins, user_ins, zeitpunkt_upd, user_upd FROM server WHERE name ILIKE %s ORDER BY name"
        results = db_execute(query, (name,))  # Pass the parameter as a tuple

        if results:
            server_id, fachverfahren, name, umgebung, laufzeit_server, bereitstellungszeitpunkt, verwendungszweck, typ, netzwerk, ram, cpu, os, speichertyp, kapazität, erreichbarkeit, hochverfügbarkeit, vertraulichkeit, verfügbarkeit, integrität, anmerkungen, zeitpunkt_ins, user_ins, zeitpunkt_upd, user_upd = results[0]

            # Retrieve available options from the respective "auswahl_" tables
            cursor = get_cursor()
            cursor.execute("SELECT cpu FROM auswahl_cpu")
            cpu_options = [row[0] for row in cursor.fetchall()]
            
            cursor.execute("SELECT erreichbarkeit FROM auswahl_erreichbarkeit")
            erreichbarkeit_options = [row[0] for row in cursor.fetchall()]

            cursor.execute("SELECT nic FROM auswahl_nic")
            nic_options = [row[0] for row in cursor.fetchall()]

            cursor.execute("SELECT os FROM auswahl_os")
            os_options = [row[0] for row in cursor.fetchall()]

            cursor.execute("SELECT ram FROM auswahl_ram")
            ram_options = [row[0] for row in cursor.fetchall()]

            cursor.execute("SELECT speicher FROM auswahl_speicher")
            speicher_options = [row[0] for row in cursor.fetchall()]

            cursor.execute("SELECT typ FROM auswahl_typ")
            typ_options = [row[0] for row in cursor.fetchall()]
            
            selected_cpu = cpu if cpu in cpu_options else None

            return render_template('serverEditieren.html', name=name, server_id=server_id, fachverfahren=fachverfahren, umgebung=umgebung, laufzeit_server=laufzeit_server, bereitstellungszeitpunkt=bereitstellungszeitpunkt, verwendungszweck=verwendungszweck, typ=typ, netzwerk=netzwerk, ram=ram, cpu_options=cpu_options, selected_cpu=selected_cpu, os=os, speichertyp=speichertyp, kapazität=kapazität, erreichbarkeit=erreichbarkeit, hochverfügbarkeit=hochverfügbarkeit, vertraulichkeit=vertraulichkeit, verfügbarkeit=verfügbarkeit, integrität=integrität, anmerkungen=anmerkungen, zeitpunkt_ins=zeitpunkt_ins, user_ins=user_ins, zeitpunkt_upd=zeitpunkt_upd, user_upd=user_upd, erreichbarkeit_options=erreichbarkeit_options, nic_options=nic_options, os_options=os_options, ram_options=ram_options, speicher_options=speicher_options, typ_options=typ_options)

        return 'No results found.'
    except KeyError:
        return 'Bad Request: Missing "name" parameter.'
    except Exception as e:
        return f'Error: {str(e)}'


@bp_server.route('/serverUpdate', methods=['POST'])
def serverUpdate():
    name = request.form['name']
    server_id = request.form['server_id']
    verwendungszweck = request.form['verwendungszweck']
    fachverfahren = request.form['fachverfahren']
    umgebung = request.form['umgebung']
    laufzeit_server = request.form['laufzeit_server']
    bereitstellungszeitpunkt = request.form['bereitstellungszeitpunkt']
    typ = request.form['typ']
    netzwerk = request.form['netzwerk']
    ram = request.form['ram']
    cpu = request.form['cpu']
    os = request.form['os']
    speichertyp = request.form['speichertyp']
    kapazität = request.form['kapazität']
    erreichbarkeit = request.form['erreichbarkeit']
    hochverfügbarkeit = request.form['hochverfügbarkeit']
    vertraulichkeit = request.form['vertraulichkeit']
    verfügbarkeit = request.form['verfügbarkeit']
    integrität = request.form['integrität']
    anmerkungen = request.form['anmerkungen']
    try:
        cursor = get_cursor()
        query = """UPDATE server SET name=%s, server_id=%s, verwendungszweck=%s, fachverfahren=%s, umgebung=%s, 
            laufzeit_server=%s, bereitstellungszeitpunkt=%s, typ=%s, netzwerk=%s, ram=%s, cpu=%s, os=%s, 
            speichertyp=%s, kapazität=%s, erreichbarkeit=%s, hochverfügbarkeit=%s, vertraulichkeit=%s, 
            verfügbarkeit=%s, integrität=%s, anmerkungen=%s WHERE name=%s"""
        cursor.execute(query, (name, server_id, verwendungszweck, fachverfahren, umgebung, laufzeit_server,
                               bereitstellungszeitpunkt, typ, netzwerk, ram, cpu, os, speichertyp, kapazität,
                               erreichbarkeit, hochverfügbarkeit, vertraulichkeit, verfügbarkeit, integrität,
                               anmerkungen, name))
        get_db().commit()
        return redirect(url_for('server.serverAnsehen', name=name))
    except Exception as e:
        return 'Fehler: ' + str(e)


@bp_server.route('/komponenteServer')
def komponenteServer():
    return render_template('komponenteServer.html')
