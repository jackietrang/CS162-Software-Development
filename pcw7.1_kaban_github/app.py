import os
import sqlite3
from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
project_dir = os.path.dirname(os.path.abspath(__file__))
db_file = "sqlite:///{}".format(os.path.join(project_dir, "todo.db"))
app.config['SQLALCHEMY_DATABASE_URI'] = db_file
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True

db = SQLAlchemy(app)


class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    text = db.Column(db.String(200))
    complete = db.Column(db.Boolean)


@app.route('/')
# name function the same as url_for
def index1():
    todos = Task.query.filter_by(complete=False).all()
    todones = Task.query.filter_by(complete=True).all()
    return render_template('index1.html', todos=todos, todones=todones)


@app.route('/add', methods=['POST'])
def add():
    todo = Task(text=request.form['tname-input'], complete=False)
    db.session.add(todo)
    db.session.commit()
    return redirect(url_for('index1'))


@app.route('/done', methods=['POST'])
def done():
    Task.query.filter_by(id=request.form['todo']).first().complete = True
    db.session.commit()
    return redirect(url_for('index1'))


@app.route('/delete', methods=['POST'])
def delete():
    todone = Task.query.filter_by(id=request.form['todone']).first()
    db.session.delete(todone)
    db.session.commit()
    return redirect(url_for('index1'))


if __name__ == "__main__":
    app.run(debug=True)

'''
Why it didn't work at first:
- db create_all(): create the file todo.db
- lack {% end for %}
- url_for(index1) is for function index1 not the index1.html

'''




