#### 9.0
* Updated for Shadowlands and Classic servers.

##### 8.2
* Updated for World of Warcraft patch 8.2.0.

#### 8.0
* Updated for Battle for Azeroth.
* Updated item database.

#### 7.3
* Updated for Shadow of Argus.
* Updated item database.

#### 7.2
* Major update! Ludwig database is now available in 12 different locales!
  - All locales are included in download. At startup, Ludwig detects your client locale and loads the corresponding database.
  - Localization data obtained directly from Blizzard's database.
* Updated item database to Tomb of Sargeras.

#### 7.1
* Updated for Return to Kharazan.
* Updated item database.

#### 7.0
* This version fixes all previous issues with the database.
* Completly rewrote database generation procedure.
* Redesigned database storage.
* Linking items in chat is now functional again.
* Item category dropdown contents are now generated on demand.
* Updated for Legion.

##### 6.1
* Updated for WoW 6.1.
* Fixed issue with frame positioning.

##### 6.0.2
* Fixed preventing links generated by the addon from showing in the chat frame.
* Fixed issue preventing slash commands from working properly.
* Fixed bug issue in the linkerator generating error messages but having no effect.

##### 6.0.1
* Updated database with new items and categories.

##### 6.0.0
* Updated for The Iron Tide.

##### 5.4.2
* Added LibDataBroker support (for addons such as Titan, Bagnon, ChocolateBar, or ButtonBin).

##### 5.4.1
* Fixed all isues preventing the linkerator from working properly.
  - Links can now be posted to chat.
  - Whitespace characters are no longer ignored.
* Largely optimized linkerator's performance (about 15 times faster). It now delivers results in realtime.
* Reduced database size by 10%. This means less memory usage and slighly faster searches.
* Improved search by level performance.

##### 5.4.0
* Updated for Siege of Ogrimmar.

#### 5.3
* Updated for patch Escalation.

##### 5.2.1
* Added some missing items.

#### 5.2.0
* Updated database for patch The Thunder King.

##### 2.0.5
* Updated database to patch 5.1: Landfall.

##### 2.0.4
* Updated database for Mists of Pandaria

##### 2.0.3
* Fixed a bug causing wrong items to be shown for leather, mail and plate slots
* Items are now organized by level as well
* No more "Jaliborc:" tag from now on. If no tag is here, it means it was me.

##### 2.0.2
* Completly rewritten the categories dropdown to fix a bug

##### 2.0.1
* Updated for patch 4.2
* Included all Firelands items

#### 2.0.0
* Now works with 4.1
* Completely redesigned and improved
* Includes **all** items in-game right from the start
* Searches trough thousands of items in a blaze
* Mostly //Load on Demand//
* Only works on English clients. Versions for other clients should be released in a close future.

##### 1.8.7
* Added linkerator support for multiple chat frames

##### 1.8.6
* Fixed a bug when linking an item from the chat frame.

##### 1.8.5
* Added compatibility with WoW 3.3.5

##### 1.8.3
* Bumped TOC for 3.3

##### 1.8.2
* Bumped TOC for 3.2

##### 1.8.1
* TOC Bump + Potential WIM bugfix

#### 1.8.0
* Added "Heirloom" option to quality selector
* Fixed a bug causing the DB to be reloaded on item scroll
* Cleaned up the code a bit.  Still need to work on the GUI/localization
* Altered slash commands.  See addon description for details.

##### 1.7.2
* Bumped the max item ID to check from 40k to 60k.  Glyphs, etc, should now appear.

##### 1.7.1
* Fixed a crash issue when linking tradeskills

#### 1.7.0
* Made Wrath compatible
* Seems to be causing a lot more CPU usage now, will investigate later