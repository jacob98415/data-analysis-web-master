from flask import Flask, render_template, request, redirect, url_for, session, g, jsonify
import psycopg2
from psycopg2 import pool
import secrets
import json
from helper import get_cursor, connection_pool
from routes import home, person, fachverfahren, server, komponente, login, query, datenbank

statzy = Flask(__name__)
statzy.secret_key = secrets.token_hex(16)


@statzy.teardown_appcontext
def close_db(e=None):
    cursor = g.pop('cursor', None)
    db = g.pop('db', None)

    if cursor is not None:
        cursor.close()
    if db is not None:
        db.close()


statzy.register_blueprint(home.bp_home)
statzy.register_blueprint(person.bp_person)
statzy.register_blueprint(fachverfahren.bp_fachverfahren)
statzy.register_blueprint(server.bp_server)
statzy.register_blueprint(login.bp_login)
statzy.register_blueprint(query.bp_query)
statzy.register_blueprint(datenbank.bp_datenbanken)


if __name__ == '__main__':
    statzy.run(debug=True, host="0.0.0.0", port=5000)
