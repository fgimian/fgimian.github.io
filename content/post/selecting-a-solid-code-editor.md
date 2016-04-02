---
title: Selecting a Solid Code Editor
date: 2015-06-06T20:09:00+10:00
---

Hello guys, hope everyone is doing well.  I'll start this post by admitting
that I absolutely love Sublime Text and already own a license for it.  But,
I'm a curious lad who likes to try new things and therefore I couldn't help
being interested in trying out the slew of new open source and also payware
editors which are popping up.

As you also can tell, I primarily develop in Python but do a lot of frontend
work too, so CSS and Javascript are of interest.  In addition, there's a little
C, Bash, PHP and Perl thrown in for good measure (mostly for legacy reasons ...
I absolutely despise Perl).

I'll be evaluating the current versions of [GitHub's Atom](https://atom.io/),
[Adobe's Brackets](http://brackets.io/),
[Microsoft's Code](https://code.visualstudio.com/) and
[JetBrains' PyCharm](https://www.jetbrains.com/pycharm/) against the features
that I've come to love in [Sublime Text](http://www.sublimetext.com/).

Please note that this post will continue to be updated as time goes on and
features are added to the various editors.  I'm happy to be corrected if I
have missed anything here as I don't yet know all the other editors intimately.

## Features to be Evaluated

### Text Manipulation

* **Multiple Cursors**: The ability to type on multiple lines and also select
  instances of a search term and place multiple cursors there
* **Join Lines**: Ability to join multiple lines together easily
* **Duplicate Lines**: Make another copy of the current line
* **Moving Lines**: Moving lines up and down
* **Changing Case**: Switching to title case, uppercase and lowercase
* **Commenting Lines**: Ability to easily comment out one or more lines
* **Line Endings**: Being able to change the default line endings and also
  the line endings of the current file
* **Indentation Settings**: Changing from tab to soft spaces and being able to
  change the width
* **Replace**: Regular expression support and good highlighting of search terms
  as you type

### General Editing & IDE Features

* **Appearance**: An appealing visual design
* **Autocomplete (vars)**: Ability to autocomplete existing variables
  and class names with the tab key
* **Code Folding**: Ability to fold a block of code
* **Spell Checking**: Built-in spell checking (handy for comments)
* **Language Support**: Reasonable language support (expected languages are
  Bash, Python, Ruby, C, C++, PHP, Perl, HTML, Jade, CSS, LESS, SASS,
  Javascript, Coffeescript, Puppet, Markdown, SQL, XML, JSON and YAML).
* **Autocomplete (IDE)**: Ability to autocomplete library imports and function
  definitions
* **Linting**: Support for linters like flake8, JSHint and so forth
* **Project View**: A good project browser which lets you open files using
  a keyboard shortcut
* **File Tabs & Switching**: A neat tab implementation (like that of Chrome)
  with the ability to cycle through tabs easily
* **Split Editing**: Ideally at least the ability to split horizontally or
  vertically for 2 files to be open at the same time (I never have more than
  that)
* **Snippets**: Code snippets which you may insert by typing various keywords
* **Refactoring**: The ability to easily rename variables and classes
* **Command Palette / Go To Anything**: Ability to use the keyboard to select
  menu items
* **Minimap**: The ability to see an overview of your code that you can scroll
  through
* **Indent Guides**: Indent guides are very handy for languages like Python
  where spacing is critical and for other languages purely for clean coding
* **Rulers**: I like to stick with PEP8 standards and generally stick to
  lines of a certain length to avoid long lines
* **Git Change Indicator**: Ability to see what lines in a file have been
  modified since the last commit

### Web Development

* **Emmet**: We all know and love Emmet for HTML editing so it's a must
* **CSS Colours**: A colour picker for CSS colours and the ability to see the
  colour chosen at a glance

### Miscellaneous Features

* **Cross-platform**: We've come to expect that editors will work across
  Windows, OSX and Linux these days
* **Extensions**: The ability to extend my editor to taste with 3rd party or
  open source extensions is something I've grown to love and now rely on
* **Performance**: Memory usage, CPU usage, general responsiveness and start
  times
* **Scratch Pads**: The ability to just exit Sublime Text without having to
  save everything that's open is a huge advantage for me and something I rely
  on now
* **Zooming**: Quick and easy zooming in and out with Ctrl+scrollwheel

## Feature Comparison

Legend:

* **√**: feature exists and is fully functional
* **!**: feature partially exists
* **x**: feature doesn't exist or is too limited to judge

The symbol will be repeated twice if an extension is required.

```
Text Manipulation        Sublime   PyCharm    Atom    Brackets    Code
----------------------- --------- --------- --------- --------- ---------
* Multiple Cursors          √         √         √         √         √
* Join Lines                √         √         √         √√        x
* Duplicate Lines           √         √         √         √         √
* Moving Lines              √         √         √         √         √
* Changing Case             √         !         √         √√        x
* Commenting Lines          √         √         √         !         √
* Line Endings              √         √         x         x         !
* Indentation Settings      √         √         !         √         !
* Replace                   √         √         √         √         √

Editing & IDE Features   Sublime   PyCharm    Atom    Brackets    Code
----------------------- --------- --------- --------- --------- ---------
* Appearance                √         !         √         √         √
* Autocomplete (vars)       √         √         √         √√        !
* Code Folding              √         √         √         √         x
* Spell Checking            √         √         √         x         x
* Language Support          √√        √√        √√        √√        !
* Autocomplete (IDE)        !!        √         x         !         !
* Linting                   √√        √         √√        !         x
* Project View              √         √         √         !         !
* File Tabs & Switching     √         √         √         √√        x
* Split Editing             √         √         √         √         !
* Snippets                  √         √         √         !!        !
* Refactoring               !         √         !         x         x
* Command Palette           √         x         √         √√        √
* Minimap                   √         √√        √√        √√        x
* Indent Guides             √         √         √         √√        x
* Rulers                    √         √         √         √√        x
* Git Change Indicator      √√        √         √         !         √

Web Development          Sublime   PyCharm    Atom    Brackets    Code
----------------------- --------- --------- --------- --------- ---------
* Emmet                     √√        √         √√        √√        √
* CSS Colours               !         √         √√        √         √

Miscellaneous Features   Sublime   PyCharm    Atom    Brackets    Code
----------------------- --------- --------- --------- --------- ---------
* Cross-platform            √         √         √         √         √
* Extensions                √         √         √         √         x
* Performance               √         !         !         x         !
* Scratch Pads              √         √         x         x         x
* Zooming                   √         √         √         √√        x
```

### Sublime Text

![](/img/selecting-a-solid-code-editor/sublime-text.png)

The following features require extensions:

* **Language Support**: Extensions for
  [Puppet](https://packagecontrol.io/packages/Puppet),
  [LESS](https://packagecontrol.io/packages/LESS),
  [Sass](https://packagecontrol.io/packages/Sass),
  [SCSS](https://packagecontrol.io/packages/SCSS),
  [Coffeescript](https://packagecontrol.io/packages/CoffeeScript)
  and [Jade](https://packagecontrol.io/packages/Jade) are required.
* **Linting**: Available via the
  [SublimeLinter packages](https://packagecontrol.io/browse/authors/SublimeLinter).
* **Git Change Indicator**: Available via the
  [GitGutter package](https://packagecontrol.io/packages/GitGutter)
* **Emmet**: Available via the
  [Emmet package](https://packagecontrol.io/packages/Emmet).

The following features are limited or missing:

* **Autocomplete (IDE)**: Python autocomplete is implemented rather well by
  the [Anaconda package](https://packagecontrol.io/packages/Anaconda) but
  I'm not aware of equivalents for other languages.  I have had nothing but
  drama using the popular
  [SublimeCodeIntel package](https://packagecontrol.io/packages/SublimeCodeIntel)
  so I don't consider that a good choice at this stage.
* **Refactoring**: You may use *Expand Selection to Word* to rename variables
  (be sure to do this without a selection).  Unfortunately, I'm not currently
  aware of how one could rename a variable for all files in the project.
* **CSS Colours**: Although there are packages available such as
  [Color Highlighter](https://packagecontrol.io/packages/Color%20Highlighter)
  and [ColorPicker](https://packagecontrol.io/packages/ColorPicker), the
  experience is far less refined than editors like Atom or Code.  The
  ColorPicker uses the rather crappy Windows color picker and the highlighter
  requires that you save the CSS file before seeing the changes.

It's easy to see why Sublime Text is so popular, it's an amazing editor.  It
mainly lacks in the area of IDE features like full autocompletion for
libraries and refactoring.

### PyCharm

![](/img/selecting-a-solid-code-editor/pycharm.png)

The following features require plugins:

* **Language Support**: PyCharm is clearly made for primarily for Python, so
  it sadly doesn't include any support for PHP or Ruby which have their own
  respective products or are part of the flagship IntelliJ product.
  A [Bash plugin](https://plugins.jetbrains.com/plugin/4230?pr=idea) and
  [C/C++ plugin](https://plugins.jetbrains.com/plugin/1373?pr=).
* **Minimap**: Can be enabled through the
  [CodeGlance plugin](https://plugins.jetbrains.com/plugin/7275?pr=clion).

The following features are limited or missing:

* **Changing Case**: PyCharm allows you to transform text to uppercase and
  lowercase, but not title case which may be needed from time to time.
* **Appearance**: I'm not saying that PyCharm is ugly because it's absolutely
  not.  But because it's built with Java, it doesn't use native interface
  elements and therefore does clearly feel a tad *different* compared to
  native applications.  The default shortcuts in the application are also
  rather non-standard and really need tweaking (e.g. Ctrl+N for new, Ctrl+W
  for close and so forth).
* **Command Palette**: I can't seem to find an equivalent of Sublime Text's
  command palette.
* **Performance**: JetBrains is reasonably fast when being used, but it is
  a beast, taking close to 1 GB of memory when running and having a rather
  long startup time.  You will need a moderately powerful machine to run
  and use this IDE.

### Atom

![](/img/selecting-a-solid-code-editor/atom.png)

The following features require packages:

* **Language Support**: Packages for
  [Jade](https://atom.io/packages/language-jade) and
  [Puppet](https://atom.io/packages/language-puppet) are required.
* **Linting**: Available via the
  [AtomLinter packages](https://atom.io/users/AtomLinter).
* **Minimap**: Available via the
  [minimap package](https://atom.io/packages/minimap).
* **Emmet**: Available via the [Emmet package](https://atom.io/packages/emmet).
* **CSS Colours**: Available via the
  [Color Picker extension](https://atom.io/packages/color-picker)
  and the
  [Atom Color Highlight extension](https://atom.io/packages/atom-color-highlight).

The following features are limited or missing:

* **Line Endings**: The
  [line-ending-converter](https://atom.io/packages/line-ending-converter)
  helps a little here, but still, Atom doesn't allow one to specify the
  default line ending or even see what line endings the current file has.
* **Indentation Settings**: Atom is decent in this regard, it lets you set
  defaults but it doesn't make them easy to change specifically for the current
  file nor does it make it apparent what the current settings are.
* **Autocomplete (IDE)**: No autocomplete for imports or libraries that I
  could find across any language.
* **Refactoring**: Atom actually does an impressive job with this.  Atom's
  *Select Next* feature will cleverly only select the variable that you've
  chosen neglecting other words which contain the variable name.  The only
  reason it didn't get a tick here is that it doesn't cleverly do this
  across an entire project sadly.
* **Performance**: Atom works pretty well but does take a while to start
  and seems to lock up completely from time to time when using the *Settings*
  page and installing packages.
* **Scratch Pads**: Sadly, Atom doesn't offer this feature, you must always
  save files when exiting the application.
* **Other**: Atom doesn't allow you to use a single key to select *Save*,
  *Cancel* or *Don't Save* when closing a file.

Atom is very impressive and would be the closest alternative to Sublime Text.
The editor does lack in a few areas such as IDE features, scratch pads, line
ending support and has various other relatively minor usability problems.  The
performance problems while in Settings and lack of line endings for me are the
biggest issues with the editor at the moment.

### Brackets

![](/img/selecting-a-solid-code-editor/brackets.png)

The following features require extensions:

* **Join Lines**: Available via the
  [Join Lines extension](https://github.com/hamdanjaveed/Join-Lines).
* **Changing Case**: Available via the
  [Brackets Tools extension](https://github.com/yasinkuyu/brackets-tools)
* **Autocomplete (vars)**: Available via the
  [WordHint extension](https://github.com/bigeyex/brackets-wordhint).
* **Language Support**: Extensions for
  [Jade](https://github.com/ForbesLindesay/jade-brackets) and
  [Puppet](https://github.com/nextrevision/brackets-puppet-syntax)
  are required.
* **File Tabs & Switching**: Requires an extension such as
  [Tabs - Custom Working](https://github.com/DH3ALEJANDRO/custom-work-for-brackets)
  and the [File Navigation Shortcuts](https://github.com/peterflynn/brackets-editor-nav)
  extension with some customised keyboard shortcuts to work as expected.
* **Command Palette**: Available via the
  [Brackets Commands Quick Search extension](https://github.com/peterflynn/brackets-commands-guide).
* **Minimap**: Available via the
  [Minimap extension](https://github.com/zorgzerg/brackets-minimap).
* **Indent Guides**: Available via the
  [Indent Guides extension](https://github.com/lkcampbell/brackets-indent-guides).
* **Rulers**: Available via the
  [Column Ruler extension](https://github.com/lkcampbell/brackets-ruler)
  although this did seem a little buggy, but I got it working after some
  mucking about.
* **Emmet**: Available via the [Emmet extension](http://emmet.io/).
* **Zooming:** Available via the
  [Zoom wheel extension](https://github.com/denis-gorin/brackets_zw).

The following features are limited or missing:

* **Commenting Lines**: Brackets lets you comment lines but it doesn't do it
  neatly like Atom and Sublime do.

e.g. let's comment out the print statement here

```python
if name == 'Fotis':
    print 'Hello there'
    name = None
```

Sublime Text

```python
if name == 'Fotis':
    # print 'Hello there'
    name = None
```

Atom

```python
if name == 'Fotis':
    # print 'Hello there'
    name = None
```

Brackets

```python
if name == 'Fotis':
#    print 'Hello there'
    name = None
```

* **Line Endings**: I can't find a way to view, set or change the default line
  endings in Brackets at all.
* **Spell Checking**: An extension exists which attempts to implement this but
  it's not realtime and suggestions are not available via right click (only
  via Ctrl+Space).
* **Git Change Indicator**: This is partially supported via the
  [Brackets Git extension](https://github.com/zaggino/brackets-git) but
  changes are only visible upon save.
* **Autocomplete (IDE)**: Brackets includes IDE-like features for several
  languages and it does it rather well, but the list of languages is not
  extensive and doesn't include Python.
* **Linting**: Although Brackets does have some linting plugins, they don't
  seem to be uniform or of good quality like those offered in Atom and Sublime
  Text.  As an example, the flake8 plugin appears not to be realtime and I
  couldn't get it working when I tried.
* **Project View**: Works well but only allows you to view one project at a
  time.
* **Snippets:** Several extensions exist which attempt to bring this into
  Brackets but they seem to offer limited language support.
* **Refactoring**: Partially possible but suffers the same problem as
  Sublime Text using the *Add Next Match to Selection* operation.
* **Git Change Indicator**: There's a [Brackets Git extension](https://github.com/zaggino/brackets-git)
  but it forces you to save the file before updated Git indicators are shown.
* **Performance**: I'm sorry to say that Brackets felt very slow, even on my
  specced out system.  File switching is painfully slow when the minimap,
  ruler and indent guide extensions are activated (but rather good without
  them).  The editor takes a little to start up.  The entire editor feels slow
  in general compared to the rest.
* **Scratch Pads**: Sadly, Brackets doesn't offer this feature, you must always
  save files when exiting the application.

Brackets has an extremely limited core and requires loads of plugins to become
useful.  Thankfully, there is a great community behind the editor who has
contributed many extensions which improve the editor.  However, with the
exception of the excellent IDE-style features provided for CSS, Javascript and
HTML, Brackets generally falls short as an editor.

### Code

![](/img/selecting-a-solid-code-editor/code.png)

The following features are limited or missing:

* **Join Lines**: There's no way to join lines in this editor.
* **Changing Case**: Surprisingly, there's no way to change case!
* **Line Endings**: You may change line endings for the current file but there
  doesn't seem to be a way to set default line endings.
* **Indentation Settings**: Code allows you to set a default tab size
  but doesn't seem to provide a way to view or change the setting for the
  current file and for various languages.
* **Autocomplete (vars)**: This only works in certain languages.
* **Code Folding**: No code folding support is provided.
* **Spell Checking**: No spell checker appears to be included out of the box.
* **Language Support**: There's limited language support out of the box,
  languages such as Puppet and C are missing for example.
* **Autocomplete (IDE)**: Code really shines here, it has an amazing
  autocomplete (what they call IntelliSense) experience, but it only works
  on a limited set of languages sadly, and Python isn't one of them.
* **Linting**: No linting support appears to exist out of the box.
* **Project View**: The project view is great but only allows for one project
  to be open at a time.
* **File Tabs & Switching**: Switching files is quite painful in this editor,
  there's no tab bar, and there doesn't seem to be a way to move to the next
  and previous file accurately.  In fact, half the time, I don't know what
  files are even open.
* **Split Editing**: Code only allows you to split the screen horizontally (
  above and below) but not vertically (left and right).
* **Snippets**: The editor offers snippets for a limited set of languages.
* **Refactoring**: No refactoring support appears to exist.
* **Minimap**: No minimap is available.
* **Indent Guides**: No option to enable indent guides.
* **Rulers**: No option to enable rulers.
* **Extensions**: No extension support yet, but it
  [seems to be coming](http://visualstudio.uservoice.com/forums/293070-visual-studio-code/suggestions/7752408-plugin-system)
* **Performance**: Code performs extremely well compared to the other
  Javascript-script based editors and overall is very snappy.  But compared to
  Sublime Text, it is a little less responsive which is why it didn't quite
  get the tick.
* **Scratch Pads**: Sadly, Code doesn't offer this feature, you must always
  save files when exiting the application.
* **Zooming**: No ability to zoom with Ctrl+scrollwheel.  You can however use
  Ctrl and + to zoom in.  You can't zoom out beyond the original font size
  though.
* **Other**: Code doesn't allow you to use a single key to select *Save*,
  *Cancel* or *Don't Save* when closing a file.

## Conclusion

Overall, we have many great choices here.  Personally, I feel that Brackets
probably fell shortest of the bunch when considering it's been around for a
little while.  Code shows great promise but is still rather young and lacks
some basic functionality and extension support.

My picks as of June 2015 are as follows:

* **IDE**: PyCharm (but you'll need a beefy machine)
* **Editor**: Sublime Text
* **Alternative Editor**: Atom (open source and free)
