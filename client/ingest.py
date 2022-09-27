import irisnative
import configparser
from faker import Faker
import time

# read config
config = configparser.ConfigParser()
config.read('ingest.ini')

ip = config['iris']['ip']
port = int(config['iris']['port'])
namespace = config['iris']['namespace']
username = config['iris']['username']
password = config['iris']['password']

# create database connection and IRIS instance
connection = irisnative.createConnection(ip,port,namespace,username,password)
dbnative = irisnative.createIris(connection)

print("Connected")

faker = Faker()
try:
    print("Inserting data...")
    while(True):
        returnValue = dbnative.classMethodValue("Data.Person", "Create", faker.first_name(), faker.last_name(), faker.city(), faker.ssn())
        print("id =", returnValue)
        time.sleep(0.5)
except KeyboardInterrupt:
    # close connection
    connection.close()