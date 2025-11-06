#!/usr/bin/env python3
import json
import re
import subprocess
import sys
import time
from typing import Any, Dict, List, Optional


COPYQ_CLASS_REGEX = re.compile(r"^(copyq|CopyQ)$", re.IGNORECASE)


def run_i3_msg(args: List[str]) -> subprocess.CompletedProcess:
    return subprocess.run(["i3-msg", *args], capture_output=True, text=True, check=False)


def get_tree() -> Dict[str, Any]:
    proc = run_i3_msg(["-t", "get_tree"])
    if proc.returncode != 0 or not proc.stdout:
        return {}
    try:
        return json.loads(proc.stdout)
    except Exception:
        return {}


def walk_nodes(node: Dict[str, Any]) -> List[Dict[str, Any]]:
    nodes: List[Dict[str, Any]] = [node]
    for key in ("nodes", "floating_nodes"):
        for child in node.get(key, []) or []:
            nodes.extend(walk_nodes(child))
    return nodes


def find_copyq_cons(tree: Dict[str, Any]) -> List[Dict[str, Any]]:
    results: List[Dict[str, Any]] = []
    for n in walk_nodes(tree):
        wp = n.get("window_properties") or {}
        class_name = wp.get("class") or ""
        instance_name = wp.get("instance") or ""
        if COPYQ_CLASS_REGEX.match(class_name) or COPYQ_CLASS_REGEX.match(instance_name):
            results.append(n)
    return results


def get_focused_con_id(tree: Dict[str, Any]) -> Optional[int]:
    for n in walk_nodes(tree):
        if n.get("focused") is True:
            return n.get("id")
    return None


def con_exists(tree: Dict[str, Any], con_id: int) -> bool:
    for n in walk_nodes(tree):
        if n.get("id") == con_id:
            return True
    return False


def kill_con(con_id: int) -> None:
    # Politely close the window; CopyQ server keeps running
    run_i3_msg([f"[con_id=\"{con_id}\"]", "kill"])  # ignore result


def main() -> int:
    # 0) Ensure CopyQ server is running
    server_running = False
    try:
        # Try to check if server is running
        check_proc = subprocess.run(
            ["copyq", "eval", "print('ok')"],
            capture_output=True,
            timeout=2,
            text=True
        )
        if check_proc.returncode == 0:
            server_running = True
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass
    
    if not server_running:
        # Server not running, start it in background
        try:
            subprocess.Popen(
                ["copyq"],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                start_new_session=True
            )
            # Wait longer for server to start
            time.sleep(2)
            # Verify it started
            verify_proc = subprocess.run(
                ["copyq", "eval", "print('ok')"],
                capture_output=True,
                timeout=2,
                text=True
            )
            if verify_proc.returncode != 0:
                # Still not working, try one more time
                time.sleep(1)
        except FileNotFoundError:
            return 1
    
    # 1) Launch CopyQ menu
    try:
        subprocess.Popen(["copyq", "menu"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except FileNotFoundError:
        return 1

    # 2) Wait for the CopyQ menu window to appear
    copyq_con_id: Optional[int] = None
    deadline = time.time() + 3.0
    while time.time() < deadline:
        tree = get_tree()
        cons = find_copyq_cons(tree)
        if cons:
            # Prefer the currently focused one if multiple
            focused_id = get_focused_con_id(tree)
            chosen = None
            if focused_id is not None:
                for c in cons:
                    if c.get("id") == focused_id:
                        chosen = c
                        break
            if chosen is None:
                chosen = cons[-1]
            copyq_con_id = chosen.get("id")
            break
        time.sleep(0.05)

    if copyq_con_id is None:
        # No window appeared; nothing to do
        return 0

    # 3) Wait until the CopyQ window is focused at least once
    deadline = time.time() + 1.5
    ever_focused = False
    while time.time() < deadline:
        tree = get_tree()
        if not con_exists(tree, copyq_con_id):
            return 0  # window was closed immediately
        if get_focused_con_id(tree) == copyq_con_id:
            ever_focused = True
            break
        time.sleep(0.05)

    # 4) Monitor focus changes and close CopyQ when it loses focus or item is selected
    # Polling approach - more reliable than event subscription
    last_focused_id = copyq_con_id
    unfocused_count = 0
    check_interval = 0.1  # Check every 100ms
    
    while True:
        tree = get_tree()
        
        # If window disappeared, exit
        if not con_exists(tree, copyq_con_id):
            return 0
        
        # Get currently focused window
        focused_id = get_focused_con_id(tree)
        
        # Check if CopyQ window is still focused
        if focused_id == copyq_con_id:
            # CopyQ is focused, reset counter
            unfocused_count = 0
            last_focused_id = copyq_con_id
        else:
            # CopyQ is not focused
            if ever_focused:  # Only close if it was focused at least once
                unfocused_count += 1
                # If unfocused for 0.2 seconds (2 checks), close it
                if unfocused_count >= 2:
                    kill_con(copyq_con_id)
                    return 0
        
        # Also check if window was closed by CopyQ itself (when item is selected)
        # CopyQ closes the window automatically when an item is activated
        if not con_exists(tree, copyq_con_id):
            return 0
        
        time.sleep(check_interval)

    return 0


if __name__ == "__main__":
    sys.exit(main())


