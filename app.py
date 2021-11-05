"""
Silly slack app for fun
"""
import os
from slack_bolt import App

app = App(
    token=os.environ.get("SLACK_BOT_TOKEN"),
    signing_secret=os.environ.get("SLACK_SIGNING_SECRET")
)

@app.command("/sb")
def format_for_serious_business(ack, respond, command):
    """
    Takes the /sb text and wraps it in BEGIN/END Serious Business tags.
    """
    # Acknowledge command request
    ack()
    blocks = [{
            "type": "section",
            "text": {
                "type": "mrkdwn",
                # pylint: disable=line-too-long
                "text": f"```-------------BEGIN Serious Business----------------\n{command['text']}\n-------------END Serious Business------------------```"
            }
    }]

    respond(
        blocks = blocks,
        response_type = "in_channel"
    )

if __name__ == "__main__":
    app.start(port=int(os.environ.get("PORT", 3000)))
