---
date: 2016-12-23T13:52:54+11:00
description: ""
title: How macOS Stores Launchpad Configuration
---

Launchpad in macOS is definitely one of the most cumbersome apps to setup,
although it can be pretty nice to have setup as it provides a little more
organisation than adding your Applications folder to the Dock.

The problem up until this point was understanding how it works so that we can
build automation tools around it.  However, this changes today as we explore
the way Launchpad works under tho hood :)

## Connecting to the Launchpad SQLite Database

Launchpad stores all of its data in an SQLite database which you can reach as
follows:

```bash
cd $(getconf DARWIN_USER_DIR)/com.apple.dock.launchpad/db
sqlite3 --column --header db
```

You may check out the entire database schema using the schema command:

```sql
.schema
```

# Launchpad Data Structure

The structure of Launchpad data is as follows:

```
├── Launchpad (Apps) Root
│   ├── Holding Page
│   ├── Page 1
│   │   ├── App 1
│   │   ├── App 2
│   │   ├── Folder Root
│   │   │   │── Folder Page 1
│   │   │   │   │── App 3
│   │   │   │   └── App 4
│   │   │   └── Folder Page 2
│   │   │       ├── App 5
│   │   │       └── App 6
│   │   └── App 7
│   ├── Page 2
│   └── ...
└── Dashboard (Widgets) Root
    ├── Holding Page
    ├── Page 1
    │   ├── Widget 1
    │   ├── Widget 2
    │   ├── Folder Root
    │   │   │── Folder Page 1
    │   │   │   │── Widget 3
    │   │   │   └── Widget 4
    │   │   └── Folder Page 1
    │   │       ├── Widget 5
    │   │       └── Widget 6
    │   └── Widget 7
    ├── Page 2
    └── ...
```

## Useful Tables

The **dbinfo** table provides the root id for each type of Launchpad data.

* **launchpad_root** is the root id for the main Launchpad apps pages
* **dashboard_root** is the root id for the Dashboard widget pages  
  (accessible by clicking the + icon in Dashboard)
* **launchpad_version_root**: is the root id for Launchpad version metadata  
  (this is of least importance to us)

We then move onto the tables containing data about each type of object in Launchpad:

* **groups**: contains all available root objects, pages and folders for both
  Launchpad and Dashboard.
* **apps**: contains all apps available for Launchpad
* **downloading_apps**: contains all apps currently being downloaded for
  Launchpad
* **widgets**: contains all widgets available for Dashboard

Finally, the **items** table references these 3 tables and contains ordering
and parent assocations.

## Walkthrough

**dbinfo**

```sql
sqlite> SELECT *
   ...> FROM dbinfo
   ...> WHERE key LIKE '%_root%';
key                             value     
------------------------------  ----------
launchpad_root                  1         
dashboard_root                  3         
launchpad_version_root          5       
```

**apps**:

```sql
sqlite> SELECT item_id, title 
   ...> FROM apps;
item_id     title                                   
----------  ----------------------------------------
9           1Password 6                             
11          Ableton Live 9 Suite                    
17          Affinity Designer                       
22          Affinity Photo                          
24          Android File Transfer                   
...
```

**widgets**

```sql
sqlite> SELECT item_id, title
   ...> FROM widgets;
item_id     title                                   
----------  ----------------------------------------
7           Calculator                              
8           Calendar                                
10          Contacts                                
12          Dictionary                              
13          ESPN                                    
...
```

**groups**

```sql
sqlite> SELECT item_id, title
   ...> FROM groups;
item_id     title                                   
----------  ----------------------------------------
1                                                   
2                                                   
3                                                   
4                                                   
5                                                   
6                                                   
128                                                 
129         Other                                   
130                                                 
134                                                 
135                                                 
136                                                 
```

OK, so dbinfo, apps and widgets are clear, but the groups not so much.  We know
that groups 1, 3 and 5 are root groups (as shown by the dbinfo table), and 129 
looks like a folder, but we still don't know what the rest are just yet.

Now, we're about to look at the **items** table which ties all of this
information together.  Before we take a look at items, it's important that
some concepts are explained:

* **rowid primary / foreign keys**: The items table contains a **rowid**
  attribute which is its primary key.  However, it is also a foreign key to
  the apps, widgets and groups tables.  What this means is that ids are unique
  across all of these three tables.  So for example, if an app has an id of
  11, then it is impossible for a widget or group to also use this id.
* **type**: Due to the fact that the rowid may reference one of 3 tables, the 
  items table uses a field called **type** which specifies what type of object
  the respective item references.

The types are as follows:

* **groups table**
    + **1**: root
    + **2**: folder root
    + **3**: page or folder page
* **apps table**
    + **4**: app
* **downloading_apps table**:
    + **5**: downloading app
* **widgets table**:
    - **6**: widget

Knowing all these things, let's now take a look at all groups in the items
table:

```sql
sqlite> SELECT rowid, uuid, type, parent_id, ordering
   ...> FROM items
   ...> WHERE type IN (1, 2, 3)
   ...> ORDER BY parent_id, ordering, rowid;
rowid    uuid                                   type    parent_id  ordering
-------  -------------------------------------  ------  ---------  --------
1        ROOTPAGE                               1       0          0       
3        ROOTPAGE_DB                            1       0          0       
5        ROOTPAGE_VERS                          1       0          0       
2        HOLDINGPAGE                            3       1          0       
128      9B95AB89-78C9-409A-A5EE-B017F90294EE   3       1          1       
134      A63E0500-C4FA-4D12-B55B-2A39B579359E   3       1          2       
135      CEB3A866-8DD0-4B8E-A842-8E7AB95D42DF   3       1          3       
4        HOLDINGPAGE_DB                         3       3          0       
136      6D94ABA2-E715-440E-AF41-A2870EDDF19F   3       3          1       
6        HOLDINGPAGE_VERS                       3       5          0       
129      1518232C-A329-4CB3-849E-42FF30800331   2       128        18      
130      0F9BE4BE-F73E-4DF6-A3A7-864E4A64971F   3       129        0       
```

**Note**: DB refers to Dashboard and VERS refers to Version.

OK, so let's attempt to break this down.  We start with our root objects (as
also referenced in the dbinfo table):

```
rowid    uuid                                   type    parent_id  ordering
-------  -------------------------------------  ------  ---------  --------
1        ROOTPAGE                               1       0          0       
3        ROOTPAGE_DB                            1       0          0       
5        ROOTPAGE_VERS                          1       0          0       
```

So let's start with the root id 1 (Launchpad) and check out all the pages which have a parent_id referencing it:

```
rowid    uuid                                   type    parent_id  ordering
-------  -------------------------------------  ------  ---------  --------
2        HOLDINGPAGE                            3       1          0       
128      9B95AB89-78C9-409A-A5EE-B017F90294EE   3       1          1       
134      A63E0500-C4FA-4D12-B55B-2A39B579359E   3       1          2       
135      CEB3A866-8DD0-4B8E-A842-8E7AB95D42DF   3       1          3       
```

Here, we have the holding page first, and 3 pages with ids of 128, 134 and 135 
respectively.  Please also note that unlike apps and widgets, the ordering of
the actual page content starts at 1 due to the holding page occupying ordering
of 0.

Similarly, let's check out root id 3 (Dashboard) and all pages having it as
as a parent_id:

```
rowid    uuid                                   type    parent_id  ordering
-------  -------------------------------------  ------  ---------  --------
4        HOLDINGPAGE_DB                         3       3          0       
136      6D94ABA2-E715-440E-AF41-A2870EDDF19F   3       3          1       
```

Once again, a holding page and a single page with an id of 136.

We next check out the Launchpad version root of 5 which just contains a
holding page:

```
rowid    uuid                                   type    parent_id  ordering
-------  -------------------------------------  ------  ---------  --------
6        HOLDINGPAGE_VERS                       3       5          0       
```

And finally, we check out the **Other** folder:

```
rowid    uuid                                   type    parent_id  ordering
-------  -------------------------------------  ------  ---------  --------
129      1518232C-A329-4CB3-849E-42FF30800331   2       128        18      
130      0F9BE4BE-F73E-4DF6-A3A7-864E4A64971F   3       129        0       
```

Here, the folder root has an id of 129 and is present on the page with an id 
of 128 (i.e. page 1).  As seen earlier when examining the groups table,
the folder name is contained on the folder root object.

The first page of the folder has an id of 130.

Now let's check out the item relating to one of our apps 1Password, which had
an id of 9 as seen above in the apps table:

```sql
sqlite> SELECT rowid, uuid, type, parent_id, ordering
   ...> FROM items
   ...> WHERE rowid = 9;
rowid    uuid                                   type    parent_id  ordering
-------  -------------------------------------  ------  ---------  --------
9        26CFDC5B-F420-4FFC-A034-AA0A897B7A3A   4       134        0       
```

So this item has a parent_id of 134 (which is on 2).  The ordering is set to 0
which implies that it is the first item on page 2 (which indeed is the case
when examining Launchpad).

## Triggers

The SQLite database contains various triggers which set the ordering of
of items when an item is added, updated or deleted.

This for example allows you to insert rows into the items table with 
specifying the ordering and have the database automatically set ordering of the 
item to be the last on that page.

You may disable this trigger by setting a key called
**ignore_items_update_triggers** in the dbinfo table as follows:

```sql
UPDATE dbinfo
SET value = 1
WHERE key = 'ignore_items_update_triggers';
```

You may enable it again by setting the value to 0:

```sql
UPDATE dbinfo
SET value = 0
WHERE key = 'ignore_items_update_triggers';
```

Please find below the most important triggers and some comments about
how they work:

```sql
-- Action: An item has been inserted to the items table.
-- Processing: Sets the ordering to the maximum ordering + 1 on the page
--             or folder where the item was added.
-- Notes: You can't insert an item at an ordering of 0 (i.e. first item on
--        a page), it appears that you must move it to a new page (i.e.
--        via an update) to do that.
CREATE TRIGGER insert_item AFTER INSERT on items
WHEN 0 == (SELECT value FROM dbinfo WHERE key = 'ignore_items_update_triggers')
BEGIN
  UPDATE dbinfo SET value = 1 WHERE key = 'ignore_items_update_triggers';

  UPDATE items
  SET ordering = (
    SELECT ifnull(MAX(ordering), 0) + 1
    FROM items
    WHERE parent_id = new.parent_id
  )
  WHERE ROWID = new.rowid;

  UPDATE dbinfo SET value = 0 WHERE key = 'ignore_items_update_triggers';
END;

-- Action: An item has been moved to the right.
-- Processing: Sets the ordering of all items between the original and new
--             position of the item to move left by 1.
CREATE TRIGGER update_items_order BEFORE UPDATE OF ordering ON items
WHEN new.ordering > old.ordering
AND 0 == (SELECT value FROM dbinfo WHERE key = 'ignore_items_update_triggers')
BEGIN
  UPDATE dbinfo SET value = 1 WHERE key = 'ignore_items_update_triggers';

  UPDATE items
  SET ordering = ordering - 1
  WHERE parent_id = old.parent_id
  AND ordering BETWEEN old.ordering and new.ordering;

  UPDATE dbinfo SET value = 0 WHERE key = 'ignore_items_update_triggers';
END;

-- Action: An item has been moved to the left.
-- Processing: Sets the ordering of all items between the original and new
--             position of the item to move right by 1.
CREATE TRIGGER update_items_order_backwards BEFORE UPDATE OF ordering ON items
WHEN new.ordering < old.ordering
AND 0 == (SELECT value FROM dbinfo WHERE key = 'ignore_items_update_triggers')
BEGIN
  UPDATE dbinfo SET value = 1 WHERE key = 'ignore_items_update_triggers';

  UPDATE items
  SET ordering = ordering + 1
  WHERE parent_id = old.parent_id
  AND ordering BETWEEN new.ordering and old.ordering;

  UPDATE dbinfo SET value = 0 WHERE key = 'ignore_items_update_triggers';
END;

-- Action: An item has been moved to a different page or folder.
-- Processing: Sets the ordering to the maximum ordering + 1 on the page
--             where the item was moved.
CREATE TRIGGER update_item_parent AFTER UPDATE OF parent_id ON items
WHEN 0 == (SELECT value FROM dbinfo WHERE key = 'ignore_items_update_triggers')
BEGIN
  UPDATE dbinfo SET value = 1 WHERE key = 'ignore_items_update_triggers';

  UPDATE items
  SET ordering = (
    SELECT ifnull(MAX(ordering), 0) + 1
    FROM items
    WHERE parent_id = new.parent_id
    AND ROWID != old.rowid
  )
  WHERE ROWID = old.rowid;

  UPDATE items
  SET ordering = ordering - 1
  WHERE parent_id = old.parent_id
  AND ordering > old.ordering;

  UPDATE dbinfo SET value = 0 WHERE key = 'ignore_items_update_triggers';
END;

-- Action: An item has been deleted.
-- Processing: Deletes any related app, group, widget or dowloading app with
--             the item of the item.  The trigger then moves all items after
--             the deleted item left by 1.
CREATE TRIGGER item_deleted AFTER DELETE ON items
BEGIN
  DELETE FROM apps WHERE rowid = old.rowid;
  DELETE FROM groups WHERE item_id = old.rowid;
  DELETE FROM widgets WHERE rowid = old.rowid;
  DELETE FROM downloading_apps WHERE item_id = old.rowid;

  UPDATE dbinfo SET value = 1 WHERE key = 'ignore_items_update_triggers';

  UPDATE items
  SET ordering = ordering - 1
  WHERE old.parent_id = parent_id
  AND ordering > old.ordering;

  UPDATE dbinfo SET value = 0 WHERE key = 'ignore_items_update_triggers';
END;
```

## Closing Words

I am currently working on a little Python script which will allow you to
build your Launchpad via a YAML file using my findings.

One of the trickiest things to deal with are the triggers and seeing as how
no trigger really allows ordering to be set to 0, I think that any automation
tools should disable triggers while building these tables.

Further to this, it is important to take care when deleting items as this also
deletes the respective entry from the apps (or widgets) tables which is likely
undesirable.

Hope this was helpful and Merry Christmas everyone! :)
