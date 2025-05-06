# DiiaUIComponents 

Basic UI components and primitives

## Useful Links

|Topic|Link|Description|
|--|--|--|
|Ministry of Digital Transformation of Ukraine|https://thedigital.gov.ua/|The Official homepage of the Ministry of Digital Transformation of Ukraine| 
|Diia App|https://diia.gov.ua/|The Official website for the Diia application

## Getting Started

|Topic|Link|Description|
|--|--|--|
|Ministry of Digital Transformation of Ukraine|https://thedigital.gov.ua/|The Official homepage of the Ministry of Digital Transformation of Ukraine| 
|Diia App|https://diia.gov.ua/|The Official website for the Diia application

#### 1st party

* [DiiaMVPModule](https://github.com/diia-open-source/ios-mvpmodule.git): Model-View-Presenter basic protocols
* [DiiaCommonTypes](https://github.com/diia-open-source/ios-commontypes.git): Types (classes, strucutres, protocols) that have to be shared amond several packages.

#### 3rd party

* [SwiftMessages](https://github.com/SwiftKickMobile/SwiftMessages)
* [Lottie](https://github.com/airbnb/lottie-spm.git)
* [Kingfisher](https://github.com/onevcat/Kingfisher)

### Installing

To install DiiaUIComponents using [Swift Package Manager](https://github.com/apple/swift-package-manager) you can follow the [tutorial published by Apple](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) using the URL for this repo with the current version:

1. In Xcode, select “File” → “Add Packages...”
1. Enter `https://github.com/diia-open-source/ios-uicomponents.git`

or you can add the following dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/diia-open-source/ios-uicomponents.git", from: "1.0.0")
```

## Code Verification

### Testing

In order to run tests and check coverage please follow next steps
We use [xcov](https://github.com/fastlane-community/xcov) in order to run
This guidline provides step-by-step instructions on running xcove locally through a shell script. Discover the process and locate the results conveniently in .html format.

1. Install [xcov](https://github.com/fastlane-community/xcov)
2. go to folder ./Scripts then run `sh xcove_runner.sh`
3. In order to check coverage report find the file `index.html` in the folder `../../xcove_output`.

We use `Scripts/.xcovignore` xcov configuration file in order to exclude files that are not going to be covered by unit tests (views, models and so on) from coverage result.


### Swiftlint

It is used [SwiftLint](https://github.com/realm/SwiftLint) to enforce Swift style and conventions. The app should build and work without it, but if you plan to write code, you are encouraged to install SwiftLint.

You can run SwiftLint manully by running 
```bash
swiftlint Sources --quiet --reporter html > Scripts/swiftlint_report.html.
```
You can also set up a Git [pre-commit hook](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) to run SwiftLint automatically by copy Scripts/githooks into .git/hooks

## How to contribute

The Diia project welcomes contributions into this solution; please refer to the [CONTRIBUTING.md](./CONTRIBUTING.md) file for details

## Licensing

Copyright (C) Diia and all other contributors.

Licensed under the  **EUPL**  (the "License"); you may not use this file except in compliance with the License. Re-use is permitted, although not encouraged, under the EUPL, with the exception of source files that contain a different license.

You may obtain a copy of the License at  [https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12](https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12).

Questions regarding the Diia project, the License and any re-use should be directed to [modt.opensource@thedigital.gov.ua](mailto:modt.opensource@thedigital.gov.ua).
