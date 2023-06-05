# StatzyGUI

## Wiki

Read the wiki [here](https://github.com/ZIT-P22/StatzyGUI/wiki)

## Installation Guide

1. Open a virtual environment
2. Activate the virtual environment
3. Install Flask with the following command:
   ```
   pip install -r requirements.txt
   ```
4. Create the Statzy database in your local Postgres database:
   ```
   CREATE DATABASE statzy
   ```
5. Import the Statzy tables and data into the Statzy database:
   - First, connect to the Statzy database:
     ```
     \c statzy
     ```
   - Then, import the tables and data:
     ```
     \i statzy.sql
     \i statzy.siko
     ```

## Running the Flask Application for Development

1. Run the `statzy.py` file with Python:
   ```
   python statzy/statzy.py
   ```
2. Run the css watcher:
   ```
   npx tailwindcss -i statzy/static/css/theme.css -o statzy/static/build/theme.css --watch
   ```

---

[![Flask](https://img.shields.io/badge/-Flask-000?logo=Flask&logoColor=white&style=flat-square)](https://flask.palletsprojects.com/en/2.1.x/)
[![Tailwind CSS](https://img.shields.io/badge/-Tailwind%20CSS-38B2AC?logo=Tailwind%20CSS&logoColor=white&style=flat-square)](https://tailwindcss.com/)
