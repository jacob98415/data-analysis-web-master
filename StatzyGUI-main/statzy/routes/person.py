from flask import Blueprint, render_template, request, redirect, url_for
from helper import get_cursor, get_db, db_execute


bp_person = Blueprint('person', __name__)


@bp_person.route('/person')
def person():
    return render_template('person.html')


@bp_person.route('/personSuche')
def personSuche():
    return render_template('personSuche.html', warning=0)


@bp_person.route('/personAnsehen', methods=['GET', 'POST'])
def personAnsehen():
    if request.method == 'POST':
        name = request.form['name']
        try:
            cursor = get_cursor()
            query = "SELECT name, telefonnummer, dez, vornam, person_id, zeitpunkt_ins, user_ins, zeitpunkt_upd, user_upd FROM person WHERE name ~* '" + name + "' ORDER BY name "
            cursor.execute(query)
            results = cursor.fetchall()

            if not results:
                return render_template('person.html', warning=1, name=name)

            name, telefonnummer, dez, vornam, person_id, zeitpunkt_ins, user_ins, zeitpunkt_upd, user_upd = results[
                0]

            return render_template('personAnsehen.html', name=name, telefonnummer=telefonnummer, dez=dez, vornam=vornam, person_id=person_id, zeitpunkt_ins=zeitpunkt_ins, user_ins=user_ins, zeitpunkt_upd=zeitpunkt_upd, user_upd=user_upd)
        except Exception as e:
            return 'Fehler', e
    else:
        # ? falls eine id übergeben wird nach id suchen
        if request.args.get('id'):
            id = request.args.get('id')
            try:
                cursor = get_cursor()
                query = "SELECT name, telefonnummer, dez, vornam, person_id, zeitpunkt_ins, user_ins, zeitpunkt_upd, user_upd FROM person WHERE person_id = '" + id + "' ORDER BY name"
                cursor.execute(query, (id,))
                results = cursor.fetchall()
                if not results:
                    return render_template('person.html', warning=1, name=name)
                name, telefonnummer, dez, vornam, person_id, zeitpunkt_ins, user_ins, zeitpunkt_upd, user_upd = results[
                    0]
                return render_template('personAnsehen.html', name=name, telefonnummer=telefonnummer, dez=dez, vornam=vornam, person_id=person_id, zeitpunkt_ins=zeitpunkt_ins, user_ins=user_ins, zeitpunkt_upd=zeitpunkt_upd, user_upd=user_upd)
            except Exception as e:
                return 'Fehler', e
        else:
            name = request.args.get('name')
            try:
                cursor = get_cursor()
                query = "SELECT name, telefonnummer, dez, vornam, person_id, zeitpunkt_ins, user_ins, zeitpunkt_upd, user_upd FROM person WHERE name ~* '" + name + "' ORDER BY name"
                cursor.execute(query, (name,))
                results = cursor.fetchall()
                if not results:
                    return render_template('person.html', warning=1, name=name)
                name, telefonnummer, dez, vornam, person_id, zeitpunkt_ins, user_ins, zeitpunkt_upd, user_upd = results[
                    0]
                return render_template('personAnsehen.html', name=name, telefonnummer=telefonnummer, dez=dez, vornam=vornam, person_id=person_id, zeitpunkt_ins=zeitpunkt_ins, user_ins=user_ins, zeitpunkt_upd=zeitpunkt_upd, user_upd=user_upd)
            except Exception as e:
                return 'Fehler', e


@bp_person.route('/personEditieren', methods=['POST'])
def personEditieren():
    print("Test 1")
    # nameOld = request.form['name']
    # print(nameOld)
    name = request.form['name']
    print(name)
    try:
        cursor = get_cursor()
        query = "SELECT name, telefonnummer, dez, vornam, person_id, zeitpunkt_ins, user_ins, zeitpunkt_upd, user_upd FROM person WHERE name ~* '" + name + "' ORDER BY name"
        cursor.execute(query)
        results = cursor.fetchall()
        name, telefonnummer, dez, vornam, person_id, zeitpunkt_ins, user_ins, zeitpunkt_upd, user_upd = results[
            0]
        return render_template('personEditieren.html', name=name, telefonnummer=telefonnummer, dez=dez, vornam=vornam, person_id=person_id, zeitpunkt_ins=zeitpunkt_ins, user_ins=user_ins, zeitpunkt_upd=zeitpunkt_upd, user_upd=user_upd)
    except:
        return 'Fehler'


@bp_person.route('/personUpdate', methods=['POST'])
def personUpdate():
    name = request.form['name']
    telefonnummer = request.form['telefonnummer']
    dez = request.form['dez']
    vornam = request.form['vornam']
    person_id = request.form['person_id']
    # zeitpunkt_ins = request.form['zeitpunkt_ins']
    # user_ins = request.form['user_ins']
    # zeitpunkt_upd = request.form['zeitpunkt_upd']
    # user_upd = request.form['user_upd']
    # zeitpunkt_ins=NULL, user_ins=NULL, zeitpunkt_upd=NULL, user_upd=NULL
    try:
        cursor = get_cursor()
        query = "UPDATE person SET name=%s, telefonnummer=%s, dez=%s, vornam=%s WHERE person_id=%s"
        # print(query, (name, telefonnummer, dez, vornam, name))
        cursor.execute(query, (name, telefonnummer, dez, vornam, person_id))
        get_db().commit()
        return redirect(url_for('person.personAnsehen', name=name))
    except Exception as e:
        return 'Fehler: ' + str(e)


@bp_person.route('/personValidate', methods=['POST'])
def personValidate():
    return render_template('personErstellen.html')


@bp_person.route('/personErstellen', methods=['POST'])
def personErstellen():
    name = request.form['name']
    telefonnummer = request.form['telefonnummer']
    dez = request.form['dez']
    vornam = request.form['vornam']
    print("test 0")
    try:
        cursor = get_cursor()
        print('test 1')
        query = "INSERT INTO person (name, telefonnummer, dez, vornam) VALUES ('" + name + "', '" + \
            telefonnummer + "', '" + dez + "', '" + vornam + "')"
        print("test 2")
        cursor.execute(query)
        print("test 3")
        cursor.connection.commit()
        print("test 4")
        cursor.close()
        # debug print(query rückgabe)
        print('Person wurde erstellt')
        return render_template('personAnsehen.html', name=name, telefonnummer=telefonnummer, dez=dez, vornam=vornam)
    except Exception as e:
        return 'Fehler: ' + str(e)


@bp_person.route('/persServRelAnsehen')
def persServRelAnsehen():
    try:
        results = db_execute("SELECT * FROM person")
        return render_template('persServRelAnsehen.html', data=results)
    except Exception as e:
        results = []
        return f"Database query failed! {e}"
