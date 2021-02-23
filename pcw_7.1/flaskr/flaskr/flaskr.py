# import os
# import sqlit3
# from flask import Flask, request, session, g, redirect, url_for, abort, \
#     render_template, flash

# app = Flask(__name__) # create the application insance
# app.config.from_object(__name__) # load confiq from this file, flaskr.py

# # load default config and override config from an environment variable
#     # config object similar dictionary, can be updated with new values
# app.confiq.update(dict(
#     DATABASE=os.path.join(app.root_path, 'flaskr.db'),
#     SECRET_KEY='development key',
#     USERNAME='admin',
#     PASSWORD='default'
# ))

# # for robust config setups: load a separate, env-specific config file
# # flask can import multiple config using setting defined in the last import
# app.config.from_envvar('FLASKR_SETTINGS', silent=True) #silent: not complain if no env key set

# # method for easy connections to db
#  # purpose: open a connection on request and from the interactive Python shell or a script
# def connect_db():
#     """Connects to the specific database"""
#     rv = sqlite3.connect(app.config['DATABASE'])
#     rv.row_factory = sqlite3.Row # treat rows as dictionary instead of tuples
#     return rv

# # init database
# def init_db():
#     db = get_db()
#     #open_resource: helper to open resource app provides
#     with app.open_resource('schema.sql', mode='r') as f:
#         # connection object by SQLite gives a cursor object
#             # on cursor, a method to execute script
#         db.cursor().executescript(f.read())
#     # has to explicit commit the change
#     db.commit()

# '''
# @decorator: register a new command with the flask script
#     - command executes -> auto create an app context bound to the right app
#     - within the func, can access flask.g and other things
#     - when script ends, app context tears down and db connection is released

# '''
# @app.cli.command('initdb')
# def initdb_command():
#     """Init the databse"""
#     init_db()
#     print('Initialized the databse.')

# # establish db connection (connect_db) & closing is inefficient
# # two flask contexts: application context and request context
# def get_db():
#     """
#     Opens a new database connection if there is none yet for the
#     current application context.

#     """
#     if not hasattr(g, 'sqlite_db'):
#         # g: general purpose variable associated w current app context
#         g.sqlite_db = connect_db()
#     return g.sqlite_db

# @app.teardown_appcontext
# def close_db(error):
#     """Close db again at the end of the request 
#     request finish: everything went well (error parameter=None) or an exception happens"""
#     if hasattr(g, 'sqlite_db'):
#         g.sqlite_db.close()

# all the imports
import os
import sqlite3
from flask import Flask, request, session, g, redirect, url_for, abort, \
     render_template, flash

# create our little application :)
app = Flask(__name__)
app.config.from_object(__name__)

# Load default config and override config from an environment variable
app.config.update(dict(
    DATABASE=os.path.join(app.root_path, 'flaskr.db'),
    SECRET_KEY='development key',
    USERNAME='admin',
    PASSWORD='default'
))
app.config.from_envvar('FLASKR_SETTINGS', silent=True)

def connect_db():
    """Connects to the specific database."""
    rv = sqlite3.connect(app.config['DATABASE'])
    rv.row_factory = sqlite3.Row
    return rv

def init_db():
    db = get_db()
    with app.open_resource('schema.sql', mode='r') as f:
        db.cursor().executescript(f.read())
    db.commit()

@app.cli.command('initdb')
def initdb_command():
    """Initializes the database."""
    init_db()
    print('Initialized the database.')


def get_db():
    """Opens a new database connection if there is none yet for the
    current application context.
    """
    if not hasattr(g, 'sqlite_db'):
        g.sqlite_db = connect_db()
    return g.sqlite_db

@app.teardown_appcontext
def close_db(error):
    """Closes the database again at the end of the request."""
    if hasattr(g, 'sqlite_db'):
        g.sqlite_db.close()

@app.route('/')
def show_entries():
    """show entries stored in db"""
    db = get_db()
    cur = db.execute('select title, text from entries order by id desc')
    entries = cur.fetchall()
    return render_template('show_entries.html', entries=entries)

@app.route('/add', methods=['POST'])
def add_entry():
    if not session.get('logged_in'):
        abort(401)
    db = get_db()
    # ? otherwise vulnerable to SQL injection when use string format to build SQL statements
    db.execute('insert into entries (title, text) values (?, ?)',
            [request.form['title'], request.form['text']])
    db.commit()
    flash('New entry was successfully posted')
    return redirect(url_for('show_entries'))
        
@app.route('/login', methods=['GET', 'POST'])
def login():
    """
    Log in, if success, set logged_in key = True & user is redirected back to show_entries page
    """
    error = None 
    if request.method == 'POST':
        if request.form['username'] != app.config['USERNAME']:
            error = 'Invalid username'
        elif request.form['password'] != app.config['PASSWORD']:
            error = 'Invalid password'
        else:
            session['logged_in'] = True 
            flash('You were logged in')
            return redirect(url_for('show_entries'))
    return render_template('login.html', error=error)

@app.route('/logout')
def logout():
    """Log out, remove key from the session"""
    # pop() deletes the key from dict if present or do nothing when key not there
    session.pop('logged_in', None)
    flash('You were logged out')
    return redirect(url_for('show entries'))