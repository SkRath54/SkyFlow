import json
import random
from datetime import datetime, timedelta
import uuid
import os
from pathlib import Path

flights = ["DL1845", "DL1067", "DL2231", "DL763"]
airports = [("BAN", "BHU"), ("DEL", "HYD"), ("CHE", "KOL"), ("MUM", "GAN")]
ticket_classes = ["ECONOMY", "BUSINESS", "FIRST"]
event_types = ["CHECKIN", "BOARDING", "CANCELLED", "MISSED_FLIGHT", "BAGGAGE_DROP"]

OUTPUT_DIR = Path(__file__).resolve().parent / "passenger_events"
os.makedirs(OUTPUT_DIR, exist_ok=True)

def generate_random_timestamp(start_days_ago=1500, end_days_ahead=7):
    """
    Generates a random timestamp between `start_days_ago` in the past and `end_days_ahead` in the future.
    """
    now = datetime.utcnow()
    start = now - timedelta(days=start_days_ago)
    end = now + timedelta(days=end_days_ahead)
    random_timestamp = start + (end - start) * random.random()
    return random_timestamp.isoformat()

def generate_passenger_event():
    flight = random.choice(flights)
    departure, arrival = random.choice(airports)
    return {
        "event_id": str(uuid.uuid4()),
        "flight_number": flight,
        "departure_airport": departure,
        "arrival_airport": arrival,
        "passenger_id": f"PAX{random.randint(10000, 99999)}",
        "event_type": random.choice(event_types),
        "event_timestamp":  generate_random_timestamp(),
        "seat_number": f"{random.randint(1, 40)}{random.choice(['A','B','C','D','E','F'])}",
        "ticket_class": random.choice(ticket_classes)
    }

def save_events_to_file(n=1000, folder="passenger_events"):
    os.makedirs(folder, exist_ok=True)
    for i in range(n):
        event = generate_passenger_event()
        with open(os.path.join(OUTPUT_DIR, f"event_{i + 1}.json"), "w") as f:
            json.dump(event, f, indent=2)
    print(f"{n} events generated in folder '{folder}'.")

if __name__ == "__main__":
    save_events_to_file(n=1000)
