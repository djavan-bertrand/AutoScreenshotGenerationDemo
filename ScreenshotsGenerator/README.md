# ScreenshotsGenerator

ScreenshotsGenerator is a package that build a command line executable. This executable will generate screenshots on differents simulators and output an html page containing all screenshots.

# How to use

- build the executable:
  In the ScreenshotsGenerator folder, run `swift build -c release`

- run the executable:
  In TagHeuerGolf folder, run `./ScreenshotsGenerator/.build/release/generateScreenshots`

  There are two way of configuring the simulators that will be used:
  - Either interactively: `./ScreenshotsGenerator/.build/release/generateScreenshots i`
  - Or by giving an explicit config: `./ScreenshotsGenerator/.build/release/generateScreenshots d m:14ProMax,a:dark,c:XL m:SE2,c:XXL`

  An exhaustive list of the configs is available with the help: `./ScreenshotsGenerator/.build/release/generateScreenshots d -h`