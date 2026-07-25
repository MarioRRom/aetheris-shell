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


//  .-------------------------.
//  | .---------------------. |
//  | |   Import Modules    | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
pragma ComponentBehavior: Bound
import QtQuick
import QtMultimedia

Item {
    id: wallpaper
    property var sourceWallpaper: "../../assets/wallpapers/paimon.png"
    property bool isVideoWallpaper: false

    Image {
        id: wallpaperImage
        anchors.fill: parent
        visible: !wallpaper.isVideoWallpaper
        cache: false
        smooth: false
        fillMode: Image.PreserveAspectCrop

        // Wallpaper Path
        source: wallpaper.sourceWallpaper
    }

    Video {
        id: wallpaperVideo
        anchors.fill: parent
        visible: wallpaper.isVideoWallpaper
        autoPlay: wallpaper.isVideoWallpaper
        loops: MediaPlayer.Infinite
        fillMode: VideoOutput.PreserveAspectCrop

        // Wallpaper Path
        source: wallpaper.sourceWallpaper
    }
}