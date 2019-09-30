#!/usr/bin/env python3
import os
import subprocess
import re
import shutil
import sys

systemd_template = """
[Unit]
Description={unit_name}
After=network.target
Requires=mongod.service

[Service]
Type=simple
ExecStart={dir_path}/{script_name}
WorkingDirectory={db_path}
User={user}
Group={group}
TimeoutSec=15
Restart=always

[Install]
WantedBy=multi-user.target
"""

sense = {}


def printe(m):
    print("\033[91mERROR:\033[0m " + m)


def get_systemd_units_path():
    result = None
    regm = re.compile(r"^FragmentPath=(.+)$")
    cmd = ["systemctl show -p FragmentPath systemd-sysctl.service"]
    data = subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True)
    if not data is None:
        m = re.match(regm, data.decode("utf-8"))
        if not m is None:
            result = os.path.dirname(m.group(1))
    return result


def check_systemd():
    print("Checking \033[36msystemd\033[0m... ", end="")
    r = shutil.which("systemctl")
    if not r is None:
        c = get_systemd_units_path()
        if not c is None:
            sense["systemd-path"] = c
            print("DONE")
        else:
            print("FAILED")
            printe("Could not obtain \033[36msystemd\033[0m configuration!")
            exit(-1)
    else:
        print("FAILED")
        printe("\033[36msystemd\033[0m has not beed installed!")
        exit(-1)


def generate_systemd_unit(unit, dir_path, db_path, user, group):
    result = (None, None)
    units = {
        "puma": ["puma", "Puma App", "puma.service"]
    }
    if unit in units:
        data = {
            "unit_name": units[unit][1],
            "script_name": units[unit][0],
            "dir_path": dir_path,
            "db_path": db_path,
            "user": user,
            "group": group
        }
        template = None
        template = systemd_template.format(**data)
        result = (units[unit][2], template)
    return result


def enable_unit(n):
    print("Enabling service \033[36m{0}\033[0m... ".format(n), end="")
    result = False
    cmd = ["systemctl enable {0}".format(n)]
    data = subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True)
    if not data is None:
        data = data.decode("utf-8")
        if data.startswith("Created symlink"):
            result = True
    if result:
        print("DONE")
    else:
        print("FAILED")
        exit(-1)
    return result


def status_unit(n):
    cmd = "systemctl show -p UnitFileState,ActiveState {0}"
    cmd = cmd.format(n)
    cmd = [cmd]
    res = {"enabled": None, "running": None}
    data = subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True)
    if not data is None:
        dregex = re.compile(r"^(\w+)=(\w+)$")
        data = data.decode("utf-8")
        for n in data.split("\n"):
            m = re.match(dregex, n)
            if not m is None:
                if m.group(1) == "UnitFileState":
                    if m.group(2) == "enabled":
                        res["enabled"] = True
                    else:
                        res["enabled"] = False
                elif m.group(1) == "ActiveState":
                    if m.group(2) == "active":
                        res["running"] = True
                    else:
                        res["running"] = False
    return res


def start_unit(n):
  print("Starting service \033[36m{0}\033[0m... ".format(n), end = "")
  sys.stdout.flush()
  result = False
  cmd = ["systemctl start {0}".format(n)]
  data = subprocess.check_output(cmd, stderr = subprocess.STDOUT, shell = True)
  if not data is None:
    data = data.decode("utf-8")
    if data == "":
      r = status_unit(n)
      if r["running"]:
        print("DONE")
        result = True
  if not result:
    print("FAILED")
    exit("")


def reload_units():
    print("Reloading \033[36msystemd\033[0m units... ", end="")
    result = False
    cmd = ["systemctl daemon-reload"]
    data = subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True)
    if not data is None:
        data = data.decode("utf-8")
        result = True
    if result:
        print("DONE")
    else:
        print("FAILED")
        exit(-1)
    return result


def write_units():
    print("Creating systemd services...")
    units = [
        ["puma", "puma", sense["app-user"], sense["app-group"]]
    ]
    daemon_reload = False
    for unit in units:
        dest = sense["destination"]
        dbpath = sense["db-path"]
        name, value = generate_systemd_unit(unit[0], dest, dbpath, unit[2], unit[3])
        print(value)
        destname = os.path.join(sense["systemd-path"], name)
        overwrite = False
        while True:
            print("Writing \033[36m{0}\033[0m... ".format(destname), end="")
            if overwrite or (not os.path.exists(destname)):
                if overwrite:
                    daemon_reload = True
                try:
                    with open(destname, "wt") as file:
                        os.fchmod(file.fileno(), mode=0o644)
                        file.write(value)
                    print("DONE")
                    if not overwrite:
                        enable_unit(name)
                    else:
                        status = status_unit(name)
                        if not status["enabled"]:
                            enable_unit(name)
                    break
                except:
                    print("FAILED")
                    exit(-1)
            else:
                print("EXIST")
                overwrite = False
                if not overwrite:
                    overwrite = True
                else:
                    status = status_unit(name)
                    if not status["enabled"]:
                        enable_unit(name)
                    break

    if daemon_reload:
        reload_units()
    print()


if __name__ == '__main__':
    check_systemd()
    sense["destination"] = "/usr/local/bin"
    sense["db-path"] = "/home/appuser/reddit"
    sense["app-user"] = "appuser"
    sense["app-group"] = "appuser"
    write_units()
    start_unit("puma")
    exit(0)
