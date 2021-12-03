import utils


def main():
    # get the json data
    json_data = utils.getjsondata('https://opendata.ecdc.europa.eu/covid19/nationalcasedeath/json/')

    # load json data into table
    utils.loadjsondata(json_data, 'covid_number_cases')

    # get data to enrichment
    json_data = utils.getjsondata('https://opendata.ecdc.europa.eu/covid19/hospitalicuadmissionrates/json/')

    # load json data enrichment table
    utils.loadjsondata(json_data, 'hospital_occupancy')

    # load csv data into table
    utils.loadcsvdata('C:/projects/dell_test/src/covid_data_pipeline_ingestion/data/countries_of_the_world.csv')

if __name__ == "__main__":
    main()



