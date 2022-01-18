*** Settings ***
Documentation     Example robot that allows a human to search for a specific
...               search query in Google Images.
Library           RPA.Browser.Selenium
Library           RPA.Dialogs
Suite Teardown    Close All Browsers

*** Keywords ***
Collect search query from user
    Add text input    search    label=Search query
    ${response}=    Run dialog
    [Return]    ${response.search}

*** Keywords ***
Accept Google consent
    Click Element    xpath://button/div[contains(text(), 'I agree')]

*** Keywords ***
Search Google Images
    [Arguments]    ${search_query}
    Open Available Browser    https://images.google.com
    Run Keyword And Ignore Error    Accept Google Consent
    Input Text    name:q    ${search_query}
    Submit Form

*** Keywords ***
Collect the first search result image
    Wait Until Element Is Visible    css:div[data-ri="0"]
    Screenshot    css:div[data-ri="0"]
    ...    filename=%{ROBOT_ROOT}${/}output${/}image_from_google.png

*** Tasks ***
Save the first image for a search query collected from the user
    ${search_query}=    Collect search query from user
    Search Google Images    ${search_query}
    Collect the first search result image
