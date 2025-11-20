from flask import Flask, render_template, request, redirect, url_for, flash
from db_config import get_db_connection

app = Flask(__name__)
app.secret_key = 'edunest_secret'


# ---------- HOME ----------
@app.route('/')
def index():
    return render_template('index.html')


# ---------- LOGIN ----------
@app.route('/login', methods=['POST'])
def login():
    role = request.form['role']
    user_id = request.form['id']

    if role == 'student':
        return redirect(url_for('student_dashboard', sid=user_id))
    elif role == 'faculty':
        return redirect(url_for('faculty_dashboard', fid=user_id))
    elif role == 'admin':
        return redirect(url_for('admin_dashboard'))
    else:
        flash("❌ Invalid role selected!")
        return redirect('/')


# ---------- STUDENT DASHBOARD ----------
@app.route('/student/<int:sid>')
def student_dashboard(sid):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    submissions = []
    total_marks = 0
    avg_marks = 0

    try:
        # Stored procedure to fetch submissions
        for result in cursor.execute("CALL GetStudentSubmissions(%s)", (sid,), multi=True):
            if result.with_rows:
                submissions = result.fetchall()

        # Calculate total and average marks
        cursor.execute("""
            SELECT 
                COALESCE(SUM(MarksAwarded), 0) AS TotalMarks,
                COALESCE(AVG(MarksAwarded), 0) AS AvgMarks
            FROM Submission
            WHERE Student_ID = %s
        """, (sid,))
        marks = cursor.fetchone()
        total_marks = marks['TotalMarks']
        avg_marks = round(marks['AvgMarks'], 2)

        if not submissions:
            flash("⚠️ No submissions found for this student.")

    except Exception as e:
        submissions = []
        flash(f"⚠️ Error loading submissions: {e}")
        print("Error loading student submissions:", e)
    finally:
        cursor.close()
        conn.close()

    return render_template(
        'student.html',
        submissions=submissions,
        sid=sid,
        total_marks=total_marks,
        avg_marks=avg_marks
    )


# ---------- FACULTY DASHBOARD ----------
@app.route('/faculty/<int:fid>')
def faculty_dashboard(fid):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    submissions, resources = [], []
    total_subs = 0
    courses = []

    try:
        # Fetch submissions for that faculty's courses
        cursor.execute("""
            SELECT s.Sub_ID, st.Name AS Student, a.Title AS Assignment,
                   s.MarksAwarded, s.Feedback, c.CourseName
            FROM Submission s
            JOIN Student st ON s.Student_ID = st.Student_ID
            JOIN Assignment a ON s.Assign_ID = a.Assign_ID
            JOIN Course c ON a.Course_ID = c.Course_ID
            WHERE c.Faculty_ID = %s
            ORDER BY s.Sub_ID DESC
        """, (fid,))
        submissions = cursor.fetchall()

        # Count total submissions
        cursor.execute("""
            SELECT COUNT(*) AS TotalSubs
            FROM Submission s
            JOIN Assignment a ON s.Assign_ID = a.Assign_ID
            JOIN Course c ON a.Course_ID = c.Course_ID
            WHERE c.Faculty_ID = %s
        """, (fid,))
        total_subs = cursor.fetchone()['TotalSubs']

        # Fetch courses taught by this faculty
        cursor.execute("SELECT Course_ID, CourseName FROM Course WHERE Faculty_ID = %s", (fid,))
        courses = cursor.fetchall()

        # Fetch resources added by this faculty
        cursor.execute("""
            SELECT r.Resource_ID, r.Title, r.Type, r.UploadDate, r.FileLink, c.CourseName
            FROM Resource r
            JOIN Course c ON r.Course_ID = c.Course_ID
            WHERE c.Faculty_ID = %s
            ORDER BY r.Resource_ID DESC
        """, (fid,))
        resources = cursor.fetchall()

    except Exception as e:
        flash(f"⚠️ Error loading faculty dashboard: {e}")
        print("Error loading faculty dashboard:", e)
    finally:
        cursor.close()
        conn.close()

    return render_template(
        'faculty.html',
        fid=fid,
        submissions=submissions,
        resources=resources,
        total_subs=total_subs,
        courses=courses
    )


# ---------- FACULTY FEEDBACK ----------
@app.route('/faculty/feedback', methods=['POST'])
def faculty_feedback():
    sub_id = request.form['sub_id']
    marks = request.form['marks']
    feedback = request.form['feedback']

    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "UPDATE Submission SET MarksAwarded=%s, Feedback=%s WHERE Sub_ID=%s",
            (marks, feedback, sub_id)
        )
        conn.commit()
        flash("✅ Feedback updated successfully!")
    except Exception as e:
        conn.rollback()
        flash(f"❌ Error updating feedback: {e}")
        print("Error updating feedback:", e)
    finally:
        cursor.close()
        conn.close()

    return redirect(request.referrer)


# ---------- ADD RESOURCE ----------
@app.route('/faculty/<int:fid>/add_resource', methods=['POST'])
def add_resource(fid):
    title = request.form['title']
    rtype = request.form['rtype']
    filelink = request.form['filelink']
    course_id = request.form['course_id']

    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        # ✅ Generate a new Resource_ID manually since AUTO_INCREMENT is missing
        cursor.execute("SELECT COALESCE(MAX(Resource_ID), 500) + 1 FROM Resource")
        next_id = cursor.fetchone()[0]

        cursor.execute("""
            INSERT INTO Resource (Resource_ID, Title, Type, UploadDate, FileLink, Course_ID)
            VALUES (%s, %s, %s, CURDATE(), %s, %s)
        """, (next_id, title, rtype, filelink, course_id))
        conn.commit()
        flash("✅ Resource added successfully!")
    except Exception as e:
        conn.rollback()
        flash(f"❌ Error adding resource: {e}")
        print("Error adding resource:", e)
    finally:
        cursor.close()
        conn.close()

    return redirect(f'/faculty/{fid}')


# ---------- ADMIN DASHBOARD ----------
@app.route('/admin')
def admin_dashboard():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("SELECT * FROM Admin")
        admins = cursor.fetchall()
        cursor.execute("SELECT * FROM Course")
        courses = cursor.fetchall()
    except Exception as e:
        admins, courses = [], []
        flash(f"⚠️ Error loading admin dashboard: {e}")
        print("Error loading admin dashboard:", e)
    finally:
        cursor.close()
        conn.close()

    return render_template('admin.html', admins=admins, courses=courses)


# ---------- ADD NEW ADMIN ----------
@app.route('/admin/add_admin', methods=['POST'])
def add_admin():
    name = request.form['name']
    email = request.form['email']
    role = request.form['role']

    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("INSERT INTO Admin (Name, Email, Role) VALUES (%s, %s, %s)", (name, email, role))
        conn.commit()
        flash("✅ New admin added successfully!")
    except Exception as e:
        conn.rollback()
        flash(f"❌ Error adding admin: {e}")
        print("Error adding admin:", e)
    finally:
        cursor.close()
        conn.close()

    return redirect('/admin')


# ---------- DELETE ADMIN ----------
@app.route('/admin/delete_admin/<int:admin_id>')
def delete_admin(admin_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM Admin WHERE Admin_ID = %s", (admin_id,))
        conn.commit()
        flash("🗑️ Admin deleted successfully!")
    except Exception as e:
        conn.rollback()
        flash(f"❌ Error deleting admin: {e}")
        print("Error deleting admin:", e)
    finally:
        cursor.close()
        conn.close()

    return redirect('/admin')


# ---------- ADD NEW COURSE ----------
@app.route('/admin/add_course', methods=['POST'])
def add_course():
    course_id = request.form['course_id']
    cname = request.form['cname']
    dept = request.form['dept']
    semester = request.form['semester']
    fid = request.form['fid']

    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("""
            INSERT INTO Course (Course_ID, CourseName, Dept, Semester, Faculty_ID)
            VALUES (%s, %s, %s, %s, %s)
        """, (course_id, cname, dept, semester, fid))
        conn.commit()
        flash("✅ Course added successfully!")
    except Exception as e:
        conn.rollback()
        flash(f"❌ Error adding course: {e}")
        print("Error adding course:", e)
    finally:
        cursor.close()
        conn.close()

    return redirect('/admin')


# ---------- DELETE COURSE ----------
@app.route('/admin/delete_course/<int:course_id>')
def delete_course(course_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM Resource WHERE Course_ID = %s", (course_id,))
        cursor.execute("DELETE FROM Assignment WHERE Course_ID = %s", (course_id,))
        cursor.execute("DELETE FROM Enrollment WHERE Course_ID = %s", (course_id,))
        cursor.execute("DELETE FROM Course WHERE Course_ID = %s", (course_id,))
        conn.commit()
        flash("🗑️ Course and related records deleted successfully!")
    except Exception as e:
        conn.rollback()
        flash(f"❌ Error deleting course: {e}")
        print("Error deleting course:", e)
    finally:
        cursor.close()
        conn.close()

    return redirect('/admin')


# ---------- RUN ----------
if __name__ == '__main__':
    app.run(debug=True)
