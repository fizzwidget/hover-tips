------------------------------------------------------
Fizzwidget HoverTips
by Gazmik Fizzwidget
http://fizzwidget.com/hovertips
gazmik@fizzwidget.com
------------------------------------------------------

So, you've heard of Gnomish X-Ray Specs? Like most Gnomish technology, they're good for giggles but of little practical value.

These lenses, on the other hand (er, eye?) let you really "look into" things. Anything you merely glance at -- an item, units of some currency, a record of someone's great achievement, the name of a spell, and all sorts of things normally requiring close inspection -- is fully described for your perusal. And they even work with whatever headgear you already have!

------------------------------------------------------

INSTALLATION: Put this folder into your World Of Warcraft/Interface/AddOns folder and launch WoW.

FEATURES: 
	- Causes the tooltips normally viewed when clicking a link in the chat window to appear automatically when just mousing over the link, for these link types:
		- item, enchant, spell, quest, unit, talent, achievement, glyph, instance lock, currency
	- Adds tooltips with useful information to other link types:
		- player (for WoW friends, Battle.net friends, and guild members only)
		- dungeon journal
	- If you're also using my DiggerAid addon for archaeology, this addon enables mouseover tips for its custom hyperlink types (one which describes an artifact in progress, and the "click to solve" link).

ACKNOWLEDGMENTS:
	- Originally based on a secondary feature of Tekkub's tekKompare addon (http://tekkub.net), which I still recommend. (It shows item comparison tooltips in all cases, not just at the times where the default UI thinks it's useful.)
	
For Addon Authors
-----------------
If your addon already provides and handles its own `addon:` hyperlinks, you can work with HoverTips to give them mouseover tooltips in chat windows. 

- HoverTips looks for a link handler function in two ways:
	- Add your function to the `GFW_HoverTips.AddonLinkHandlers` table.
	- If your addon has a table whose global name matches that of your TOC file, we automatically look for a function named `ShowAddonTooltip`.
- HoverTips will invoke your link handler when mousing over links of the form `addon:your-addon-name:link-content`.
- The form of the link handler is `function(frame, link)`:
	- The `link` parameter has the hyperlink data (a set of colon-separated strings), including the initial `addon` prefix and your addon name. Parse it to decide what to show in your tooltip.
	- Add content to `GameTooltip`, or create your own tooltip frame, and show it.
	- Use the `frame` parameter to anchor/position your tooltip relative to the chat window showing a link.
	- Return your tooltip frame (so that HoverTips can hide it when the link is no longer moused over).
	
------------------------------------------------------
VERSION HISTORY

v. 11.1 - 2025/xxxx/yyyy
- Updated TOC to indicate compatibility with WoW Patch 11.1 (and The War Within).
- Fixed ChatFrame hooking so hovering for tooltips actually works again.
- Disabled support for player and Battle.net player link tooltips.
- Added a system for other addons to provide tooltips. See "For Addon Authors" in this readme for details.

v. 8.0 - 2018/08/04
- Updated TOC to indicate compatibility with WoW Patch 8.0 and Battle for Azeroth.
- Fixed errors with Battle.net links.
- Added support for battle *pet* links. (Thanks ceylina!)
- Added support for Mythic+ dungeon keystone links. (Thanks again ceylina!)

v. 7.0 - 2016/08/18
- Updated TOC to indicate compatibility with WoW Patch 7.0.
- Handles icons for Battle.net friends in newer games.

v. 6.0 - 2014/10/14
- Updated TOC to indicate compatibility with WoW Patch 6.0.

v. 5.2 - 2013/03/05
- Updated TOC to indicate compatibility with WoW Patch 5.2.

v. 5.1 - 2012/12/19
- Updated TOC to indicate compatibility with WoW Patch 5.1.
- Fixed an error when mousing over Battle.net friend links.
- Fixed an error when mousing over Dungeon Journal "tier" links (such as appear when gaining a level, e.g. "You're now eligible for [Cataclysm] Heroics").

v. 5.0 - 2012/08/28
- Updated TOC to indicate compatibility with WoW Patch 5.0.

v. 4.3.2 - 2012/06/17
- Fixed some issues with tooltips for player links (for WoW friends and guild members).

v. 4.3.1 - 2012/06/05
- Added hover tooltips for Battle.net friend links (seen when such friends go online/offline or chat), providing all the info normally found in the Friends panel.

v. 4.3 - 2011/12/30
- Initial release.

See http://fizzwidget.com/notes/hovertips/ for older release notes.