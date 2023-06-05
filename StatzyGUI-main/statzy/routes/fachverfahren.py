from flask import Blueprint, render_template, request, redirect, url_for, session, g
from helper import db_execute, personIdToName, connection_pool, get_cursor, get_db, personValidate, personIdToName

bp_fachverfahren = Blueprint('fachverfahren', __name__)


@bp_fachverfahren.route('/fachverfahrenSuche')
def fachverfahrenSuche():
    return render_template('fachverfahrenSuche.html', warning=0)


@bp_fachverfahren.route('/fachverfahrenAnsehen', methods=['GET', 'POST'])
def fachverfahrenAnsehen():
    # ? Wenn die Methode POST ist, wird der Tag aus dem Formular genommen
    if request.method == 'POST':
        tag = request.form['tag']
        try:
            query = "SELECT name, verf_id, tag, vewendungszweck, laufzeitverfahren, auftraggeber, verf_betreuung, kundenmanagement, fachadministration FROM fachverfahren WHERE tag ~* '" + tag + "' ORDER BY name "
            results = db_execute(query)

            if not results:
                return render_template('fachverfahrenSuche.html', warning=1, tag=tag)

            name, verf_id, tag, vewendungszweck, laufzeitverfahren, auftraggeber, verf_betreuung, kundenmanagement, fachadministration = results[
                0]
            # ? Die ID's werden in Namen umgewandelt um sie anzuzeigen | die ids der Personen werden trotzdem in der Session gespeichert
            idAuftraggeber = auftraggeber
            idVerfBetreuung = verf_betreuung
            idKundenmanagement = kundenmanagement
            idFachadministration = fachadministration
            auftraggeber = personIdToName(auftraggeber)
            verf_betreuung = personIdToName(verf_betreuung)
            kundenmanagement = personIdToName(kundenmanagement)
            fachadministration = personIdToName(fachadministration)

            return render_template('fachverfahrenAnsehen.html', name=name, verf_id=verf_id, tag=tag, vewendungszweck=vewendungszweck, laufzeitverfahren=laufzeitverfahren, auftraggeber=auftraggeber, verf_betreuung=verf_betreuung, kundenmanagement=kundenmanagement, fachadministration=fachadministration, idAuftraggeber=idAuftraggeber, idVerfBetreuung=idVerfBetreuung, idKundenmanagement=idKundenmanagement, idFachadministration=idFachadministration)
        except Exception as e:
            return 'Fehler' + str(e)
    # ? Wenn die Methode GET ist, wird der Tag aus der URL genommen
    else:
        tag = request.args.get('tag')
        try:
            query = "SELECT name, verf_id, tag, vewendungszweck, laufzeitverfahren, auftraggeber, verf_betreuung, kundenmanagement, fachadministration FROM fachverfahren WHERE tag ~* %s ORDER BY name"
            results = db_execute(query, (tag,))

            if not results:
                return render_template('fachverfahrenSuche.html', warning=1, tag=tag)

            name, verf_id, tag, vewendungszweck, laufzeitverfahren, auftraggeber, verf_betreuung, kundenmanagement, fachadministration = results[
                0]

            idAuftraggeber = auftraggeber
            idVerfBetreuung = verf_betreuung
            idKundenmanagement = kundenmanagement
            idFachadministration = fachadministration
            auftraggeber = personIdToName(auftraggeber)
            verf_betreuung = personIdToName(verf_betreuung)
            kundenmanagement = personIdToName(kundenmanagement)
            fachadministration = personIdToName(fachadministration)

            return render_template('fachverfahrenAnsehen.html', name=name, verf_id=verf_id, tag=tag, vewendungszweck=vewendungszweck, laufzeitverfahren=laufzeitverfahren, auftraggeber=auftraggeber, verf_betreuung=verf_betreuung, kundenmanagement=kundenmanagement, fachadministration=fachadministration, idAuftraggeber=idAuftraggeber, idVerfBetreuung=idVerfBetreuung, idKundenmanagement=idKundenmanagement, idFachadministration=idFachadministration)
        except:
            return 'Fehler'


@bp_fachverfahren.route('/fachverfahrenEditieren', methods=['POST'])
def fachverfahrenEditieren():
    tag = request.form['tag']
    try:
        query = "SELECT name, verf_id, tag, vewendungszweck, laufzeitverfahren, auftraggeber, verf_betreuung, kundenmanagement, fachadministration FROM fachverfahren WHERE tag ~* '" + tag + "' ORDER BY name "
        results = db_execute(query)

        name, verf_id, tag, vewendungszweck, laufzeitverfahren, auftraggeber_id, verf_betreuung_id, kundenmanagement_id, fachadministration_id = results[
            0]
        auftraggeber = personIdToName(auftraggeber_id)
        verf_betreuung = personIdToName(verf_betreuung_id)
        kundenmanagement = personIdToName(kundenmanagement_id)
        fachadministration = personIdToName(fachadministration_id)

        print("name:", name)
        print("verf_id:", verf_id)
        print("tag:", tag)
        print("vewendungszweck:", vewendungszweck)
        print("laufzeitverfahren:", laufzeitverfahren)
        print("auftraggeber:", auftraggeber)
        print("verf_betreuung:", verf_betreuung)
        print("kundenmanagement:", kundenmanagement)
        print("fachadministration:", fachadministration)

        return render_template('fachverfahrenEditieren.html', name=name, verf_id=verf_id, tag=tag, vewendungszweck=vewendungszweck, laufzeitverfahren=laufzeitverfahren, auftraggeber=auftraggeber, verf_betreuung=verf_betreuung, kundenmanagement=kundenmanagement, fachadministration=fachadministration)
    except:
        return 'Fehler'


@bp_fachverfahren.route('/fachverfahrenUpdate', methods=['POST'])
def fachverfahrenUpdate():
    tag = request.form['tag'] if request.form['tag'] else None
    if not tag:
        return 'Fehler: Kein Tag bereitgestellt.'

    # Fetch current data for this row.
    cursor = get_cursor()
    query = """SELECT * FROM fachverfahren WHERE tag=%s"""
    cursor.execute(query, (tag,))
    current_data = cursor.fetchone()

    # Convert the result tuple to a dictionary.
    current_data_dict = {desc[0]: value for desc,
                         value in zip(cursor.description, current_data)}

    # Replace any None values with current data.
    name = request.form['it-verfahren-namen'] if request.form['it-verfahren-namen'] else current_data_dict['name']
    verf_id = request.form['verfahrens-id'] if request.form['verfahrens-id'] else current_data_dict['verf_id']
    vewendungszweck = request.form['verwendungszweck'] if request.form[
        'verwendungszweck'] else current_data_dict['vewendungszweck']
    laufzeitverfahren = request.form['laufzeit'] if request.form['laufzeit'] else current_data_dict['laufzeitverfahren']
    auftraggeber_id = request.form['auftraggeber-id'] if request.form['auftraggeber-id'] else current_data_dict['auftraggeber']
    verf_betreuung_id = request.form['verf_bet-id'] if request.form['verf_bet-id'] else current_data_dict['verf_betreuung']
    kundenmanagement_id = request.form['kundenmanagement-id'] if request.form['kundenmanagement-id'] else current_data_dict['kundenmanagement']
    fachadministration_id = request.form['fachadmin-id'] if request.form['fachadmin-id'] else current_data_dict['fachadministration']

    print("auftraggeber_id:", auftraggeber_id)
    print("verf_betreuung_id:", verf_betreuung_id)
    print("kundenmanagement_id:", kundenmanagement_id)
    print("fachadministration_id:", fachadministration_id)

    try:
        query = """UPDATE fachverfahren SET name=%s, verf_id=%s, tag=%s, vewendungszweck=%s, laufzeitverfahren=%s, auftraggeber=%s, 
                verf_betreuung=%s, kundenmanagement=%s, fachadministration=%s WHERE tag=%s"""
        cursor.execute(query, (name, verf_id, tag, vewendungszweck, laufzeitverfahren,
                       auftraggeber_id, verf_betreuung_id, kundenmanagement_id, fachadministration_id, tag))
        get_db().commit()
        return redirect(url_for('fachverfahren.fachverfahrenAnsehen', tag=tag))
    except Exception as e:
        return 'Fehler: ' + str(e)


@bp_fachverfahren.route('/fachverfahrenErstellen', methods=['POST'])
def fachverfahrenErstellen():
    tag = request.form['tag']
    edit = request.form['edit']
    if edit == '1':
        name = request.form['name']
        verf_id = request.form['verf_id']
        vewendungszweck = request.form['vewendungszweck']
        laufzeitverfahren = request.form['laufzeitverfahren']
        auftraggeber = request.form['auftraggeber']
        verf_betreuung = request.form['verf_betreuung']
        kundenmanagement = request.form['kundenmanagement']
        fachadministration = request.form['fachadministration']
        # ? wenn auftraggeber, verf_betreuung, kundenmanagement, fachadministration in der person Datenbank vorhanden sind, dann wird das form in die Datenbank fachverfahren geschrieben

        if personValidate(auftraggeber) and personValidate(verf_betreuung) and personValidate(kundenmanagement) and personValidate(fachadministration):
            try:
                cursor = get_cursor()
                print('test 1')
                query = "INSERT INTO fachverfahren (name, verf_id, tag, vewendungszweck, laufzeitverfahren, auftraggeber, verf_betreuung, kundenmanagement, fachadministration) VALUES ('" + name + "', '" + \
                    verf_id + "', '" + tag + "', '" + vewendungszweck + "', '" + laufzeitverfahren + "', '" + \
                        auftraggeber + "', '" + verf_betreuung + "', '" + \
                    kundenmanagement + "', '" + fachadministration + "')"
                print("test 2")
                cursor.execute(query)
                print("test 3")
                cursor.connection.commit()
                print("test 4")
                cursor.close()
                # debug print(query rückgabe)
                print('Fachverfahren wurde erstellt')
                return render_template('fachverfahrenAnsehen.html', tag=tag, name=name, verf_id=verf_id, vewendungszweck=vewendungszweck, laufzeitverfahren=laufzeitverfahren, auftraggeber=auftraggeber, verf_betreuung=verf_betreuung, kundenmanagement=kundenmanagement, fachadministration=fachadministration)
            except Exception as e:
                return 'Fehler: ' + str(e)
        else:
            return 'Diese Personen gibt es nicht '

    else:
        name = ''
        verf_id = ''
        vewendungszweck = ''
        laufzeitverfahren = ''
        auftraggeber = ''
        verf_betreuung = ''
        kundenmanagement = ''
        fachadministration = ''
    try:
        # ? wenn ein fehler bei der validierung auftritt werden die bereits eingetragen daten wieder angezeigt
        return render_template('fachverfahrenErstellen.html', tag=tag, name=name, verf_id=verf_id, vewendungszweck=vewendungszweck, laufzeitverfahren=laufzeitverfahren, auftraggeber=auftraggeber, verf_betreuung=verf_betreuung, kundenmanagement=kundenmanagement, fachadministration=fachadministration)
    except:
        return 'Fehler'
