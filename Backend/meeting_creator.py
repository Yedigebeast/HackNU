from datetime import datetime, timedelta
from google.oauth2 import service_account
from googleapiclient.discovery import build
import uuid

# Authenticate with Google Calendar API
SCOPES = ['https://www.googleapis.com/auth/calendar']
SERVICE_ACCOUNT_FILE = 'credentials.json'  # Path to your service account credentials
credentials = service_account.Credentials.from_service_account_file(
    SERVICE_ACCOUNT_FILE, scopes=SCOPES)

# Build the service
service = build('calendar', 'v3', credentials=credentials)

def create_event_link(startTime: datetime, endTime: datetime):
    request_id = str(uuid.uuid4())
    meeting_id = str(uuid.uuid4())
    conference_data = {
        'createRequest' : { 'requestId': requestId }
    } 

    conference = service.conferences().create(
        requestId=request_id,
        body = {'conferenceData': conference_data}
    ).execute()

    link = conference.get('entryPoints', [])[0].get('uri')
    return link