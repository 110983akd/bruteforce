from flask import Flask, request, session, redirect, url_for, render_template
from datetime import datetime

app = Flask(__name__)
app.secret_key = "supersecret"  # Required for session handling

LOG_FILE = "login_attempts.log"
VALID_USERNAME = "admin"
VALID_PASSWORD = "secret"

def log_attempt(username, password, success):
    timestamp = datetime.now().isoformat()
    ip_address = request.remote_addr
    log_entry = f"{timestamp} | IP: {ip_address} | USERNAME: {username} | PASSWORD: {password} | SUCCESS: {success}\n"
    with open(LOG_FILE, "a") as f:
        f.write(log_entry)

@app.route("/", methods=["GET"])
def home():
    if "username" in session:
        return redirect(url_for("dashboard"))
    return render_template("login.html", message=None)

@app.route("/login", methods=["POST"])
def login():
    username = request.form.get("username", "")
    password = request.form.get("password", "")
    success = username == VALID_USERNAME and password == VALID_PASSWORD
    log_attempt(username, password, success)

    if success:
        session["username"] = username
        return redirect(url_for("dashboard"))
    else:
        return render_template("login.html", message="Invalid credentials.")

@app.route("/dashboard")
def dashboard():
    if "username" not in session:
        return redirect(url_for("home"))
    return render_template("dashboard.html", username=session["username"])

@app.route("/logout")
def logout():
    session.pop("username", None)
    return redirect(url_for("home"))

if __name__ == "__main__":
    app.run(debug=True)
