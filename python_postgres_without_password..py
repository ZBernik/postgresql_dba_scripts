import psycopg2
#########################################################################
#                                                                       #
# Connect to postgresql without password                                #
# It looks easy, but almost no one knows it. Trick is password=""       #
# Enjoy :-)                                                             #  
#                                                                       #
# pg_hba.conf for socket auth without password                          #
#local   all             postgres        127.0.0.1               ident  #
#                                                                       #
######################################################################### 

def check_database_health(host, port, user, password, database):
    # Connect to the database
     conn = psycopg2.connect(port="5434", host="127.0.0.1", user="postgres", database="postgres", password="")
     cursor = conn.cursor()

    # Run a simple query to check the health of the database
     cursor.execute("SELECT 1")
     result = cursor.fetchone()

    # Check the result of the query
     if result == (1,):
        print("OK - DB  is available")
     else:
        print("CRITICAL - DB is not available ")

# Test the function with some sample connection details
check_database_health(port="5434", host="127.0.0.1", user="postgres", database="postgres", password="")