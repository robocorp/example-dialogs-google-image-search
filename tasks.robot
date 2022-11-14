*** Settings ***
Documentation       Example robot that allows a human to search for a specific
...                 search query in Google Images.

Library             RPA.Browser.Selenium
Library             RPA.Dialogs

Suite Teardown      Close All Browsers


*** Tasks ***
Save the first image for a search query collected from the user
    TRY
        ${search_query}=    Collect search query from user
        Search Google Images    ${search_query}
        Collect the first search result image
    EXCEPT
        Capture Page Screenshot    %{ROBOT_ARTIFACTS}${/}error.png
        Fail    Checkout the screenshot: error.png
    END


*** Keywords ***
Collect search query from user
    Add text input    search    label=Search query
    ${response}=    Run dialog
    RETURN    ${response.search}

Reject Google Cookies
    Click Element If Visible    xpath://button/div[contains(text(), 'Reject all')]

Accept Google Consent
    Click Element If Visible    xpath://button/div[contains(text(), 'Accept all')]

Close Google Sign in if shown
    Click Element If Visible    No thanks

Search Google Images
    [Arguments]    ${search_query}
    Open Available Browser    https://images.google.com
    Close Google Sign in if shown
    Reject Google Cookies
    Accept Google Consent
    Input Text    name:q    ${search_query}
    Submit Form

Collect the first search result image
    Wait Until Element Is Visible    css:div[data-ri="0"]
    Screenshot    css:div[data-ri="0"]
    ...    filename=%{ROBOT_ROOT}${/}output${/}image_from_google.png
