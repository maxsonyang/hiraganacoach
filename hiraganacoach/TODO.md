#  A list of stuff todo.

## Model

### Revising CoreDataManager + JSON methods
Methods are all over the place right now, and the coredatamanager is an untested mess. Currently re-writing the class and testing as I go, will need to do something similar for language data since it relies on JSON instead of coredata. Super hacky right now in the views —they just kind of call methods and access them as they need it.

### Adding a "User" CoreData Object.
Should keep track of another object to store things like achievements (i.e. Accumulated score highest streak, # of mastered topics). Methods are currently aggregated (slowly, and updated slowly).

## Features

### Achievement Tracking
Tracking things like user achievement and individual performance on specific categories will be helpful. I didn't think it'd be a particular interesting feature for myself but once I added it I found myself more motivated in trying to get a streak as well as 

### Small Tsu
Once I have a better idea of what's going on with the characters, I should factor in Small Tsu (っ). My understanding of it so far is that it's a modifier that basically doubles the following consonant's sound.
