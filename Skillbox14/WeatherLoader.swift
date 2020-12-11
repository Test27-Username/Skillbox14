
import Foundation
import SVProgressHUD

let currentWeatherURL: String = "http://api.openweathermap.org/data/2.5/weather?appid=89ce343b4873970dd536441b1090e924&units=metric&lang=ru"
// example: http://api.openweathermap.org/data/2.5/weather?appid=89ce343b4873970dd536441b1090e924&units=metric&lang=ru&q=moscow


class WeatherLoader {
    
    func loadCurrent(cityName: String, completion: @escaping (WeatherData?) -> Void){
        let url = URL(string: currentWeatherURL + "&q=" + cityName)!
        let request = URLRequest(url: url)
        SVProgressHUD.show()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                guard
                    let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                    let jsonDict = json as? NSDictionary
                else {
                    completion(nil)
                    return
                }
                
                let jsonDictData = jsonDict as NSDictionary
                guard
                    let weatherData = jsonDictData["weather"] as? [NSDictionary],
                    let main = jsonDictData["main"] as? NSDictionary,
                    let wind = jsonDictData["wind"] as? NSDictionary
                else {
                    completion(nil)
                    return
                }

                guard
                    let date = jsonDictData["dt"] as? Int,
                    let timezoneOffset = jsonDictData["timezone"] as? Int,
                    let townName = jsonDictData["name"] as? String,
                    let desc = weatherData[0]["description"] as? String,
                    let temp = main["temp"] as? NSNumber,
                    let tempMin = main["temp_min"] as? NSNumber,
                    let tempMax = main["temp_max"] as? NSNumber,
                    let tempFeelsLike = main["feels_like"] as? NSNumber,
                    let humidity = main["humidity"] as? Int,
                    let windSpeed = wind["speed"] as? NSNumber,
                    let windDeg = wind["deg"] as? NSNumber
                else {
                    completion(nil)
                    return
                }
                
                let weather = WeatherData()
                
                weather.date = Date(timeIntervalSince1970: TimeInterval(date))
                weather.timezoneOffset = timezoneOffset
                weather.cityName = townName
                weather.desc = desc
                weather.temp = Int(Float(truncating: temp).rounded())
                weather.tempMin = Int(Float(truncating: tempMin).rounded())
                weather.tempMax = Int(Float(truncating: tempMax).rounded())
                weather.tempFeelsLike = Int(Float(truncating: tempFeelsLike).rounded())
                weather.humidity = humidity
                weather.windSpeed = Float(truncating: windSpeed)
                weather.windDeg = Float(truncating: windDeg)
                
                completion(weather)
            }
        }
        task.resume()
    }
}
