import requests
import json

# Base URL of the Listnr API
base_url = "https://bff.listnr.tech/api/tts/v1/"

# Endpoint for converting text to speech
endpoint = "convert-text"

# Your API key
api_key = "EV5CRHE-M43415B-N9N4ZEB-FWSST35"

# Construct the headers with the API key
headers = {
    "Content-Type": "application/json",
    "x-listnr-token": api_key,
    # "globalSpeed": "20%"

}

# Text to convert to speech
text = "Едіге өте мықты және ақылды және күшті жігіт"

voice_id = "kk-KZ-AigulNeural"
# Request body
data = {
    "voice": voice_id,
    "ssml": "<speak>Едіге өте мықты және ақылды және күшті жігіт</speak>",
    # "globalSpeed": "150%",
}

# Send the POST request to the Listnr API
print(base_url + endpoint, headers, data)
response = requests.post(base_url + endpoint, headers=headers, data=json.dumps(data))

# Check if the request was successful
if response.status_code == 200:
    try:
        # Try to parse the JSON response
        result = response.json()
        print(result)
        audio_url = result.get("audioUrl")
        if audio_url:
            print("Audio URL:", audio_url)
        else:
            print("No audio URL found in the response.")
    except json.JSONDecodeError:
        print("Failed to parse JSON response.")
else:
    print("Failed to convert text to speech. Status code:", response.status_code)