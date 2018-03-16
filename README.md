# MasterMind - A Game Of Deduction

Implemented In **PowerBuilder**

## Object of Game

Figure out the exact combination of colors that the computer randomly chose.

For a further explanation of the game and also to play a web based version see: https://bseaver.jsbin.com/badove

## Highlighted PowerBuilder Techniques

* DataWindow used to create a rich interactive control
* Thoughtfully implemented UI features integrate Drag/Drop, Right Click, DoubleClick, Keyboard
* Initial rapid prototyping
* Subsequent refactoring
* Use of function and structure to track game state

## Prerequisites

Microsoft Windows OS

PowerBuilder see: https://www.appeon.com/

## Installation

1. Clone this repository.

2. Start PowerBuilder, then do the following operations:

3. *File*, *New*, *Workspace*: Create workspace named `workspace` in cloned repository.

4. *File*, *New*, *Target*, Application: Enter `mastermind` under Application Name:, then click *Finish* for defaults.

5. Click the + to the left of the workspace in the System Tree to expose the mastermind target.

6. Click the + to the left of the mastermind target to expose the mastermind.pbl.

7. Rightclick on mastermind.pbl in System Tree, select Import, highlight all files, then click *Open*.

8. Click the + to the left of the mastermind.pbl to expose all imported objects.

9. DoubleClick on the mastermind application object in System Tree. Enter in open event: `Open( w_master3 )`

10. *File*, *Close*, *Save*

11. *Run*, *Full Build mastermind*

12. *Run*, *Run mastermind*

Note: If you want to deploy the app with the .ICO files imbedded in the .EXE, use or merge the contents MMIND.PBR resource file.

## Author

* Benjamin Seaver https://www.seaver99.com/mastermind/

## License: MIT
