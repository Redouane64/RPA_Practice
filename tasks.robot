*** Settings ***
Documentation     Insert the sales data for the week and export it as a PDF
Library           RPA.Browser.Selenium

*** Tasks ***
Insert the sales data for the week and export it as a PDF
    Open the intranet website

*** Keywords ***
Open the intranet website
    Open Browser    https://robotsparebinindustries.com/
