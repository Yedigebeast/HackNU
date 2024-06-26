import requests
import json
from Text import get_random_text

# Base URL of the Listnr API
base_url = "https://bff.listnr.tech/api/tts/v1/"

# Endpoint for converting text to speech
endpoint = "convert-text"

# Your API key
api_key = "YERX3DC-Q45MAYZ-GABZSD7-N8E1S7V"

# Construct the headers with the API key
headers = {
    "Content-Type": "application/json",
    "x-listnr-token": api_key
}

voice_id = "kk-KZ-AigulNeural"


def audio():
    text = get_random_text()
    data = {
        "voice": voice_id,
        "ssml": f"<speak>{text}</speak>",
    }
    response = requests.post(base_url + endpoint, headers=headers, data=json.dumps(data))
    if response.status_code == 200:
        try:
            result = response.json()
            print(result)
            audio_url = result.get("url")
            if audio_url:
                text_encoded = text.encode('utf-8').decode('utf-8')
                return text_encoded.split(), audio_url
            else:
                print("No audio URL found in the response.")
        except json.JSONDecodeError:
            print("Failed to parse JSON response.")
    else:
        print("Failed to convert text to speech. Status code:", response.status_code)
    return None
