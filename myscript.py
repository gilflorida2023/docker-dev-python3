#!/usr/bin/env python3
from seleniumwire import webdriver # to be able to use proxy
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.common.by import By

# load selenium for brave
chrome_options = webdriver.ChromeOptions()
chrome_options.binary_location = '/usr/bin/brave-browser'
browser = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()), options=chrome_options)

browser.get('brave://settings/shields')

# load ini file
# list of extensions to load is in config.ini. 
