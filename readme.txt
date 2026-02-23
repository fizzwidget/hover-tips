# Fizzwidget HoverTips
- by Gazmik Fizzwidget
- http://github.com/fizzwidget/hovertips

## Introduction 

So, you've heard of Gnomish X-Ray Specs? Like most Gnomish technology, they're good for giggles but of little practical value.

These lenses, on the other hand (er, eye?) let you really "look into" things. Anything you merely glance at -- an item, units of some currency, a record of someone's great achievement, the name of a spell, and all sorts of things normally requiring close inspection -- is fully described for your perusal. And they even work with whatever headgear you already have!

## Features 
- Causes the tooltips normally viewed when clicking a link in the chat window to appear automatically when just mousing over the link, for these link types:
	- item, enchant, spell, quest, unit, talent, achievement, glyph, instance lock, currency
- Adds tooltips with useful information to other link types:
	- player (for WoW friends, Battle.net friends, and guild members only)
	- dungeon journal
- If you're also using my DiggerAid addon for archaeology, this addon enables mouseover tips for its custom hyperlink types (one which describes an artifact in progress, and the "click to solve" link).

### Acknowledgments
Originally based on a secondary feature of Tekkub's tekKompare addon (http://tekkub.net)
	
### For Addon Authors

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
	
## Version History

### v. 12.0 - 2026/xxxx/yyyy
- Updated TOC to indicate compatibility with WoW Patch 12.0 (Midnight).
- Fixed ChatFrame hooking so hovering for tooltips actually works again.
- Adds mouseover tooltips to chat in the Guild/Communities window.
- Adds tooltips for Housing endeavor task links and map pin links.
- Adds currency names to tooltips for unlearned recipe sources in the Professions window.
- Alt-click an achievement link to show that achievement in the Achievements window.
- Disabled support for player and Battle.net player link tooltips.
- Added a system for other addons to provide tooltips. See "For Addon Authors" in this readme for details.

