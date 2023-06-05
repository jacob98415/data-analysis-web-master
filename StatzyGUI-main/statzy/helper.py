from flask import Flask, render_template, request, redirect, url_for, session, g, jsonify
import psycopg2
import psycopg2.pool
import secrets
import json


#! def zone start

# Create a connection pool
connection_pool = psycopg2.pool.SimpleConnectionPool(
    minconn=1,
    maxconn=80,
    dbname='statzy',
    user='postgres',
    password='postgres',
    host='10.128.201.123',
    port='5432'
)


def get_db():
    if 'db' not in g:
        g.db = connection_pool.getconn()
    return g.db



def db_execute(query, *args):
    cursor = get_cursor()
    cursor.execute(query, *args)
    return cursor.fetchall()


def personValidate(person_id):
    cursor = get_cursor()
    query = "SELECT count(*) FROM person WHERE person_id = '" + person_id + "'"
    cursor.execute(query)
    results = cursor.fetchall()

    if results[0][0] == 1:
        return True
    else:
        return False

# ? funktion die in der person Datenbank die Id sucht un den dazugehörigen Namen zurückgibt


def personIdToName(person_id):
    query = "SELECT vornam, name, dez FROM person WHERE person_id = '" + str(person_id) + "'"
    results = db_execute(query)
    print(results[0][0] + " " + results[0][1] + " " + results[0][2])
    return results[0][0] + " " + results[0][1] + " | Dez: " + results[0][2] if results else None


def get_cursor():
    if 'cursor' not in g:
        g.cursor = get_db().cursor()
    return g.cursor


#! def zone end

