#!/usr/bin/env python3
import os
import json
import urllib.request
import sqlite3
import subprocess
import re


def col(text, rgb):
    return f"\033[38;2;{rgb[0]};{rgb[1]};{rgb[2]}m{text}\033[0m"


def get_harness_info():
    # Define One Dark Color Palette
    C_MODEL = (229, 192, 123)       # Tan/Yellow (#e5c07b)
    C_SEP = (92, 99, 112)           # Dark Gray (#5c6370)
    C_PATH = (152, 195, 121)        # Green (#98c379)
    C_STATUS = (198, 120, 221)      # Purple (#c678dd)
    C_CONTEXT = (209, 154, 102)     # Orange (#d19a66)
    C_5H = (224, 108, 117)          # Pink/Red (#e06c75)
    C_WEEKLY = (224, 108, 117)      # Pink/Red (#e06c75)
    C_MODE = (171, 178, 191)        # Gray (#abb2bf)

    # 1. Get model name from settings
    settings_path = os.path.expanduser('~/.gemini/antigravity-cli/settings.json')
    model_name = "Unknown Model"
    try:
        with open(settings_path, 'r') as f:
            settings = json.load(f)
            model_name = settings.get('model', 'Unknown Model')
    except Exception:
        pass

    # Normalize model display (e.g., "gemini 3.7 flash high")
    model_display = model_name.lower().replace(" (", " ").replace(")", "")

    # 2. Get path with tilde expansion
    path = os.getcwd()
    home = os.path.expanduser('~')
    if path.startswith(home):
        path = path.replace(home, '~', 1)

    # 3. Trace parent agy process for session info
    pid = os.getpid()
    agy_pid = None
    for _ in range(10):
        try:
            ppid_str = subprocess.check_output(["ps", "-o", "ppid=", "-p", str(pid)]).decode().strip()
            ppid = int(ppid_str)
            comm = subprocess.check_output(["ps", "-o", "comm=", "-p", str(ppid)]).decode().strip()
            if "agy" in comm.lower():
                agy_pid = ppid
                break
            pid = ppid
        except Exception:
            break

    ports = []
    conv_id = None

    if agy_pid:
        try:
            lsof_output = subprocess.check_output(["lsof", "-a", "-p", str(agy_pid), "-iTCP", "-sTCP:LISTEN"]).decode()
            for line in lsof_output.splitlines():
                match = re.search(r':(\d+)\s+\(LISTEN\)', line)
                if match:
                    ports.append(int(match.group(1)))
        except Exception:
            pass

        try:
            lsof_files = subprocess.check_output(["lsof", "-p", str(agy_pid)]).decode()
            for line in lsof_files.splitlines():
                if "conversations/" in line and ".db" in line and not ".db-" in line:
                    match = re.search(r'conversations/([a-f0-9\-]+)\.db', line)
                    if match:
                        conv_id = match.group(1)
                        break
        except Exception:
            pass

    # 4. Fetch quota info
    pct_5h = 100
    pct_weekly = 100
    for port in ports:
        url = f"http://localhost:{port}/exa.language_server_pb.LanguageServerService/RetrieveUserQuotaSummary"
        try:
            req = urllib.request.Request(
                url,
                data=b"{}",
                headers={"Content-Type": "application/json"}
            )
            with urllib.request.urlopen(req) as resp:
                data = json.loads(resp.read().decode('utf-8'))
                groups = data.get('response', {}).get('groups', [])
                found = False
                for group in groups:
                    is_gemini_group = "gemini" in group.get('displayName', '').lower()
                    is_gemini_model = "gemini" in model_name.lower()

                    if (is_gemini_model and is_gemini_group) or (not is_gemini_model and not is_gemini_group):
                        for bucket in group.get('buckets', []):
                            window = bucket.get('window', '')
                            fraction = bucket.get('remainingFraction', 1.0)
                            pct = int(fraction * 100)
                            if "5h" in window:
                                pct_5h = pct
                            else:
                                pct_weekly = pct
                        found = True
                if found:
                    break
        except Exception:
            pass

    # 5. Estimate context size percentage left and check goal status
    context_left_pct = 100
    status_str = "Ready"
    if conv_id:
        db_path = os.path.expanduser(f'~/.gemini/antigravity-cli/conversations/{conv_id}.db')
        if os.path.exists(db_path):
            try:
                conn = sqlite3.connect(db_path)
                cursor = conn.cursor()

                # Fetch trajectory_type
                cursor.execute("SELECT trajectory_type FROM trajectory_meta LIMIT 1")
                type_row = cursor.fetchone()
                traj_type = type_row[0] if type_row else 1

                # Fetch last step status
                cursor.execute("SELECT status FROM steps ORDER BY idx DESC LIMIT 1")
                status_row = cursor.fetchone()
                last_status = status_row[0] if status_row else 3 # default to completed/idle

                if traj_type == 4:
                    if last_status == 2:
                        status_str = "Goal: Pursuing"
                    else:
                        status_str = "Goal: Active"
                else:
                    if last_status == 2:
                        status_str = "Running"
                    else:
                        status_str = "Ready"

                cursor.execute("SELECT idx, size FROM gen_metadata ORDER BY idx DESC LIMIT 1")
                row = cursor.fetchone()
                if row:
                    idx, size = row
                    tokens = size / 4  # Estimate ~4 bytes per token

                    # Determine context limit based on model class
                    max_tokens = 200000
                    model_lower = model_name.lower()
                    if "flash" in model_lower:
                        max_tokens = 1048576
                    elif "pro" in model_lower:
                        max_tokens = 2097152
                    elif "sonnet" in model_lower or "opus" in model_lower:
                        max_tokens = 200000
                    elif "gpt" in model_lower:
                        max_tokens = 128000

                    used_fraction = tokens / max_tokens
                    context_left_pct = max(0, min(100, int((1.0 - used_fraction) * 100)))
                conn.close()
            except Exception:
                pass

    # 6. Format and assemble statusline parts
    parts = [
        col(model_display, C_MODEL),
        col(path, C_PATH),
        col(status_str, C_STATUS),
        col(f"Context {context_left_pct}% left", C_CONTEXT),
        col(f"5h {pct_5h}% left", C_5H),
        col(f"weekly {pct_weekly}% left", C_WEEKLY),
        col("Agent", C_MODE)
    ]

    sep = col(" · ", C_SEP)
    print(sep.join(parts))


if __name__ == '__main__':
    get_harness_info()
