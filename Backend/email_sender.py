import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def send_email(senderEmail: str, receiverEmail: str, link: str):
    # Email configurations
    sender_email = senderEmail
    receiver_email = receiverEmail
    password = "your_password"

    # Create a message
    message = MIMEMultipart()
    message["From"] = sender_email
    message["To"] = receiver_email
    message["Subject"] = "Qurultai Incoming"

    # Add body to email
    body = "Qurultai Incoming, Keshikbe brat.\nLink:{link}.".format(link=link)
    message.attach(MIMEText(body, "plain"))

    # Connect to Gmail's SMTP server
    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
        # Login to your Gmail account
        server.login(sender_email, password)
    
        # Send the email
        server.sendmail(sender_email, receiver_email, message.as_string())

