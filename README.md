# funky clone
a [Funky Maker: Mobile](https://play.google.com/store/apps/details?id=com.kingamescreator.fnmm) clone built on HaxeFlixel

# what the hell is a funky maker??
Funky Maker: Mobile is an app made to make the process of creating fnf "levels" easier  
includes a chart editor (with it being able to import charts from other engines), a scene/stage editor  
and the ability to upload and share levels with other players built-in into the app

basically the spiritual succesor to [Friday Night Maker](https://kingamescreator.itch.io/friday-night-maker)
> hell, its even made by the same dev

# okay this is interesting how do i try this
since theres no actual releases yet, you will need to compile the game yourself to try it  
compiling WILL take a long time for the first time, as it needs to compile all the libraries too  
**this guide assumes you're already familiar with haxeflixel projects**

## requirements
* [Haxe](https://haxe.org/download)
* [HaxeFlixel and its dependencies](https://haxeflixel.com/documentation/install-haxeflixel/)
  * also install `flixel-ui`
  * you dont need to "install the flixel command"
* proper build tools (gcc, clang, visual studio build tools, etc)

## building
* cd into the project's root folder (next to the `Project.xml` file)
* run `lime build cpp`
  * you may also add a `-debug` flag to enable debugging features
  * using `cpp` as a platform will default to your os


this project is not made or endorsed by KinGamesCreator 
