Sailor VIM Plugin
=================
What is Sailor? In short it is a series of tools to help you record the
interesting thing you find while browsing the web. The idea is to have a
specific file structure with a specific syntax to help move around all these
masive information sea!

How it works? Whenever you're exploring the net you may be interested in have a
VIM window open to store any interesting data you consider. 
You may call a python program `sailor` or the Plugin function `:sailor`.
(Please consider that none of these functionalities are still implemented! This
is only a planning document!)

I've applied the extension `.expl` to the sailor files to store the navigation
log. 

## Syntax 

When you're there, You have just an empty folder. What convention follow for
this to work propertly. 
I made this for my personal purposes so it is adapted to the way I like to
navigate. I do mix a lot of personal thought along with the interesting links.
I do want to record all what is going through my head while discovering these
things that is why the format should allow random text along with the bookmark
of the webs.

The idea is the following:

-----------------------------------------------
2017-06-05.expl

This may be a lot of random coments. Nothing to worry about. Ey! Whats that!
Something interesting ho! Something interesting ahoy!

- Supercool internet stuff
    Probably a cute kitty video or something. This may be used as a descriptor
    It may have as many lines as you want, but keep it shifted. 
    You may also add |tags| as well. We would discuss more about these |tags|
    latter.
    http://somehing-cute-org

Now we can keep our random tought line...

-----------------------------------------------

Of course, the process should be please to the eye, so some highlight file
would be applied to these files.
* Highlight the bookmarks (Starting with '-' character)
* Highlight the url.
    + It is not mandatory to put it at the end, but I found more pretty that
      way.
* Highlight the tags. These tags may be enclosed between '|' symbols.
* URLS use to be reaaaally long, so it may be convinient to use the `nowrap`
  option to keep them in a single line.
* However, I rather like the idea of having 90char width texts. Keep the width
  limit ok?

## File structure

Both ways to open `sailor` should create a new `.expl` file with the current
date as name in the specifiec folder. There may be additional files for
internal functions.

This is the main scheme of the program:

NavigationLog/
    |- AGO2017/
    |   |- 2017-07-01.expl
    |   |- 2017-07-02.expl
    |   |_ 2017-07-14.expl
    |
    |- SEP2017/
    |   |- 2017-08-08.expl
    |   :
    |   |_ 2017-08-30.expl
    :
    |- tags
    |- bookmarks
    |_ last_request

## Functions to implement

* Easy move across the `.expl` files. (SailorNext, SailorPrev)
* Check for new tags every time a `.expl` file is saved
    + Save any change on the **tags** file in the NavigationLog file
* Show the current tags available (SaliorTagShow)
    + Open the **tags** file in a border
    + This window should allow some special options (SailorApplyFilter)

That is something still pending to see... What is the best way to browse across
tags?
There should be three ways:
    1. Update the **last_request** file with the tags (easy to navigate)
    2. create a grep search to locate the original `.expl` file where the tag
       was included (easy to repair)
    3. Additionally you may `go back to the day where that tag was included` to check
        other notes related. (SailorFindExpl?)

Of course you may need a easy way to go to the webs on your browser... but that
part is mostly covered! 

I would say that this is almost everything needed...

## Schedule

Of course working on any coding problem would strecht itself to the infinite,
including a myriad of small features until the end of the times. That is not
what we want, so the scope should be closed with those features. Yeah, no the
way more will come, and probably some of those would present some problems as
well and would be dumped overboard. 
What are priorities then?

* Automate the creation the navigation files
* Implement the highlighting of `.expl` files
* Easy moving across files 
    + May be a big task! but have some synergies with `mynotes` plugin
* Parse the tags
* Show the avilable tags
* Apply the filters
    + I would start with the **point 2**. I know myself and I would probably screw
      a lot of tags and mix them up. Being able to modify them in an easy
      manner would be nice.
      Also it is important to check how to work with the `quickstart` windows
    + The next thing is the obvious **apply filter**.
    + Finally, try to check the tag asignation with the original file.

It is hard to say about the time. Proabbly with the first two points the
program would be usefull. When the last of it is implemented, it is over. You
packed it and upload it. No excluses! You may want to made a 2.0 version of
Sailor, but that would be another topic of discussion. 
Now it is all scheduled, go to bed and tomorrow start working on it!
