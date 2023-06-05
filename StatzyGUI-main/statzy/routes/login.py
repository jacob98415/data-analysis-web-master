from flask import Blueprint, request, session, redirect, url_for, render_template
from helper import get_db

bp_login = Blueprint('login', __name__)


@bp_login.route('/')
def index():
    title = 'Statzy'
    return render_template('login.html', title=title)

@bp_login.route('/login', methods=['POST'])
def login():
    print("Entering login function")
    session['username'] = request.form['username']
    session['password'] = request.form['password']
    print(f"Username: {session['username']}, Password: {session['password']}")
    try:
        get_db()
        print("Database connection successful")
        return redirect(url_for('home.start'))
    except Exception as e:
        print(f"Database connection failed: {e}")
        return 'Database connection failed! Login'