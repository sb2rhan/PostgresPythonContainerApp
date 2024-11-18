from sqlalchemy import create_engine
from sqlalchemy.sql import text

conn_url = 'postgresql+psycopg2://postgres:9765229@PostgresDBMS/healthreportsystemdb'


def print_query_rows(connection, query, prefix = ""):
    """
    A function that executes the SELECT queries and prints the rows.
    :param connection: Connection obj with execute method
    :param query: string SQL query with SELECT statement
    :param prefix: prefix string for putting before printing the result rows
    """
    result = connection.execute(query).fetchall()
    for row in result:
        print(prefix, row)

engine = create_engine(conn_url)
with engine.connect() as conn:
    print("--- 1. Basic retrieval queries ---")
    # List all diseases caused by "bacteria" that were discovered before 2020
    print("All diseases caused by bacteria discovered before 2020:")
    query1 = text('''
            SELECT * FROM Disease d, Discover di
            WHERE d.disease_code = di.disease_code AND 
                d.pathogen = 'bacteria' AND di.first_enc_date < '2020-01-01';
    ''')
    print_query_rows(conn, query1)

    # Retrieve the names and degrees of doctors who are not specialized in “infectious diseases.”
    print("Names and degrees of doctors not specialized in 'infectious diseases':")
    query2 = text('''
            SELECT u.name, u.surname, doc.degree
            FROM Users u, Doctor doc, Specialize s, DiseaseType dt
            WHERE u.email = doc.email AND doc.email = s.email AND s.id = dt.id AND
                dt.description <> 'infectious diseases'
            GROUP BY u.name, u.surname, doc.degree;
    ''')
    print_query_rows(conn, query2)

    # List the name, surname, and degree of doctors who are specialized in more than 2 disease types
    print("Name, surname, and degree of doctors specialized in more than 2 disease types:")
    query3 = text('''
            SELECT u.name, u.surname, doc.degree
            FROM Users u
            JOIN Doctor doc ON u.email = doc.email
            JOIN Specialize s ON doc.email = s.email
            GROUP BY u.name, u.surname, doc.degree
            HAVING COUNT(s.id) > 2;
    ''')
    print_query_rows(conn, query3)

    print("")
    print("--- 2. Complex queries with Aggregation ---")
    # List countries and the average salary of doctors specialized in "virology."
    print("Countries and avg salaries of doctors specialized in 'virology':")
    query4 = text('''
            SELECT c.cname, AVG(u.salary) AS avg_salary
            FROM Users u, Doctor doc, Specialize s, DiseaseType dt, Country c
            WHERE u.email = doc.email AND doc.email = s.email AND
                s.id = dt.id AND u.cname = c.cname AND
                dt.description = 'virology'
            GROUP BY c.cname;
    ''')
    print_query_rows(conn, query4)

    # Find departments with public servants reporting "covid-19" cases across multiple
    # countries, counting such employees per department.
    print("Deparments with public servants who reported 'COVID-19' across multiple countries:")
    query5 = text('''
            SELECT ps.department, COUNT(DISTINCT ps.email) AS num_employees
            FROM PublicServant ps, Record r
            WHERE ps.email = r.email AND r.disease_code = 'COVID-19'
            GROUP BY ps.department
            HAVING COUNT(DISTINCT r.cname) > 1;
    ''')
    print_query_rows(conn, query5)

    print("")
    print("--- 3. Update and Maintenance Queries ---")
    # Double the salary of public servants who have recorded more than three “covid-19” patients.
    print("Doubling salaries of public servants who recorded more than 3 COVID-19 patients:")
    print("\tBefore:")
    print_query_rows(conn, text('''
            SELECT * FROM Users
            WHERE email IN (
                SELECT ps.email
                FROM PublicServant ps, Record r
                WHERE ps.email = r.email AND r.disease_code = 'COVID-19'
                GROUP BY ps.email
                HAVING SUM(r.total_patients) > 3
            );
    '''), "\t")
    print("\tUpdating...")
    query6 = text('''
            UPDATE Users
            SET salary = salary * 2
            WHERE email IN (
                SELECT ps.email
                FROM PublicServant ps, Record r
                WHERE ps.email = r.email AND r.disease_code = 'COVID-19'
                GROUP BY ps.email
                HAVING SUM(r.total_patients) > 3
            );
    ''')
    conn.execute(query6)
    print("\tAfter:")
    print_query_rows(conn, text('''
            SELECT * FROM Users
            WHERE email IN (
                SELECT ps.email
                FROM PublicServant ps, Record r
                WHERE ps.email = r.email AND r.disease_code = 'COVID-19'
                GROUP BY ps.email
                HAVING SUM(r.total_patients) > 3
            );
    '''), "\t")

    # Delete users whose name contains the substring “bek” or “gul”
    print("Deleting users with names LIKE %bek% or %gul%:")
    print("\tBefore:")
    print_query_rows(conn, text('''SELECT * FROM Users;'''), "\t")
    print("\tDeleting...")
    query7 = text('''
            DELETE FROM Users
            WHERE name LIKE '%bek%' OR name LIKE '%gul%';
    ''')
    conn.execute(query7)
    print("\tAfter:")
    print_query_rows(conn, text('''SELECT * FROM Users;'''), "\t")

    print("")
    print("--- 4. Indexing ---")
    # Create a primary indexing on the “email” field in the Users table
    print("Creating a primary indexing on email field of Users table:")
    print("\tBefore:")
    print_query_rows(conn, text('''
            SELECT *
            FROM pg_indexes
            WHERE tablename = 'users';
    '''), "\t")
    query8 = text('''
            CREATE UNIQUE INDEX pidx_email_users ON Users(email);
    ''')
    print("\tCreating an index...")
    conn.execute(query8)
    print("\tAfter:")
    print_query_rows(conn, text('''
                SELECT *
                FROM pg_indexes
                WHERE tablename = 'users';
        '''), "\t")

    # Create a secondary indexing on the “disease_code” field in the Disease table
    print("Creating a secondary indexing on the “disease_code” field of Disease table:")
    print("\tBefore:")
    print_query_rows(conn, text('''
                SELECT *
                FROM pg_indexes
                WHERE tablename = 'disease';
        '''), "\t")
    query9 = text('''
            CREATE INDEX idx_disease_code ON Disease(disease_code);
    ''')
    print("\tCreating an index...")
    conn.execute(query9)
    print("\tAfter:")
    print_query_rows(conn, text('''
                    SELECT *
                    FROM pg_indexes
                    WHERE tablename = 'disease';
            '''), "\t")

    print("")
    print("--- 5. Additional Analysis ---")
    # List the top 2 countries with the highest number of total patients recorded
    print("Top 2 countries with the highest number of total patients:")
    query10 = text('''
            SELECT r.cname, SUM(r.total_patients) AS total_patients
            FROM Record r
            GROUP BY r.cname
            ORDER BY total_patients DESC
            LIMIT 2;
    ''')
    print_query_rows(conn, query10)

    print("")
    print("--- 6. Query with a Derived Attribute ---")
    # Calculate the total number of patients who have covid-19 disease
    print("Total number of patients with COVID-19:")
    query11 = text('''
            SELECT SUM(total_patients) AS total_covid19_patients
            FROM Record
            WHERE disease_code = 'COVID-19';
    ''')
    print_query_rows(conn, query11)

    print("")
    print("--- 7 & 8. View Operation & Querying the View just created---")
    print("Creating a view with all patients’ names and surnames along with their respective diseases:")
    query12 = text('''
            CREATE VIEW PatientDiseasesView AS
            SELECT u.name, u.surname, d.disease_code, d.description
            FROM Users u, PatientDisease pd, Disease d
            WHERE u.email = pd.email AND pd.disease_code = d.disease_code;
    ''')
    conn.execute(query12)
    print("View is created.")

    print("All patients’ full names along with the diseases they have been diagnosed with:")
    query13 = text('''
            SELECT CONCAT(name, ' ', surname) AS full_name, disease_code, description
            FROM PatientDiseasesView;
    ''')
    print_query_rows(conn, query13)

    # Uncomment when need to save changes to Database
    conn.commit()