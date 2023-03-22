//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Beka Buturishvili on 14.02.23.
//

import UIKit

class ForecastViewController: UIViewController {
    
    private let forecastTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.register(ForecastTableViewCell.self, forCellReuseIdentifier: ForecastTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blueBackgroundColor
        configureNavBar()
        view.addSubview(forecastTable)
        forecastTable.delegate = self
        forecastTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        forecastTable.frame = view.bounds
    }
    
    private func configureNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(didTapRefreshButton))
        navigationItem.leftBarButtonItem?.tintColor = .accentColor
        title = "Forecast"
    }
    
    @objc private func didTapRefreshButton() {
        
    }

}
extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastTableViewCell.identifier, for: indexPath) as? ForecastTableViewCell else { return UITableViewCell()}
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

}
 
