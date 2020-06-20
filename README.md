# Automatic Screenshot Generation Sample Code 

The aim of this repository is to provide an example on how to modify an app and add UITests and scripts in order to take a screenshot of every single screen of the app in multiple configurations (language, device size, appearance...) and generate a report containing these screenshots.

The steps will be the following:
- Introduce `Configurable` notion and create configurable versions of each submodels that needs it.
- Create a UITest that navigates through the app and takes screenshots
- Add a script that can build and run this UITest, extract screenshots and create an html page from it  


### Base

This project is based on [Fruta App, an Apple Sample](https://developer.apple.com/documentation/swiftui/fruta_building_a_feature-rich_app_with_swiftui).
