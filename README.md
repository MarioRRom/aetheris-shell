<div align="center">

<pre>
 ▄▄▄      ▓█████▄▄▄█████▓ ██░ ██ ▓█████  ██▀███   ██▓  ██████ 
▒████▄    ▓█   ▀▓  ██▒ ▓▒▓██░ ██▒▓█   ▀ ▓██ ▒ ██▒▓██▒▒██    ▒ 
▒██  ▀█▄  ▒███  ▒ ▓██░ ▒░▒██▀▀██░▒███   ▓██ ░▄█ ▒▒██▒░ ▓██▄   
░██▄▄▄▄██ ▒▓█  ▄░ ▓██▓ ░ ░▓█ ░██ ▒▓█  ▄ ▒██▀▀█▄  ░██░  ▒   ██▒
 ▓█   ▓██▒░▒████▒ ▒██▒ ░ ░▓█▒░██▓░▒████▒░██▓ ▒██▒░██░▒██████▒▒
 ▒▒   ▓▒█░░░ ▒░ ░ ▒ ░░    ▒ ░░▒░▒░░ ▒░ ░░ ▒▓ ░▒▓░░▓  ▒ ▒▓▒ ▒ ░
  ▒   ▒▒ ░ ░ ░  ░   ░     ▒ ░▒░ ░ ░ ░  ░  ░▒ ░ ▒░ ▒ ░░ ░▒  ░ ░
  ░   ▒      ░    ░       ░  ░░ ░   ░     ░░   ░  ▒ ░░  ░  ░  
      ░  ░   ░  ░         ░  ░  ░   ░  ░   ░      ░        ░  
</pre>
 
<img
  src="https://readme-typing-svg.demolab.com?font=Iosevka&size=16&pause=1000&color=cba6f7&center=true&vCenter=true&width=565&lines=A+shell+for+people+who+like+their+tiling+WM+to+feel+alive."
  alt="Typing SVG"
/>
 
<p>
  <a href="./LICENSE"><img src="https://img.shields.io/badge/license-GPL--3.0-a6e3a1?style=for-the-badge&logo=gnu&logoColor=cdd6f4&labelColor=1e1e2e" alt="License: GPL-3.0"></a>
  <a href="https://quickshell.outfoxxed.me/"><img src="https://img.shields.io/badge/built%20with-Quickshell-89b4fa?style=for-the-badge&logo=qt&logoColor=cdd6f4&labelColor=1e1e2e" alt="Built with Quickshell"></a>
  <a href="https://ko-fi.com/mariorrom"><img src="https://img.shields.io/badge/support-Ko--fi-cba6f7?style=for-the-badge&logo=kofi&logoColor=cdd6f4&labelColor=1e1e2e" alt="Support on Ko-fi"></a>
</p>
<p>
  <a href="#-project-status"><img src="https://img.shields.io/badge/status-pre--alpha-f38ba8?style=for-the-badge&logo=git&logoColor=cdd6f4&labelColor=1e1e2e" alt="Status: pre-alpha"></a>
  <a href="https://github.com/MarioRRom/aetheris-shell/stargazers"><img src="https://img.shields.io/github/stars/MarioRRom/aetheris-shell?style=for-the-badge&logo=github&logoColor=cdd6f4&labelColor=1e1e2e&color=f9e2af&label=stars" alt="Stars"></a>
</p>
</div>

> [!WARNING]
> ### ⚠️ Project Status: Pre-Alpha / Under Development
>
> **Ætheris-shell** is currently in a **very early stage of development**.
>
> - **Instability:** expect bugs, unexpected crashes, and erratic behavior.
> - **Incomplete features:** many parts are unimplemented or half-finished.
> - **Breaking changes:** structure and configuration may change radically without notice.
>
> *Not recommended for daily use in production environments yet.*

<div align="center">
<img src="assets/preview/preview.png" alt="Ætheris-shell preview" width="800px">

<sub>📹 A demo video is planned for a future update.</sub>
</div>

## ✨ What is Ætheris-shell?

**Ætheris-shell** is a desktop shell built on top of **[Quickshell](https://quickshell.outfoxxed.me/)** (QtQuick/QML), created to give tiling window managers a cohesive, animated, and modern interface — without giving up the control and minimalism that draws people to tiling in the first place.

Instead of stitching together separate tools for bars, wallpapers, and window-manager glue scripts (Polybar, Eww, Waybar, and friends), Ætheris-shell aims to be **one coherent QML-driven layer** that talks directly to your WM/compositor, reacts to it in real time, and looks like it was designed on purpose.

The name comes from *Aether*, a character from a game whose story left a real mark on me, even after I stepped away from it. There are a few visual nods to that here and there, but recreating a game's UI was never the goal — the goal is to let ideas flow naturally into something detailed and comfortable to actually live in day to day. Above all, this project is about **sharing**: ricing is what got me into Linux in the first place, and Ætheris-shell is my way of putting a piece of that environment out into the world for others to use, tweak, and build on.

## 🖥️ Supported Environments
 
**Ætheris-shell** is planned to support a range of window managers and desktop environments, across both **X11** and **Wayland**. BSPWM is where most of the active development happens today, but the architecture isn't tied to it — Hyprland already runs, and more targets are on the roadmap as the shell matures.
 
| Environment | Display Server | Support Level |
|---|---|:---:|
| **BSPWM** | X11 | 🟢 Main target |
| **Hyprland** | Wayland | 🟡 Experimental |
| **i3** | X11 | ⚪ Planned |
| **Sway** | Wayland | ⚪ Planned |
 
**Legend:** 🟢 Main target, actively developed · 🟡 Experimental / usable but incomplete · ⚪ Planned, not started


## 🚀 Features

Under the hood, Ætheris-shell is built around several modules designed to
provide a comfortable and visually polished desktop experience.

Each module is responsible for a specific part of the shell:

<table>
<tr>
<td width="220">

<img src="assets/preview/systeminfo.png" width="200">

</td>

<td>

### EUTHYMIA *(systeminfo)*

> *The Plane of Eternal Consciousness.*

Monitors hardware integrity and energy flow. Like the alchemical opus,
system variables remain in an immutable constant, free from the erosion
of the system.

**Capabilities**

- Live `CPU`, `RAM` and `Disk` usage
- Temperature monitoring (°C / °F)
- User profile card
- Logout, Suspend, Reboot and Shutdown actions

</td>
</tr>
</table>

---

<table>
<tr>
<td> 

### Control Player

> *The Symphony of Endless Resonance.*

A unified media controller built on `MPRIS`, providing a consistent interface
for your favorite music players. Designed to keep playback controls always
within reach, without breaking your workflow.

**Capabilities**

- Control any `MPRIS` compatible media player
- Interactive playback timeline with seek support
- Application volume control *(when supported)*
- Play/Pause, Previous and Next controls
- Shuffle and Repeat modes
- Built-in player switcher for quick source selection

</td>

<td width="320">

<img src="assets/preview/controlplayer.png" alt="controlplayer" width="300px">

</td>
</tr>
</table>

---

<table>
<tr>
<td width="320">

<img src="assets/preview/akasha.png" alt="akasha" width="300px">

</td>

<td>

### AKASHA *(centerpanel)*

> *The terminal of absolute wisdom.*

Centralizes the reception of data and external notifications.
Transforms the flow of raw information into actionable knowledge for the user, operating as Sumeru's neural network.

**Capabilities**

- Centralized notification archive
- Dynamic clock and date display
- Interactive calendar overview
- Real-time weather information card

</td>
</tr>
</table>

---

<table>
<tr>
<td> 

### KHEMIA *(controlcenter)*

> *The art of primordial transmutation.*

Interface designed to alter environment variables.
It doesn't just adjust parameters; it reshapes the desktop environment, breaking through the limitations imposed by the system.

**Capabilities**

- Networking quick settings
- Bluetooth controls *(WIP)*
- Volume and microphone controls with sink/source selection
- Quick toggle grid *(WIP)*

</td>

<td width="220">

<img src="assets/preview/controlcenter.png" alt="KHEMIA" width="200px">

</td>
</tr>
</table>

---

<table>
<tr>
<td width="320">

<img src="assets/preview/desktop.png" alt="akasha" width="300px">

</td>

<td>

### Irminsul *(the bar)*

> *The axis of the world.*

The upper structure that holds the information network.
Acts as the main branch from which the knowledge of Akasha and the transmutations of Khemia emerge.

**Capabilities**

- Workspace and system information
- Now Playing information display
- Clock and weather
- Integrated shell controls

**Wallpaper System**

- Quickshell-native wallpaper rendering
- Video wallpaper support
- Overlay visual widgets *(currently Now Playing)*

</td>
</tr>
</table>

### 🔮 Roadmap

- A **dock** at the bottom of the screen for quickly launching pinned apps and viewing currently open windows.
- A **Polkit authentication window** (actively being developed on a feature branch).
- A **settings window** to unify all of the shell's configuration in one place.
- **Battery & brightness support** for laptops.

## 🛠️ Requirements

- **[Quickshell](https://quickshell.outfoxxed.me/)** — the QML runtime Ætheris-shell is built on.
- **BSPWM** (X11):
  - System dependencies: `xrandr`, `xwininfo`, `xprop`, `xdo`, `picom` (used by the helper scripts).
- **Hyprland** (Wayland):
  - System dependencies: *none for now.*

## 🚀 Installation

### Quick install (dotfiles)

> [!NOTE]
> This repo contains only the **shell itself**. If you just want to install and run Ætheris-shell with a ready-to-use environment (configs, keybinds, autostart, etc.), head to the dotfiles repo instead:
>
> **➡️ Ætheris-dots (link coming soon — 🚧 work in progress)**
>
> The dotfiles repo will ship an automated installer that sets everything up for you. Use this path once it's available if you just want to run the shell without customizing it yourself.

If you plan to integrate Ætheris-shell into your **own** config, or want to contribute to development, keep reading below for manual installation.

### Manual installation
 
First, clone the repo and place its contents in `~/.config/quickshell`:
 
```bash
git clone https://github.com/MarioRRom/aetheris-shell ~/.config/quickshell
```
 
<details>
<summary><b>BSPWM setup</b></summary>

Add the following to your `bspwmrc`:
 
```bash
export XDG_CURRENT_DESKTOP=bspwm
 
# Assign workspaces to each monitor based on its hardware name (xrandr).
# This is required so Quickshell can correctly identify the screens.
workspaces() {
    paste <(bspc query -M) <(xrandr --query | grep " connected" | awk '{print $1}') | \
    while read -r monitor_id monitor_name; do
        # Change the number of workspaces to your liking
        bspc monitor "${monitor_id}" -n "${monitor_name}" -d '1' '2' '3' '4' '5' '6'
    done
}
workspaces
 
quickshell &
```

</details>

<details>
<summary><b>Hyprland setup</b></summary>

Simply launch it at startup in your `hyprland.conf`:
 
```bash
exec-once = quickshell
```

</details>

## 🧩 Architecture & Development
 
Want to contribute? All the details live in two documents so this README doesn't turn into a wall of text:
 
- 📐 **[CODING_GUIDELINES.md](./.github/CODING_GUIDELINES.md)** — the most important one if you want to understand the project deeply: architecture, folder structure, QML conventions, and how development actually works here.
- 📖 **[CONTRIBUTING.md](./.github/CONTRIBUTING.md)** — the rules to follow when opening issues and PRs.
- 📚 **Wiki** — *work in progress*. Will cover day-to-day usage and configuration once the shell stabilizes.

### Running it locally for development
 
Since Ætheris-shell lives directly in `~/.config/quickshell`, cloning it there (see [Manual installation](#manual-installation)) *is* your dev setup. Quickshell's default entry point is `shell.qml`, and it hot-reloads automatically whenever you edit a file — no restart needed.
 
Run it straight from a terminal to see live logs while you work:
 
```bash
quickshell
```
 
## 💡 Inspirations

Ætheris-shell would not exist without the ideas (and code) from other shells and configuration files in this space, as well as the support and feedback from a number of people :)
Among them are:

- **[Syndrizzle](https://github.com/syndrizzle/hotfiles/tree/bspwm)**
- **[Raexera](https://github.com/raexera/tokyo)**
- **[Ghostzk](https://github.com/gh0stzk/dotfiles)**
- **[Axarva](https://github.com/Axarva/dotfiles-2.0)**
- **[soramane](https://github.com/caelestia-dots/shell)**
- **[end-4](https://github.com/end-4/dots-hyprland)**

---

### ☕ Support

If you like my work and want to support it, you can buy me a coffee on Ko-fi. Any help is welcome! ☕

<a href="https://ko-fi.com/mariorrom">
  <img src="https://ko-fi.com/img/githubbutton_sm.svg" alt="ko-fi" width="200px">
</a>
