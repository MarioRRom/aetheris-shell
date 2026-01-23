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
//  | |  Importar Modulos   | |
//  | `---------------------' |
//  `-------------------------'


// Quickshell
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Globales
import qs.themes

QtObject {
    id: weatherManager
    
    // Configuración
    property string units: "metric"
    
    // Datos del clima
    property string temperature: "N/A"
    property string description: "Cargando..."
    property string location: "Unknown"
    property string windSpeed: "0 m/s"
    property string humidity: "0%"
    property string icon: "?"
    property string color: "#F28FAD"
    property string backgroundImage: "rain.png"
    
    // Timer de actualización (15 minutos)
    property Timer updateTimer: Timer {
        interval: 900000
        running: true
        repeat: true
        onTriggered: fetchLocation()
    }
    
    Component.onCompleted: {
        fetchLocation()
    }
    
    // Obtener ubicación para mas Precisión
    function fetchLocation() {
        var url = "http://ip-api.com/json"
        
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    try {
                        var data = JSON.parse(xhr.responseText)
                        fetchWeather(data.lat, data.lon, data.city)
                    } catch (e) {
                        setErrorState()
                    }
                } else {
                    setErrorState()
                }
            }
        }
        
        xhr.open("GET", url)
        xhr.send()
    }
    
    // Obtener clima desde la wttr.in
    function fetchWeather(lat, lon, city) {
        var url = "https://wttr.in/" + lat + "," + lon + "?format=j1"
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    try {
                        var data = JSON.parse(xhr.responseText)
                        processWeatherData(data, city)
                    } catch (e) {
                        setErrorState()
                    }
                } else {
                    setErrorState()
                }
            }
        }
        xhr.open("GET", url)
        xhr.send()
    }
    
    // Procesar datos del clima
    function processWeatherData(data, cityName) {
        var current = data.current_condition[0]
        
        var temp = units === "metric" ? current.temp_C : current.temp_F
        var wind = units === "metric" ? (current.windspeedKmph / 3.6).toFixed(1) : current.windspeedMiles
        var hum = current.humidity
        var desc = current.weatherDesc[0].value
        var code = current.weatherCode
        
        var iconData = getIconData(code)
        var tempUnit = units === "metric" ? "°C" : "°F"
        var windUnit = units === "metric" ? " m/s" : " mph"
        
        temperature = temp + tempUnit
        description = capitalizeFirst(desc)
        location = cityName
        windSpeed = wind + windUnit
        humidity = hum + "%"
        icon = iconData.icon
        color = iconData.color
        backgroundImage = iconData.bg
    }
    
    // Asignar iconos, colores y fondo
    function getIconData(weatherCode) {
        var code = parseInt(weatherCode)
        
        // Sun/Clear
        if (code === 113) return {icon: "󰖨", color: ThemeManager.colors.peach, bg: "sun.png"}
        
        // Cloudy/Partly Cloudy
        if ([116, 119, 122].includes(code)) return {icon: "", color: ThemeManager.colors.subtext0, bg: "cloudy.png"}
        
        // Fog/Mist
        if ([143, 248, 260].includes(code)) return {icon: "", color: ThemeManager.colors.subtext0, bg: "wind.png"}
        
        // Rain
        if ([176, 263, 266, 281, 284, 293, 296, 299, 302, 305, 308, 311, 314, 317, 350, 353, 356, 359, 362, 365].includes(code)) 
            return {icon: "", color: ThemeManager.colors.teal, bg: "rain.png"}
            
        // Snow
        if ([227, 230, 323, 326, 329, 332, 335, 338, 368, 371, 374, 377, 392, 395].includes(code))
            return {icon: "", color: ThemeManager.colors.subtext0, bg: "snow.png"}
            
        // Thunder
        if ([200, 386, 389].includes(code)) return {icon: "", color: ThemeManager.colors.yellow, bg: "storm.png"}
        
        return {icon: "?", color: ThemeManager.colors.red, bg: "rain.png"}
    }
    
    function setErrorState() {
        temperature = "N/A"
        description = "Error en API"
        location = "Unknown"
        windSpeed = "0 m/s"
        humidity = "0%"
        icon = "?"
        color = ThemeManager.colors.red
        backgroundImage = "rain.png"
    }
    
    function capitalizeFirst(str) {
        return str.charAt(0).toUpperCase() + str.slice(1)
    }
    
    function refresh() {
        fetchLocation()
    }
}