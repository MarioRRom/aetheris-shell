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
pragma Singleton
import QtQuick

// Config
import qs.themes
import qs.i18n

QtObject {
    id: weatherManager


    //  .-------------------------.
    //  | .---------------------. |
    //  | |    Configuration    | |
    //  | `---------------------' |
    //  `-------------------------'

    property string units: "metric"

    // Climate data
    property string temperature: LanguageManager.t("weather.na")
    property string description: LanguageManager.t("weather.loading")
    property string location: LanguageManager.t("weather.unknown")
    property string windSpeed: "0 m/s"
    property string humidity: "0%"
    property string icon: "weather/cloudy"
    property string color: "#F28FAD"
    property string backgroundImage: "rain.png"

    // Lifecycle (15 minutes)
    property Timer updateTimer: Timer {
        interval: 900000
        running: true
        repeat: true
        onTriggered: fetchLocation()
    }

    Component.onCompleted: {
        fetchLocation()
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |   Weather Service   | |
    //  | `---------------------' |
    //  `-------------------------'

    // Get location for more Precision
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

    // Get weather from wttr.in
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


    //  .-------------------------.
    //  | .---------------------. |
    //  | |   Data Processing   | |
    //  | `---------------------' |
    //  `-------------------------'

    function processWeatherData(data, cityName) {
        var current = data.current_condition[0]
        var astronomy = data.weather[0].astronomy[0]

        var temp = units === "metric" ? current.temp_C : current.temp_F
        var wind = units === "metric" ? current.windspeedKmph : current.windspeedMiles
        var hum = current.humidity
        var desc = current.weatherDesc[0].value
        var code = current.weatherCode

        // Calculate if it's day or night
        var now = new Date()
        var currentMins = now.getHours() * 60 + now.getMinutes()
        var isDay = currentMins >= parseTime(astronomy.sunrise) && currentMins < parseTime(astronomy.sunset)

        var iconData = getIconData(code, isDay)
        var tempUnit = units === "metric" ? "°C" : "°F"
        var windUnit = units === "metric" ? " Km/h" : " mph"

        temperature = temp + tempUnit
        description = capitalizeFirst(desc)
        location = cityName
        windSpeed = wind + windUnit
        humidity = hum + "%"
        icon = iconData.icon
        color = iconData.color
        backgroundImage = iconData.bg
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |   Visual Settings   | |
    //  | `---------------------' |
    //  `-------------------------'

    function getIconData(weatherCode, isDay) {
        var code = parseInt(weatherCode)

        // Clear
        if (code === 113) {
            return {
                icon: isDay ? "weather/sun" : "weather/moon",
                color: isDay ? ThemeManager.colors.peach : ThemeManager.colors.blue,
                bg: isDay ? "sun.png" : "moon.png"
            }
        }

        // Partly Cloudy
        if (code === 116) {
            return {
                icon: isDay ? "weather/partly-cloudy-day" : "weather/partly-cloudy-night",
                color: isDay ? ThemeManager.colors.peach : ThemeManager.colors.blue,
                bg: isDay ? "sun.png" : "moon.png"
            }
        }

        // Cloudy
        if ([119, 122].includes(code)) {
            return {
                icon: "weather/cloudy",
                color: ThemeManager.colors.subtext0,
                bg: "cloudy.png"
            }
        }

        // Fog // Mist
        if ([143, 248, 260].includes(code)) {
            return {
                icon: "weather/foggy",
                color: ThemeManager.colors.overlay2,
                bg: "wind.png"
            }
        }

        // Drizzle // Rain light
        if ([263, 266, 293, 296, 353].includes(code)) {
            return {
                icon: "weather/rainy",
                color: ThemeManager.colors.sky,
                bg: isDay ? "rain.png" : "nightrain.png"
            }
        }

        // Heavy Rain
        if ([299, 302, 305, 308, 356, 359].includes(code)) {
            return {
                icon: "weather/rainy",
                color: ThemeManager.colors.blue,
                bg: isDay ? "rain.png" : "nightrain.png"
            }
        }

        // Freezing Rain
        if ([281, 284, 311, 314].includes(code)) {
            return {
                icon: "weather/snowy",
                color: ThemeManager.colors.sky,
                bg: "snow.png"
            }
        }

        // Sleet // Ice
        if ([179, 182, 185, 317, 320, 350, 362, 365, 374, 377].includes(code)) {
            return {
                icon: "weather/snowy",
                color: ThemeManager.colors.sky,
                bg: "snow.png"
            }
        }

        // Snow
        if ([227, 230, 323, 326, 329, 332, 335, 338, 368, 371].includes(code)) {
            return {
                icon: "weather/snowy",
                color: ThemeManager.colors.subtext0,
                bg: "snow.png"
            }
        }

        // Thunder
        if ([200, 386, 389, 392, 395].includes(code)) {
            return {
                icon: "weather/thunderstorm",
                color: ThemeManager.colors.yellow,
                bg: "storm.png"
            }
        }

        // Unknown
        return {
            icon: "weather/cloudy",
            color: ThemeManager.colors.red,
            bg: "rain.png"
        }
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |      Utilities      | |
    //  | `---------------------' |
    //  `-------------------------'

    function setErrorState() {
        temperature = LanguageManager.t("weather.na")
        description = LanguageManager.t("weather.apiError")
        location = LanguageManager.t("weather.unknown")
        windSpeed = "0 m/s"
        humidity = "0%"
        icon = "weather/cloudy"
        color = ThemeManager.colors.red
        backgroundImage = "rain.png"
    }

    function parseTime(timeStr) {
        const match = timeStr.match(/(\d+):(\d+)\s+(AM|PM)/)
        if (!match) return 0

        let [, h, m, period] = match

        h = Number(h)
        m = Number(m)

        if (period === "PM" && h !== 12) h += 12
        if (period === "AM" && h === 12) h = 0

        return h * 60 + m
    }

    function capitalizeFirst(str) {
        return str.charAt(0).toUpperCase() + str.slice(1)
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |      Public API     | |
    //  | `---------------------' |
    //  `-------------------------'

    function refresh() {
        fetchLocation()
    }
}