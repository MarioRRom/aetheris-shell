// modules/WeatherManager.qml
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: weatherManager
    
    // Configuración de API
    property string apiKey: "b412dae84b266e46cbc31c1d476f03a7"
    property string cityId: "3841956" 
    property string units: "metric"
    
    // Datos del clima
    property string temperature: "N/A"
    property string description: "Cargando..."
    property string location: ""
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
        onTriggered: fetchWeather()
    }
    
    Component.onCompleted: {
        fetchWeather()
    }
    
    function fetchWeather() {
        if (!apiKey || !cityId) {
            console.log("Weather: API key o City ID no configurados")
            return
        }
        
        var url = "http://api.openweathermap.org/data/2.5/weather?id=" + cityId + "&units=" + units + "&appid=" + apiKey
        
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    try {
                        var data = JSON.parse(xhr.responseText)
                        processWeatherData(data)
                    } catch (e) {
                        console.log("Weather: Error parsing JSON:", e)
                        setErrorState()
                    }
                } else {
                    console.log("Weather: HTTP Error:", xhr.status)
                    setErrorState()
                }
            }
        }
        
        xhr.open("GET", url)
        xhr.send()
    }
    
    function processWeatherData(data) {
        var temp = Math.round(data.main.temp)
        var iconCode = data.weather[0].icon
        var desc = data.weather[0].description
        var city = data.name
        var country = data.sys.country
        var wind = data.wind.speed
        var hum = data.main.humidity
        
        var iconData = getIconData(iconCode)
        var tempUnit = units === "metric" ? "°C" : (units === "imperial" ? "°F" : "")
        
        temperature = temp + tempUnit
        description = capitalizeFirst(desc)
        location = city + ", " + country
        windSpeed = wind + " m/s"
        humidity = hum + "%"
        icon = iconData.icon
        color = iconData.color
        backgroundImage = iconData.bg
    }
    
    function getIconData(iconCode) {
        switch (iconCode) {
            case "01d": return {icon: "󰖨", color: "#FAB387", bg: "sun.png"}
            case "01n": return {icon: "", color: "#89B4FA", bg: "moon.png"}
            case "02d":
            case "02n": return {icon: "󰅟", color: "#A6ADC8", bg: "cloudy.png"}
            case "03d":
            case "03n": return {icon: "", color: "#A6ADC8", bg: "cloudy.png"}
            case "04d":
            case "04n": return {icon: "", color: "#A6ADC8", bg: "cloudy.png"}
            case "09d": return {icon: "", color: "#94E2D5", bg: "rain.png"}
            case "09n": return {icon: "", color: "#94E2D5", bg: "nightrain.png"}
            case "10d": return {icon: "", color: "#74C7EC", bg: "rain.png"}
            case "10n": return {icon: "", color: "#74C7EC", bg: "nightrain.png"}
            case "11d":
            case "11n": return {icon: "", color: "#f9e2af", bg: "storm.png"}
            case "13d":
            case "13n": return {icon: "", color: "#FFFFFF", bg: "snow.png"}
            case "50d":
            case "50n": return {icon: "", color: "#C6D0F5", bg: "wind.png"}
            default: return {icon: "?", color: "#F28FAD", bg: "rain.png"}
        }
    }
    
    function setErrorState() {
        temperature = "N/A"
        description = "Error en API"
        location = "Unknown"
        windSpeed = "0 m/s"
        humidity = "0%"
        icon = "?"
        color = "#F28FAD"
        backgroundImage = "rain.png"
    }
    
    function capitalizeFirst(str) {
        return str.charAt(0).toUpperCase() + str.slice(1)
    }
    
    function refresh() {
        fetchWeather()
    }
}