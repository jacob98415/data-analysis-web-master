from flask import Blueprint, render_template, request
from helper import get_cursor
import json


bp_query = Blueprint('query', __name__)
    
    
@bp_query.route('/query', methods=['POST'])
def query():
    table_name = request.form['table']
    try:
        cursor = get_cursor()
        cursor.execute(f"SELECT * FROM {table_name}")
        results = cursor.fetchall()
        return render_template('query.html', table_name=table_name, data=results, cursor=cursor)
    except Exception as e:
        results = []
        return f"Database query failed! {e}"
    
    
@bp_query.route('/getnames', methods=['GET'])
def getnames():
    input = request.args.get('input')
    cursor = get_cursor()
    cursor.execute("SELECT person_id, vornam, name, dez FROM person WHERE name ILIKE %s OR vornam ILIKE %s OR dez ILIKE %s", (f"%{input}%", f"%{input}%", f"%{input}%",))
    results = cursor.fetchall()
    names = [{"person_id": result[0], "vornam": result[1], "name": result[2], "dez": result[3]} for result in results]
    print(json.dumps(names))
    return json.dumps(names)