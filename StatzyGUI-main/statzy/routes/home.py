from flask import Blueprint, render_template
from helper import db_execute

bp_home = Blueprint('home', __name__)



@bp_home.route('/start')
def start():
    try:
        query = "SELECT name, verf_id, tag FROM fachverfahren ORDER BY name"
        fachverfahren_data = db_execute(query)

        print(fachverfahren_data)
        return render_template('index.html', fachverfahren_data=fachverfahren_data)

    except Exception as e:
        print("Error:", e)
        return 'Fehler AAAAAAAAAAHHHHHHHHHHHHHHHH!!!!!'