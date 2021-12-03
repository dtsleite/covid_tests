import requests
import json
import logging
import datetime
import os
from psycopg2 import connect, Error

LOG_FILE_NAME = 'ingestion_log'
logging.basicConfig(filename=LOG_FILE_NAME, encoding='utf-8', level=logging.INFO)

def getjsondata(url):
    now = datetime.datetime.now()
    params = {
        "format": "json"
    }

    try:
        data = requests.get(url=url, params=params)
        logging.info(str(now) + ' - Data obtained successfully with status code: ' + str(data.status_code))

        year_week = datetime.date(now.year, now.month, now.day).isocalendar().week
        data_filtered = [x for x in data.json() if x['year_week'] == '{0}-{1}'.format(now.year, year_week)]

        return data.json()
        #return data_filtered
    except Exception as ex:
        logging.error(now + ' - Error to obtain data with status code: ' + str(data.status_code) + ' and message: ' + str(ex))

def postgreconn():
    try:
        conn = connect(
            dbname="postgres",
            user="postgres",
            host="127.0.0.1",
            password="postgre",
            connect_timeout=3
        )

        cur = conn.cursor()

        now = str(datetime.datetime.now())
        logging.info(now + ' - Connected successfully.')

        return cur, conn

    except (Exception, Error) as err:
        conn = None
        cur = None

def loadjsondata(json_data, table_name):
    now = str(datetime.datetime.now())

    try:
        cur, conn = postgreconn()
        with conn.cursor() as cur:
            query_sql = """ insert into dell_tests.{0}
                select * from json_populate_recordset(NULL::dell_tests.{0}, %s) """.format(table_name)
            print(query_sql)
            cur.execute(query_sql, (json.dumps(json_data),))
            conn.commit()

    except Exception as ex:
        logging.error(now + ' - Error on load table with message: ' + str(ex))
    finally:
        cur.close()
        conn.close()

def loadcsvdata(csv):
    now = str(datetime.datetime.now())

    try:
        cur, conn = postgreconn()
        with open(csv, 'r') as f:
            cur.copy_expert("""COPY dell_tests.countries_of_the_world FROM '{0}' delimiter ',' CSV HEADER""".format(csv), f)
            conn.commit()
    except Exception as ex:
        logging.error(now + ' - Error on load table with message: ' + str(ex))
    finally:
        cur.close()
        conn.close()

