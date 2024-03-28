#!/usr/bin/env python3

import sys
import time
from selenium import webdriver
import psutil
chrome_options = webdriver.ChromeOptions()
#path_to_brave = '/usr/bin/brave-browser'
path_to_brave = '/opt/brave.com/brave/brave'
chrome_options.binary_location = path_to_brave
chrome_options.add_argument("--disable-gpu")
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--disable-dev-shm-usage")
chrome_options.add_argument("--verbose")
chrome_options.add_argument("--incognito")
#chrome_options.add_experimental_option("detach", True)

browser = webdriver.Chrome(options=chrome_options)
pid = browser.service.process.pid
print(pid)
browser.get("https://www.google.com/")
# load ini file
# list of extensions to load is in config.ini. 


# keep brave from exiting, so 
print('press control-C to exit')
while  psutil.pid_exists(pid):    
    time.sleep(60)
browser.quit()

sys.exit(0)

