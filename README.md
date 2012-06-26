# SGTabs

Tab component for iOS 5+. You can show your ViewControllers in tabs, it is possible to add and remove tabs on the fly.

# Features
- Uses iOS 5 UIViewController Container API
- Add and remove tabs on the fly with animations
- User can remove tabs, if you allow it.
- Dynamically show and hide a UIToolbar at the top
- Show the UIBarButtonItems in viewController.toolbarItems in the toolbar
- Enables you to build mobile Safari style Apps. (See demo)

# Demo
A basic web browser with tabs, in around 120 lines of code.

## Screenshots

![Multiple tabs](https://github.com/graetzer/SGTabs/raw/master/screen.png "A basic browser with visible toolbar")

# How to use
- Just include all files in the "./Source" Directory. Everything else is just for demonstrational purposes
- This is an ARC Project, so remember to enable ARC at least on the SGTabs files. 
- Add the "-fobjc-arc" flag (In your project's target settings -> BuildPhases -> Compile Sources)
- Use as in the Demo or subclass SGTabsViewController and use it as an root view controller


# Licence
I provide my code under the Apache Licence.
Some credits go to [Fictorial LLC](https://github.com/fictorial/BHTabBar "BHTabBar Github"), my tab control implementation is inspired by the one they made


    Copyright 2012 Simon Grätzer
   
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
    http://www.apache.org/licenses/LICENSE-2.0
   
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.