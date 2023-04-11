from flask import Flask, jsonify, request, render_template
from flask_cors import cross_origin

import pandas as pd
import numpy as np
import pickle

from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
from sklearn.preprocessing import MinMaxScaler
from sklearn.preprocessing import LabelEncoder

app = Flask(__name__)

#loading datasets
hotelDataset = pd.read_excel("Datasets/hotels.xlsx")
attractions_data = pd.read_csv('Datasets/attractions_mumbai.csv')
hotels_data = pd.read_csv('Datasets/hotels_mumbai.csv')
df = pd.read_csv('Datasets/hotel_booking.csv')

#model for flight
model = pickle.load(open("Trained_Models/c2_flight_rf.pkl", "rb"))

# create encoder for categorical features
airline_encoder = LabelEncoder()
source_encoder = LabelEncoder()
destination_encoder = LabelEncoder()

# helper function to extract hour and minute from datetime
def extract_time(date_time):
    hour = int(pd.to_datetime(date_time, format="%Y-%m-%dT%H:%M").hour)
    minute = int(pd.to_datetime(date_time, format="%Y-%m-%dT%H:%M").minute)
    return hour, minute

# helper function to preprocess request data
def preprocess_data(data):
    # extract date and time features
    journey_day, journey_month = extract_time(data['Dep_Time'])
    dep_hour, dep_min = extract_time(data['Dep_Time'])
    arrival_hour, arrival_min = extract_time(data['Arrival_Time'])
    duration_hour = abs(arrival_hour - dep_hour)
    duration_min = abs(arrival_min - dep_min)

    # convert categorical features into numerical features
    airline = airline_encoder.transform([data['airline']])
    source = source_encoder.transform([data['Source']])
    destination = destination_encoder.transform([data['Destination']])

    # create input features as a DataFrame
    input_features = pd.DataFrame({
        'Journey_day': journey_day,
        'Journey_month': journey_month,
        'Dep_hour': dep_hour,
        'Dep_min': dep_min,
        'Arrival_hour': arrival_hour,
        'Arrival_min': arrival_min,
        'Duration_hour': duration_hour,
        'Duration_min': duration_min,
        'Total_Stops': int(data['stops']),
        'Airline': airline,
        'Source': source,
        'Destination': destination
    })
    return input_features

# Create num_rooms_available column
df['num_rooms_available'] = df['reserved_room_type'].apply(lambda x: ord('G') - ord(x) + 1)

# Create num_rooms_booked column
df['num_rooms_booked'] = df['assigned_room_type'].apply(lambda x: ord('G') - ord(x) + 1)

# Create num_cancellations column
df['num_cancellations'] = df['previous_cancellations'] + df['previous_bookings_not_canceled']

# Create avg_length_of_stay column
df['avg_length_of_stay'] = df['stays_in_weekend_nights'] + df['stays_in_week_nights']

# Create location column
df['location'] = df['hotel'].apply(lambda x: 'City Hotel' if x == 'City Hotel' else 'Resort Hotel')

# Prepare the data
X = df[['num_rooms_available', 'num_rooms_booked', 'num_cancellations', 'avg_length_of_stay', 'location']]
X = pd.get_dummies(X)

df['vacancy_rate'] = (df['num_rooms_available'] - df['num_rooms_booked']) / df['num_rooms_available']
y = df['vacancy_rate']

df['vacancy_rate'].fillna(0, inplace=True)
df = df[~df['vacancy_rate'].isin([np.nan, np.inf, -np.inf])]
df['vacancy_rate'] = df['vacancy_rate'].replace([np.nan, np.inf, -np.inf], df['vacancy_rate'].median())

y = df['vacancy_rate'].to_numpy().reshape(-1, 1)
scaler = MinMaxScaler()
y = scaler.fit_transform(y).flatten()

df = df[df.index.isin(X.index)]
X = X[X.index.isin(df.index)]

assert len(df) == len(X)

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

y_train2 = np.where(np.isnan(y_train), 0.0, y_train)
y_test2 = np.where(np.isnan(y_test), 0.0, y_test)
model = LinearRegression()
model.fit(X_train, y_train2)

def get_attraction_lat_long(location):
    row = attractions_data[attractions_data['Attraction'] == location]
    if not row.empty:
        lat = row['Latitude'].values[0]
        long = row['Longitude'].values[0]
        return lat, long
    else:
        return None, None

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
        hotels_data['distance'] = euclidean_distance(
            hotels_data['Latitude'], hotels_data['Longitude'], target_lat, target_long)
        nearest_hotel = hotels_data.nsmallest(1, 'distance')
        nearest_locations = pd.concat(
            [nearest_locations, nearest_hotel], axis=0)
        hotels_data.drop(nearest_hotel.index, inplace=True)
        target_lat = nearest_hotel['Latitude'].values[0]
        target_long = nearest_hotel['Longitude'].values[0]
    return nearest_locations

#Travel-Plan
@app.route('/travel-plan', methods=['POST'])
def generate_travel_plan():
    data = request.get_json()
    if 'label' not in data:
        return jsonify({'error': 'label key not found in JSON data'}), 400
    else:
        label = data['label']
    # Retrieve the latitude and longitude values for the target location from the attractions dataset
    target_lat, target_long = get_attraction_lat_long(label)

    # Find the 3 closest tourist attractions to the target location from the attractions dataset
    attractions_data['distance'] = euclidean_distance(
        attractions_data['Latitude'], attractions_data['Longitude'], target_lat, target_long)
    closest_attractions = attractions_data.nsmallest(3, 'distance')

    # Generate the travel plan
    results = []
    result = f'The {len(closest_attractions)} closest tourist attractions to {label} are:\n'
    for index, row in closest_attractions.iterrows():
        result += f"{row['Attraction']} at with a distance of {row['distance']:.2f} km\n"
    results.append(result)

    # Find the 3 nearest hotels to the target location based on the target location's latitude and longitude
    hotels_data['distance'] = euclidean_distance(
        hotels_data['Latitude'], hotels_data['Longitude'], target_lat, target_long)
    closest_hotels = hotels_data.nsmallest(3, 'distance')

    # Add the nearest hotels to the travel plan
    result = f'\nThe {len(closest_hotels)} closest hotels to {label} are:\n'
    for index, row in closest_hotels.iterrows():
        result += f"{row['Name']} at with a distance of {row['distance']:.2f} km\n"
    results.append(result)

    # Return the travel plan as a JSON response
    return jsonify({'result': results})

#Hotel vacancy
@app.route('/predict_hotel_vacancy')
def home():
    # Make a prediction
    prediction = model.predict(X_test)
    # Store the predictions in a list
    prediction_list = prediction.tolist()
    # Print only the first prediction value
    return str(prediction_list[0]*100)


#Hotel Price
# Define a route for the hotel price predictor
@app.route('/predict_hotel_price')
def predict_price():
    # Get the hotel name from the request parameters
    hotel_name = request.args.get('hotel_name')
    
    # Get the row for the specified hotel name
    hotel_data = hotelDataset[hotelDataset['Hotel_name'] == hotel_name]

    # Check if any data was found for the specified hotel name
    if len(hotel_data) == 0:
        return jsonify({'error': f"No data found for {hotel_name}."})
    else:
        # Extract the features for the specified hotel name
        features = hotel_data[['Hotel star rating', 'Distance', 'Rooms', 'Squares']]

        # Load the trained model
        regressor = LinearRegression()
    regressor.fit(features, hotel_data['Price(BAM)'])

    # Predict the price for the specified hotel
    predicted_price = regressor.predict(features)

    return jsonify({'predicted_price': predicted_price[0]})


@app.route("/predict_flight_price", methods=["POST"])
@cross_origin()
def predict():
    # parse JSON request data
    request_data = request.get_json()
    # preprocess request data
    input_data = preprocess_data(request_data)
    # make prediction using the model
    prediction = model.predict(input_data)
    # convert prediction into a human-readable format
    output = round(prediction[0], 2)
    # create JSON response
    response = {'flight_price': output}
    return jsonify(response)


if __name__ == '__main__':
    app.run(debug=True)