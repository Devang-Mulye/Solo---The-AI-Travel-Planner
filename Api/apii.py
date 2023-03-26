from flask import Flask, render_template, request, jsonify
import pandas as pd
import numpy as np

app = Flask(__name__)

# Define a function that retrieves the latitude and longitude values for a given location from the attractions dataset
def get_attraction_lat_long(location):
    row = attractions_data[attractions_data['Attraction'] == location]
    if not row.empty:
        lat = row['Latitude'].values[0]
        long = row['Longitude'].values[0]
        return lat, long
    else:
        return None, None

# Define a function that retrieves the latitude and longitude values for a given location from the hotels dataset
def get_hotel_lat_long(location):
    row = hotels_data[hotels_data['Name'] == location]
    if not row.empty:
        lat = row['Latitude'].values[0]
        long = row['Longitude'].values[0]
        return lat, long
    else:
        return None, None

# Define a function that calculates the Euclidean distance between two points in latitude-longitude space
def euclidean_distance(lat1, long1, lat2, long2):
    return np.sqrt((lat1 - lat2)**2 + (long1 - long2)**2)

# Define a function that finds the nearest locations in the dataset based on latitude and longitude using greedy nearest neighbor algorithm
def find_nearest_locations(target_lat, target_long, num_locations=3):
    nearest_locations = pd.DataFrame(columns=hotels_data.columns)
    for i in range(num_locations):
        hotels_data['distance'] = euclidean_distance(hotels_data['Latitude'], hotels_data['Longitude'], target_lat, target_long)
        nearest_hotel = hotels_data.nsmallest(1, 'distance')
        nearest_locations = pd.concat([nearest_locations, nearest_hotel], axis=0)
        hotels_data.drop(nearest_hotel.index, inplace=True)
        target_lat = nearest_hotel['Latitude'].values[0]
        target_long = nearest_hotel['Longitude'].values[0]
    return nearest_locations

@app.route('/')
def home():
    return render_template()

@app.route('/predict',methods=['GET'])
def predict():
    # Load the dataset containing location names and their corresponding latitude and longitude values into a pandas DataFrame
    attractions_data = pd.read_csv(r'C:\Users\parak\Downloads\attractions_mumbai.csv')

    # Load the dataset containing hotel names and their corresponding latitude and longitude values into a pandas DataFrame
    hotels_data = pd.read_csv(r'C:\Users\parak\Downloads\hotels_mumbai.csv')

    # Input for number of days and others
    list_location = []
    days = int(input("Number of days:"))

    for i in range(days):
        list_location.append(input())
    for location_name in list_location:

        # Retrieve the latitude and longitude values for the target location from the attractions dataset
        target_lat, target_long = get_attraction_lat_long(location_name)

        # Find the 3 closest tourist attractions to the target location from the attractions dataset
        attractions_data['distance'] = euclidean_distance(attractions_data['Latitude'], attractions_data['Longitude'], target_lat, target_long)
    closest_attractions = attractions_data.nsmallest(3, 'distance')

    # Print the 3 closest tourist attractions to the target location
    result = f'The {len(closest_attractions)} closest tourist attractions to {location_name} are:\n'
    for index, row in closest_attractions.iterrows():
        result += f"{row['Attraction']} at with a distance of {row['distance']:.2f} km\n"

    # Find the 3 nearest hotels to the target location based on the target location's latitude and longitude
    nearest_hotels = find_nearest_locations(target_lat, target_long)

    # Print the results
    result += f'\nThe {len(nearest_hotels)} nearest hotels to {location_name} are:\n'
    for index, row in nearest_hotels.iterrows():
        result += f"{row['Name']}, with a distance of {row['distance']:.2f} km \n"
    # print(result)

    # import openai

    openai.api_key = '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'
    messages = [
        {"role": "system", "content": "Make a detailed travel plan for an entire day where the user visits the 3 tourist attractions given below and 3 hotel given below, Only take places from input for the plan"},
    ]
    message = result
    if message:
        messages.append(
            {"role": "user", "content": message},
        )
        chat = openai.ChatCompletion.create(
            model="gpt-3.5-turbo", messages=messages
        )

    reply = chat.choices[0].message.content
    # print(f"Solo - The AI Travel Planner: {reply}")
    messages.append({"role": "assistant", "content": reply})

    final_output= result + reply
    print(final_output)
    
# just for test purpose
    return "Hii"


if __name__ == '__main__' :
    app.run(debug=True)
