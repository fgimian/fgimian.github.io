---
title: Selecting a Solid Code Editor in 2018
date: 2018-06-05T21:00:16+10:00
---

Hey there everyone, I thought it would be a good time to do a follow-up to my earlier post about code editors.  The landscape has changed significantly since the last post, almost frighteningly so.

I'll be evaluating the current versions of [GitHub's Atom](https://atom.io/), [Microsoft's Visual Studio Code](https://code.visualstudio.com/) and [JetBrains' IDEs](https://www.jetbrains.com/products.html?fromMenu) against [Sublime Text](http://www.sublimetext.com/).

During this evaluation, I did focus mostly on Python development (i.e. the PyCharm IDE from JetBrains).

## Feature Comparison

Legend:

* **√**: feature exists and is fully functional
* **!**: feature partially exists
* **x**: feature doesn't exist or is too limited to judge

The symbol will be repeated twice if an extension is required.

```
Text Manipulation           Sublime    JetBrains      Atom        Code
------------------------- ----------- ----------- ----------- -----------
* Multiple Cursors             √           √           √           √
* Join Lines                   √           √           √           √
* Duplicate Lines              √           √           √           √
* Moving Lines                 √           √           √           √
* Changing Case                √           √√          √           √√
* Commenting Lines             √           √           √           √
* Line Endings                 √           √           √           √
* Indentation Settings         √           √           √           √
* Replace                      √           √           √           √

Editing & IDE Features      Sublime    JetBrains      Atom        Code
------------------------- ----------- ----------- ----------- -----------
* Appearance                   √           !           √           √
* Autocomplete (vars)          √           √           √           √
* Code Folding                 √           √           √           √
* Spell Checking               √           √           √           √√
* Language Support             √√          √√          √√          √√
* Autocomplete (IDE)           √√          √           √√          √√
* Linting                      √√          √           √√          √√
* Project View                 √           √           √           √
* File Tabs & Switching        √           √           √           √
* Split Editing                √           √           √           √
* Snippets                     √           √           √           √
* Refactoring                  !           √           !           √
* Command Palette              √           x           √           √
* Minimap                      √           √√          √√          √
* Indent Guides                √           √           √           √
* Rulers                       √           √           √           √
* Git Change Indicator         √√          √           √           √
* Terminal Integration         !           √           √√          √

Web Development             Sublime    JetBrains      Atom        Code
------------------------- ----------- ----------- ----------- -----------
* Emmet                        √√          √           √√          √
* CSS Colours                  !           √           √√          √

Miscellaneous Features      Sublime    JetBrains      Atom        Code
------------------------- ----------- ----------- ----------- -----------
* Cross-platform               √           √           √           √
* Extensions                   √           √           √           √
* Performance                  √           !           !           !
* Scratch Pads                 √           √           x           √
* Zooming                      √           √           √           √
* Cost                         !           !           √           √
```

So let's touch on the weaknesses that I personally found in each editor:

* **Appearance**: PyCharm doesn't feel like a native application due to its Java-based GUI.  The default shortcuts and even editing behaviour are different to what one may expect.  Fortunately this can be customised and brought much closer to a native experience but it takes a lot of work.
* **Refactoring**: Sublime Text and Atom offer simple and limited refactoring.
* **Command Palette**: As far as I could tell, PyCharm doesn't have a command palette where one can easily search for actions using fuzzy search.
* **Terminal Integration**: There is a TerminalView plugin for Sublime Text which does work well, but it is opened in an editor tab which you must then split horizontally so that it moves to the lower half of the screen.  However, repeating this activity each time you want a terminal is tedious.
* **CSS Colours**: I could not find a suitable extension in Sublime Text that shows you CSS colours in-line.
* **Performance**: PyCharm, Atom and Code are generally slower to open and take a lot more memory to run than Sublime Text.  PyCharm is developed in Java, Atom and Code in JavaScript and Sublime Text in C++ and Python.  Code is generally a lot faster than Atom in my testing.
* **Scratch Pads**: I could not find a way to perform a hot exit in Atom.
* **Cost**: Sublime Text is commercial software with a one-off price for major versions while JetBrains Pro products work on a subscription model.  It should be noted however that Community Editions of JetBrains products (e.g. PyCharm CE) are free, open source and easily rival the other editors being evaluated here.  Atom and Code are open source and free.

## Conclusion

It's incredible how far we've come in only 3 years.  You honestly can't go wrong with any of the options discussed above.

My personal picks as of June 2018 are as follows:

### IDE

If you're after the absolute best auto-complete, refactoring and debugging for a particular language supported by JetBrains IDEs, then these are a great choice.

Please note however that JetBrains IDEs are not all-rounders and do need a good amount of juice to run, so I would only go with a full IDE if you mainly code in the specific language that the IDE is made for (e.g. PyCharm for Python).

### Editor

My personal preference is to use a more well-rounded and versatile editor which offers some IDE features but covers more languages adequately.  I tend to work in a variety of languages such as Bash, Python, Terraform, YAML, Markdown and Ruby, so having that versatility is very important to me.

My top choices are as follows:

* Sublime Text
* Visual Studio Code

When comparing Sublime Text with Visual Studio Code, it really comes down to the following points:

* Sublime Text is still the best performer with the lowest footprint
* Visual Studio Code has a built-in Terminal which is well implemented and better than the equivalent in Sublime Text
* Visual Studio Code generally feels closer to an IDE and also offers CSS colouring
* Visual Studio Code is open source, free and improving rapidly
