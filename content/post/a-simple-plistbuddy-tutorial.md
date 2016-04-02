---
title: A Simple PlistBuddy Tutorial
date: 2015-06-27T20:41:00+10:00
---

Good ol' plist files.  They are at the core of OS X for storing application 
settings and they work really well.

If you have ever automated part of your OS X build or changed some cool hidden
feature, you have probably used the **defaults** command to do so.  The 
defaults command is great and is still recommended for simple things, but if
you want to edit complex plist structures like arrays, dicts and nested 
structures, you'll inevitably come across PlistBuddy.

The tool is extremely simple to use and powerful, but due to the lack of 
tutorials and guides, I thought I'd write one in my own words.

Start by installing rlwrap to get readline support:

```bash
brew install rlwrap
```

And now start Plistbuddy wrapped in readline glory:

```bash
rlwrap /usr/libexec/PlistBuddy testing.plist
```

This creates a fresh plist file with a dict as its top-level structure.  At any
point, you may type `Print` to view the entire structure:

```
Command: Print
Dict {
}
```

Let's create a regular item at the top level:

```
Command: Add :Version string 1.0
Command: Print
Dict {
    Version = 1.0
}
```

And now change it's value:

```
Command: Set :Version 1.1
Command: Print
Dict {
    Version = 1.1
}
```

Next up, we'll create an array and push a few items onto it:

```
Command: Add :Applications array
Command: Add :Applications: string app1
Command: Add :Applications: string app2
Command: Add :Applications: string app3
Command: Print
Dict {
    Version = 1.1
    Applications = Array {
        app1
        app2
        app3
    }
}
```

We may also add items to the beginning of the array by inserting at index 0:

```
Command: Add :Applications:0 string app0a
Command: Add :Applications:0 string app0b
Command: Add :Applications:0 string app0c
Command: Print
Dict {
    Version = 1.1
    Applications = Array {
        app0c
        app0b
        app0a
        app1
        app2
        app3
    }
}
```

And now, we'll delete an entry:

```
Command: Delete :Applications
Command: Print
Dict {
    Version = 1.1
}
```

Now let's create a more complex data structure:

```
Command: Add :BrainCells integer 5
Command: Add ":Favourite Random Number" real 3.9234
Command: Add :Intelligent bool false
Command: Add :Today date "Sat Jun 27 18:51:00 AEST 2015"
Command: Add :Person dict
Command: Add :Person:Name string "Fotis Gimian"
Command: Add :Person:Occupation string "Geek"
Command: Add :Person:Likes array
Command: Add :Person:Likes: string Potatoes
Command: Add :Person:Likes: string Apple
Command: Add :Person:Likes: string Bouncing
Command: Print
Dict {
    Favourite Random Number = 3.923400
    Version = 1.1
    Person = Dict {
        Likes = Array {
            Potatoes
            Apple
            Bouncing
        }
        Name = Fotis Gimian
        Occupation = Geek
    }
    Intelligent = false
    BrainCells = 5
    Today = Sat Jun 27 18:51:00 AEST 2015
}
```

Now let me be a little evil and replace my Apple like with Microsoft:

```
Command: Set :Person:Likes:1 Microsoft
Command: Print
Dict {
    Favourite Random Number = 3.923400
    Version = 1.1
    Person = Dict {
        Likes = Array {
            Potatoes
            Microsoft
            Bouncing
        }
        Name = Fotis Gimian
        Occupation = Geek
    }
    Intelligent = false
    BrainCells = 5
    Today = Sat Jun 27 18:51:00 AEST 2015
}
```

We may also print a subset of a structure by using colons to move further in:

```
Command: Print :Person:Likes
Array {
    Potatoes
    Microsoft
    Bouncing
}
```

You may use an index to move into an array:

```
Command: Print :Person:Likes:1
Microsoft
```

And naturally, you can delete items at any level using colons to get inside:

```
Command: Delete :Person:Likes
Command: Print
Dict {
    Favourite Random Number = 3.923400
    Version = 1.1
    Person = Dict {
        Name = Fotis Gimian
        Occupation = Geek
    }
    Intelligent = false
    BrainCells = 5
    Today = Sat Jun 27 18:51:00 AEST 2015
}
```

You may save all your hard work when done:

```
Command: Save
Saving...
Command: Exit
```

These commands may be invoked from the CLI directly using the -c option:

```
➔ /usr/libexec/PlistBuddy -c "Print" testing.plist
Dict {
    Person = Dict {
        Name = Fotis Gimian
        Occupation = Geek
    }
    Intelligent = false
    BrainCells = 5
    Version = 1.1
    Today = Sat Jun 27 18:51:00 AEST 2015
    Favourite Random Number = 3.923400
}
```

If you would like to modify plist files provided by applications, you'll need
to provide PlistBuddy the full path name to the file (unlike the defaults
command):

```
➔ /usr/libexec/PlistBuddy -c "Print :magnification" ~/Library/Preferences/com.apple.dock.plist 
true
➔ /usr/libexec/PlistBuddy -c "Set :magnification bool false" ~/Library/Preferences/com.apple.dock.plist 
➔ /usr/libexec/PlistBuddy -c "Print :magnification" ~/Library/Preferences/com.apple.dock.plist 
false
```

Oh and a little tip (after you stretched for that shift key on each command). 
The commands (i.e. Print, Set, Add and so on) are case insensitive, so you can 
just type them in lowercase.

Hope this helps someone out there.  Have a good one! :)
