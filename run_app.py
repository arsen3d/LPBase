import subprocess
import os
import re
import json
import asyncio
import websockets
import argparse

# Set the PYTHONUNBUFFERED environment variable to force unbuffered output
env = os.environ.copy()
env["PYTHONUNBUFFERED"] = "1"
async def send_message(websocket, to, link):
    message = {
        "type": "direct_message",
        "targetId": to,
        "message": link.strip()
    }
    print(f"Sending: {message}")
    await websocket.send(json.dumps(message))
    response = await websocket.recv()
    print(f"Received: {response}")

async def main(command):
    uri = "wss://socket.apps.devnet.arsenum.com"
    try:
        async with websockets.connect(uri) as websocket:
            with open('app.log', 'w') as log_file:
                # print("calling"+ command)
                process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, env=env)

                # Print each line from the subprocess output
                for line in process.stdout:
                    log_file.write(line)
                    log_file.flush()
                    print(line, end='')
                    await send_message(websocket,  os.getenv('CALL_BACK'), line)

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Run the app with a command.')
    parser.add_argument('command', nargs=argparse.REMAINDER, help='The command to run.')
    args = parser.parse_args()

    print("args.command", args.command)
    asyncio.run(main(args.command))