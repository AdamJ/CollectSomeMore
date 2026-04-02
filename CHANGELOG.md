# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Changed

- Consolidated SwiftUI navigation ownership across the app shell and feature roots
  — `/CollectSomeMore/ContentView.swift`, `/CollectSomeMore/Search.swift`, `/CollectSomeMore/Game/GameListView.swift`, `/CollectSomeMore/Movie/MovieList.swift`, `/CollectSomeMore/FAQ/WhereIsDataStored.swift` (removed nested navigation containers so tabs and split view own the stack)

- Simplified settings and info screens to use native `Form` and `List` composition
  — `/CollectSomeMore/Settings/Settings.swift`, `/CollectSomeMore/Settings/FAQ.swift`, `/CollectSomeMore/Settings/About.swift` (removed nested lists/forms and aligned destination screens with parent navigation)

- Standardized the comics feature on the newer detail flow
  — `/CollectSomeMore/ContentView.swift`, `/CollectSomeMore/Comics/ComicsListView.swift`, `/CollectSomeMore/Comics/ComicDetailView.swift` (wired the app shell to the newer comics views and updated add/edit presentation)
