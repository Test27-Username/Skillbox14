
import UIKit

class ViewControllerWeather: UIViewController {

    @IBOutlet var labelTemp: UILabel!
    @IBOutlet var labelCity: UILabel!
    @IBOutlet var labelTime: UILabel!
    @IBOutlet var labelDesc: UILabel!
    @IBOutlet var labelWind: UILabel!
    @IBOutlet var labelOthers: UILabel!
    
    private let weatherLoader = WeatherLoader()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshView(RealmInstance.shared.getWeather())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshData()
    }

    @IBAction func refreshButton_TouchUpInside(_ sender: Any) {
        refreshData()
    }
    
    @IBAction func deleteButton_TouchUpInside(_ sender: Any) {
        RealmInstance.shared.setWeather(nil)
        refreshView(nil)
    }
    
    private func refreshData() {
        weatherLoader.loadCurrent(cityName: "moscow", completion: { weather in
            if let weather = weather {
                RealmInstance.shared.setWeather(weather)
                self.refreshView(weather)
            }
        })
    }
    
    private func refreshView(_ weather: WeatherData?) {
        if let weather = weather {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: weather.timezoneOffset)
            
            labelTemp.text = "\(weather.temp) ℃"
            labelCity.text = weather.cityName
            labelTime.text = "На данный момент: " + dateFormatter.string(from: weather.date!)
            labelDesc.text = weather.desc
            labelWind.text = "Ветер: \(weather.windName) \(weather.windSpeed) м/с"
            labelOthers.text = "Ощущается как: \(weather.tempFeelsLike) ℃\nМин.: \(weather.tempMin) ℃\nМакс.: \(weather.tempMax) ℃\nВлажность: \(weather.humidity)%"
        } else {
            labelTemp.text = "-- ℃"
            labelCity.text = "--"
            labelTime.text = "На данный момент: --"
            labelDesc.text = "--"
            labelWind.text = "Ветер: -- м/с"
            labelOthers.text = "Ощущается как: -- ℃\nМин.: -- ℃\nМакс.: -- ℃\nВлажность: --%"
        }
    }
}
