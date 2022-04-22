*** Settings ***
Documentation     Insert the sales data for the week and export it as a PDF
Library           RPA.Browser.Selenium    auto_close=${FALSE}
Library           RPA.HTTP
Library           RPA.Excel.Files
Library           RPA.Robocloud.Items
Library           RPA.PDF
Library           RPA.Email.ImapSmtp    smtp_server=smtp.gmail.com    smtp_port=587
Library           DateTime
Library           RPA.FileSystem

*** Variables ***
${USERNAME}       %{USERNAME}
${PASSWORD}       %{PASSWORD}
${RECIPIENT}      hitsumit@yopmail.com
@{files}          sales_results.pdf    sales_summary.png

*** Tasks ***
Insert the sales data for the week and export it as a PDF
    Open the intranet website
    Log in
    Download the Excel file
    Fill the form using the data from the Excel file
    Collect the results
    Export the table as a PDF
    Email the result
    [Teardown]    Log out and close the browser

*** Keywords ***
Open the intranet website
    Open Browser    https://robotsparebinindustries.com/

Log in
    Input Text    username    maria
    Input Password    password    thoushallnotpass
    Submit Form
    Wait Until Page Contains Element    id:sales-form

Download the Excel file
    Download    https://robotsparebinindustries.com/SalesData.xlsx    overwrite=True

Fill the form using the data from the Excel file
    Open Workbook    SalesData.xlsx
    ${sales_reps}=    Read Worksheet As Table    header=true
    Close Workbook
    FOR    ${sales_rep}    IN    @{sales_reps}
        Fill and submit the form for one person    ${sales_rep}
    END

Fill and submit the form for one person
    [Arguments]    ${sales_rep}
    Input Text    firstname    ${sales_rep}[First Name]
    Input Text    lastname    ${sales_rep}[Last Name]
    Input Text    salesresult    ${sales_rep}[Sales]
    Select From List By Value    salestarget    ${sales_rep}[Sales Target]
    Click Button    Submit

Collect the results
    Screenshot    css:div.sales-summary    ${OUTPUT_DIR}${/}sales_summary.png

Export the table as a PDF
    Wait Until Element Is Visible    id:sales-results
    ${sales_results_html}=    Get Element Attribute    id:sales-results    outerHTML
    Html To Pdf    ${sales_results_html}    ${OUTPUT_DIR}${/}sales_results.pdf

Log out and close the browser
    Click Button    logout
    Close Browser

Email the result
    Authorize    account=${USERNAME}    password=${PASSWORD}
    ${date}=    Get Current Date
    Send Message    sender=${USERNAME}    recipients=${RECIPIENT}
    ...    subject=Redhouane Sobaihi RPA ${date}
    ...    attachments=@{files}
