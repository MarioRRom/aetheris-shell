# Ætheris Shell — Coding Guidelines

This document describes the coding conventions, formatting rules, and architectural practices used throughout Ætheris Shell.

The objective is simple:

* keep the codebase readable
* preserve consistency between modules
* simplify long-term maintenance
* make contributions easier to review

These guidelines are not meant to restrict contributors unnecessarily.
They exist to keep the project coherent as it grows.

---

# General Philosophy

Ætheris Shell follows a modular and readable architecture.

The project prioritizes:

* separation between UI and backend logic
* reusable components
* predictable structure
* readable QML
* visually organized source files
* minimal unnecessary abstraction

When contributing:

* follow existing patterns whenever possible
* preserve consistency over personal preference
* avoid introducing radically different styles between files

---

# Project Structure

## `modules/`

Contains the visible shell modules and UI features.

Examples:

* bar
* controlcenter
* notifications
* overlays
* systeminfo

Modules are responsible for rendering the shell interface.

---

## `services/`

Contains backend integrations and communication with the external system.

Examples:

* PipeWire
* NetworkManager
* Hyprland IPC
* BSPWM sockets
* MPRIS

Avoid placing backend/system logic directly inside UI modules.

---

## `components/`

Reusable generic UI components shared across the shell.

Examples:

* sliders
* switches
* progress bars
* reusable visual elements

---

## `themes/`

Theme management and colorschemes.

---

## `i18n/`

Localization and translation system.

English acts as the base and fallback language.

---

# File Header

Every `.qml` file starts with the project banner:

```qml
//===========================================================================
//
//
//███╗   ███╗ █████╗ ██████╗ ██╗ ██████╗ ██████╗ ██████╗  ██████╗ ███╗   ███╗
//████╗ ████║██╔══██╗██╔══██╗██║██╔═══██╗██╔══██╗██╔══██╗██╔═══██╗████╗ ████║
//██╔████╔██║███████║██████╔╝██║██║   ██║██████╔╝██████╔╝██║   ██║██╔████╔██║
//██║╚██╔╝██║██╔══██║██╔══██╗██║██║   ██║██╔══██╗██╔══██╗██║   ██║██║╚██╔╝██║
//██║ ╚═╝ ██║██║  ██║██║  ██║██║╚██████╔╝██║  ██║██║  ██║╚██████╔╝██║ ╚═╝ ██║
//╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═╝ ╚═╝ ╚═════╝ ╚═╝     ╚═╝
//                          MarioRRom's Aetheris Shell
//                 https://github.com/MarioRRom/aetheris-shell
//===========================================================================
```

Leave one blank line after the header.

---

# Imports

Imports are grouped by purpose and separated by a blank line.

```qml
// Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell

// Internal modules
import qs.config
import qs.components
import qs.services
import qs.themes
```

Typical grouping:

* Qt / Quickshell
* Internal project imports
* External dependencies

Avoid unordered import blocks.

---

# Section Separators

Ætheris Shell uses two separator styles.

---

## ASCII Section Block

Used for major sections.

```qml
//  .-------------------------.
//  | .---------------------. |
//  | |      Animations     | |
//  | `---------------------' |
//  `-------------------------'
```

Use for:

* animations
* component definitions
* backend/service sections
* public APIs
* large logical groups

Spacing rules:

* two blank lines above
* one blank line below

Example:

```qml
Item { id: previousComponent }


//  .-------------------------.
//  | .---------------------. |
//  | |      Animations     | |
//  | `---------------------' |
//  `-------------------------'

SequentialAnimation { }
```

---

## Simple Comment Separator

Used for compact or minor sections.

```qml
// Popup settings
// Signals
// Internal state
```

Leave one blank line above the comment.

---

# Typical Component Structure

Most components should follow a predictable order.

Typical layout:

1. `id`
2. Public properties
3. Internal state/config
4. Signals
5. Backend/service bindings
6. Public API
7. Main component structure
8. Animations/timers
9. Connections
10. Lifecycle hooks

Exact ordering may vary depending on complexity.

The important part is consistency and readability.

---

# QML Conventions

## Keep Functions Focused

Functions should have a single responsibility.

Good:

```qml
function clearAll() { }
function toggleDnd() { }
function updateWeather() { }
```

Avoid giant multi-purpose functions.

---

## Prefer Descriptive Naming

Public APIs should be explicit and easy to understand.

Good:

```qml
toggleNotifications()
clearExpiredPopups()
updateNetworkState()
```

Short variable names are acceptable for obvious local context.

---

## One Statement Per Line

Good:

```qml
if (condition) {
    doSomething()
}
```

Avoid compressed logic.

Bad:

```qml
if (condition) doSomething(), doSomethingElse()
```

---

## Use Spaces After Keywords

```qml
if (condition)
for (const item of list)
while (running)
```

---

## One Declaration Per Line

Good:

```qml
property int width
property int height
```

Avoid grouped declarations.

---

## Avoid Trailing Whitespace

Editors should automatically remove trailing spaces on save.

---

# Comments

Comments should explain intent, not obvious implementation details.

Good:

```qml
// Automatically remove expired notifications
```

Bad:

```qml
// Increment counter by one
counter++
```

Assume the reader already understands QML syntax.

---

# Internationalization (i18n)

All internal code, comments, documentation, and identifiers should use English.

Translations are stored in:

```txt
i18n/translations/
```

Translation keys should remain:

* stable
* descriptive
* predictable

Examples:

```qml
"systeminfo.shutdown"
"network.disconnected"
"weather.loading"
```

Avoid vague or inconsistent naming.

---

# Architecture Practices

## Separate UI and Backend Logic

UI modules should avoid directly handling:

* IPC
* DBus
* sockets
* system parsing
* backend state management

These responsibilities belong inside `services/`.

---

## Reuse Components

If a visual element appears multiple times:

* move it into `components/`
* avoid duplicating QML structures

---

## Preserve Existing Patterns

When modifying existing code:

* follow nearby formatting
* preserve section ordering
* avoid introducing new patterns unnecessarily

Consistency across files is more important than individual style preference.

---

# Final Notes

These guidelines are intended to keep Ætheris Shell maintainable and approachable for contributors.

When in doubt:

* prioritize readability
* preserve consistency
* avoid unnecessary complexity
* follow existing project patterns
