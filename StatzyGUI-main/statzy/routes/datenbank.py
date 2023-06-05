from flask import Blueprint, render_template, g
from helper import get_cursor, connection_pool

bp_datenbanken = Blueprint('datenbank', __name__)

@bp_datenbanken.route('/datenbanken')
def show_datenbanken():
    try:
        cursor = get_cursor()
        cursor.execute(
            "SELECT table_name FROM information_schema.tables WHERE table_schema='public' ORDER BY table_name")
        tables = [table[0] for table in cursor.fetchall()]
        return render_template('datenbanken.html', tables=tables)
    except Exception as e:
        return 'Database connection failed! Datenbanken' + str(e)

