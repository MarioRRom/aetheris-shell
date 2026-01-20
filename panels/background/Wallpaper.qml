//===========================================================================
//
//
//███╗   ███╗ █████╗ ██████╗ ██╗ ██████╗ ██████╗ ██████╗  ██████╗ ███╗   ███╗
//████╗ ████║██╔══██╗██╔══██╗██║██╔═══██╗██╔══██╗██╔══██╗██╔═══██╗████╗ ████║
//██╔████╔██║███████║██████╔╝██║██║   ██║██████╔╝██████╔╝██║   ██║██╔████╔██║
//██║╚██╔╝██║██╔══██║██╔══██╗██║██║   ██║██╔══██╗██╔══██╗██║   ██║██║╚██╔╝██║
//██║ ╚═╝ ██║██║  ██║██║  ██║██║╚██████╔╝██║  ██║██║  ██║╚██████╔╝██║ ╚═╝ ██║
//╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═╝ ╚═╝ ╚═════╝ ╚═╝     ╚═╝                                                                          
//                          MarioRRom's Dotfiles
//                 https://github.com/MarioRRom/bspwm-dotfiles
//===========================================================================


import QtQuick
import QtMultimedia

Item {

    property var sourceWallpaper: "file:///home/mario/.config/quickshell/wallpapers/bocchi.png"
    property bool isVideoWallpaper: false

    Image {
        id: wallpaper
        anchors.fill: parent
        visible: !isVideoWallpaper
        cache: false
        smooth: false
        fillMode: Image.PreserveAspectCrop

        // Ruta del wallpaper
        source: sourceWallpaper
    }

    Video {
        id: wallpaperVideo
        anchors.fill: parent
        visible: isVideoWallpaper
        autoPlay: isVideoWallpaper
        loops: MediaPlayer.Infinite
        fillMode: VideoOutput.PreserveAspectCrop

        // Ruta del video de fondo
        source: sourceWallpaper
    }
}