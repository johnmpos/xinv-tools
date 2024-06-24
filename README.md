# XINV-TOOLS
Tool that listens to files in specific folders and provides a backup copy automatically.

## How to use
xinv-tools will create a file called "listener.xinv" and inside this file add folders that xinv-tools should listen to. After a file is created a hidden folder called ".backup/" is created and a .bak file is created as a backup of the original file. Each new folder and its files will have a hidden folder for their backups (to maintain organization).

## Dependencies
- inotify-tools (is a tool that allows monitoring events such as creation, editing, deletion, etc. of files and folders -- available here -- [https://github.com/inotify-tools]("inotify-tools")). 

