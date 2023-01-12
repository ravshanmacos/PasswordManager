# Description
Password manager app is created for those who want to place, organize their credentials and make STRONG passwords. I know a lot of people who create new account every week and use same passwords again and again. This issue is not unfamiliar for me also. All tech people knows that using same credential again and again is very bad experience because These people are an easy target for hackers. Unfortunately, password manager apps out there are not free. So the Main reason creating this app is making app which keeps all strong password in one place and free to use 

## what I used in this app
   3rd patry libraries: 1. Realm Database 2. CryptoSwift
   

## Auth
<img src = "https://github.com/ravshanmacos/PasswordManager/blob/main/PasswordManager/Resources/Auth.png" width = "400" />
    In Authentication section, when user tries to "Sign Up", user data saved into realm database and Keychain. All the passwords data are related to user in database and user saved in Keychain help to check user existance and log out
     When user tries to "Sign In", App checks passed user credentials match user credentials in the database. If exists, User credentials are saved into Keychain and all the related data will be retrieved
## Main
<img src = "https://github.com/ravshanmacos/PasswordManager/blob/main/PasswordManager/Resources/Main.png" width = "600" />
In the Home view Controller, I used tableview to show the data retrieved from database. when user taps plus icon, new password will be generated using "Api ninja API" for new item but user also can enter password manually.
    when user taps user icon, user redirected to the user profile page.where user can edit some personal information. 

## Analysis and Search

In the Analysis view controller, as name says some analysis will be shown. 

<img src = "https://github.com/ravshanmacos/PasswordManager/blob/main/PasswordManager/Resources/AnalysisAndSearch.png" width = "400" />


## Settings and User profile

<img src = "https://github.com/ravshanmacos/PasswordManager/blob/main/PasswordManager/Resources/SettingsAndProfile.png" width = "400" />

