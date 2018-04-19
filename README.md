# AppGroupsFun

## Purpose
The purpose of this project is for me to gain experience with:
1. Sharing data between mulitple apps via App Groups.
2. Determining the approximate frequency of Background Fetch events in both iOS 10 and iOS 11.
3. Extracting common code into a framework and access from multiple app projects withing an Xcode Workspace.

## Project Setup

I've done this by setting up an AppGroupsFun.xcworkspace with the following projects:
1. BackgroundFetchEvents framework used to share common code between the other two projects.
2. BackgroundFetchWriter app which registers for Background Fetch events, logs each event to a shared UserDefaults instance via App Groups, and posts a local UserNotification on each background fetch event.
3. BackgroundFetchReader app which displays background fetch log created by Writer app.

## Usage Notes

You will need to add your own App Groups container identifier via the Capabilities pane in both Writer and Reader projects. You will also need to Update the sharedUserDefaults suiteName parameter in BackgroundFetchEventProvider.swift (around line 24) to use your new identifier.

