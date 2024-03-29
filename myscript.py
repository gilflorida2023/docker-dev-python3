#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import time
import os
import json
from selenium import webdriver
from browser_extension import ChromeExtension
import psutil
from selenium.webdriver.chrome.options import Options
def get_child_process_info(parent_pid):
    for proc in psutil.process_iter(['pid', 'name', 'ppid']):
        try:
            process_info = proc.info
            if process_info['ppid'] == parent_pid:
                return process_info
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            return None

chrome_options = webdriver.ChromeOptions()
path_to_brave = '/opt/brave.com/brave/brave'
chrome_options.binary_location = path_to_brave
chrome_options.add_argument("--disable-gpu")
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--disable-dev-shm-usage")
chrome_options.add_argument("--verbose")
chrome_options.add_argument("--incognito")
#chrome_options.add_experimental_option("detach", True)

browser = webdriver.Chrome(options=chrome_options)
browser.get("https://www.google.com/")
print(f'browser.service.process: {browser.service.process.pid}\n',  file=sys.stderr)
#####################3
# create list of child pids to  monitor.gotta keep an eye on the new pids created for brave.
# poll proc an end when the brave pids end, not before.

# get children of pid
current_pid = browser.service.process.pid
brave_pids=[]
DONE=False
while not DONE:
    process_info=get_child_process_info(current_pid)
    if process_info is not None:
        print(process_info,  file=sys.stderr)
        current_pid =process_info['pid']
        brave_pids.append(process_info)
    else:
        DONE=True
# load ini file
# list of extensions to load is in config.ini. 

# load ech of the specified extenions.
# URL for ublock origin.
# https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm


#https://github.com/gorhill/uBlock/releases/download/1.56.0/uBlock0_1.56.0.chromium.zip
#extension_url = 'https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm'
#chrome_version = '1.56.0'
#path = ChromeExtension(extension_url, chrome_version).download()
#print(f'New extension stored here: {path}\n',  file=sys.stderr)
#
#options = webdriver.ChromeOptions()
#options.add_extension(path)
#driver = webdriver.Chrome(options=options)
# keep brave from exiting, so o
print(f'Kill browser window or press control-C to exit',  file=sys.stderr)

DONE = False
while  not DONE:
    for i in range(0,len(brave_pids)):
        directory_path = f"/proc/{brave_pids[i]['pid']}"
        if not os.path.isdir(directory_path):
            DONE=True
    if not DONE:
        time.sleep(5)
browser.quit()
sys.exit(0)

