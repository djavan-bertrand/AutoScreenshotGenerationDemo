# Automatic Screenshot Generation Sample Code 

The aim of this repository is to provide an example on how to modify an app and add UITests and scripts in order to take a screenshot of every single screen of the app in multiple configurations (language, device size, appearance...) and generate a report containing these screenshots.

The steps will be the following:
- Introduce `Configurable` notion and create configurable versions of each submodels that needs it.
- Create a UITest that navigates through the app and takes screenshots
- Add a script that can build and run this UITest, extract screenshots and create an html page from it  

## How to use

You should first compile once the project with Xcode just to be sure that everything compile and runs smoothly (you may have to select the correct team for the signing).
Then you can run the generateScreenshots script with the following command lines:
- `./generateScreenshots -h` in order to read the script documentation
- `./generateScreenshots d m:14ProMax,a:dark m:14ProMax m:8` in order to generate screenshots on 3 devices: an iPhone 14 Pro Max in dark mode, an iPhone 14 Pro Max in light mode and an iPhone 8 in light mode
- `./generateScreenshots i` to interactively select the devices you want to run on

After this command, the script will build the app, launch the tests and if they passed (🤞) the script will output an HTML file that contains all screenshots for all device configurations. 

### Base

This project is based on [Fruta App, an Apple Sample](https://developer.apple.com/documentation/swiftui/fruta_building_a_feature-rich_app_with_swiftui).
