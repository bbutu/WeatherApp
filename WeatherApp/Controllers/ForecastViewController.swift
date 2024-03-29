//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Beka Buturishvili on 14.02.23.
//

import UIKit

enum WeekDay: String {
    case first      = "Sunday"
    case second     = "Monday"
    case third      = "Tuesday"
    case fourth     = "Wednesday"
    case fifth      = "Thursday"
    case sixth      = "Friday"
    case seventh    = "Saturday"
}

struct WeekDaysAndNumberOfWeather {
    var weekday: String
    var weatherNumber: Int
}

class ForecastViewController: UIViewController {
    private var lat = ""
    private var lon = ""
    
    private var fiveDayForecastData: CityFiveDayWeather = CityFiveDayWeather()
    private var weekdaysAndDifferentTimeForecastMap: [WeekDaysAndNumberOfWeather] = []
    
    private let forecastTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifier)
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {[weak self] in
            self?.getFiveDayWeatherAndReloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blueBackgroundColor
        tabBarController?.tabBar.backgroundColor = .blueBackgroundColor
        configureNavBar()
        view.addSubview(forecastTable)
        forecastTable.delegate = self
        forecastTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        forecastTable.frame = view.bounds
    }
    
    func clearData() {
        if(fiveDayForecastData.list?.count != 0 && weekdaysAndDifferentTimeForecastMap.count != 0) {
            fiveDayForecastData.list?.removeAll()
            weekdaysAndDifferentTimeForecastMap.removeAll()
        }
    }
    
    private func configureNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(didTapRefreshButton))
        navigationItem.leftBarButtonItem?.tintColor = .accentColor
        title = "Forecast"
    }
    
    @objc private func didTapRefreshButton() {
        
    }
    
    private func getFiveDayWeatherAndReloadData() {
        APICaller.shared.getFiveDaysWeather(latitude: lat, longitude: lon) { result in
            switch result {
            case .success(let fiveDayCityForecast):
                self.configureWeekDaysAndDifferentTimeForecastMap(fiveDayCityForecast: fiveDayCityForecast)
                DispatchQueue.main.async { [weak self] in
                    self?.forecastTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureWeekDaysAndDifferentTimeForecastMap(fiveDayCityForecast: CityFiveDayWeather) {
        self.fiveDayForecastData = fiveDayCityForecast
        for threeHoursWeather in fiveDayCityForecast.list! {
            let dateString = threeHoursWeather.dt_txt
            let weekDay = self.convertDateFormatToWeekday(dateString: dateString)
           addWeekDayAndWeatherNumber(weekDay: weekDay)
        }
    }
    
    private func addWeekDayAndWeatherNumber(weekDay: String) {
        if let index = weekdaysAndDifferentTimeForecastMap.firstIndex(where: { $0.weekday == weekDay }) {
            weekdaysAndDifferentTimeForecastMap[index].weatherNumber += 1
        } else {
            let newWeekDayAndWeatherNumber = WeekDaysAndNumberOfWeather(weekday: weekDay, weatherNumber: 0)
            weekdaysAndDifferentTimeForecastMap.append(newWeekDayAndWeatherNumber)
        }
    }
    
    private func convertDateFormatToWeekday(dateString: String) -> String {
        let dateString = dateString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)!

        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let weekdaySymbol = calendar.weekdaySymbols[weekday - 1]
        
        return weekdaySymbol
    }
    
    func configureWith(lat: String, lon: String) {
        self.lat = lat
        self.lon = lon
    }

}

extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(!weekdaysAndDifferentTimeForecastMap.isEmpty) {
            return weekdaysAndDifferentTimeForecastMap[section].weekday
        }
        return ""
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if(!weekdaysAndDifferentTimeForecastMap.isEmpty) {
            return weekdaysAndDifferentTimeForecastMap.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(!weekdaysAndDifferentTimeForecastMap.isEmpty) {
            return weekdaysAndDifferentTimeForecastMap[section].weatherNumber
        }
        return fiveDayForecastData.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as? ForecastTableViewCell else { return UITableViewCell()}
        cell.configure(with: fiveDayForecastData.list![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
 
