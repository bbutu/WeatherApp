//
//  TodayCollectionViewCell.swift
//  WeatherApp
//
//  Created by Beka Buturishvili on 02.03.23.
//

import UIKit
import SDWebImage
import SDWebImageMapKit

class TodayCollectionViewCell: UICollectionViewCell {
    static let identifier = "TodayCollectionViewCell"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    
    private let windDirectionView: WeatherInforamtionReusableView = {
        let view = WeatherInforamtionReusableView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        view.backgroundColor = .cyan
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let windSpeedView: WeatherInforamtionReusableView = {
        let view = WeatherInforamtionReusableView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        view.backgroundColor = .cyan
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let humidityView: WeatherInforamtionReusableView = {
        let view = WeatherInforamtionReusableView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        view.backgroundColor = .cyan
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cloudinessView: WeatherInforamtionReusableView = {
        let view = WeatherInforamtionReusableView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        view.backgroundColor = .cyan
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .accentColor
        label.text = "-2ºC | Misty"
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    private let cityAndCountryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Tbilisi, Georgia"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cyan
        layer.cornerRadius = 30
        addSubviews()
        addShadows()
        addGradient()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = 30
        gradientLayer.opacity = 0.25
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.blueBackgroundColor.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    private func addShadows() {
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.4
        self.layer.shadowPath = nil
    }
    
    private func addSubviews() {
        addSubview(weatherImageView)
        addSubview(cityAndCountryLabel)
        addSubview(temperatureLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(cloudinessView)
        stackView.addArrangedSubview(humidityView)
        stackView.addArrangedSubview(windSpeedView)
        stackView.addArrangedSubview(windDirectionView)
    }
    
    private func configureConstraints() {
        let weatherImageViewConstraints = [
            weatherImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            weatherImageView.widthAnchor.constraint(equalToConstant: bounds.width * 0.3),
            weatherImageView.heightAnchor.constraint(equalTo: weatherImageView.widthAnchor)
        ]
        
        let cityAndCountryLabelConstraints = [
            cityAndCountryLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cityAndCountryLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 10)
        ]
        
        let temperatureLabelConstraints = [
            temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: cityAndCountryLabel.bottomAnchor, constant: 10)
        ]
        
        let stackViewConstraints = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: centerYAnchor, constant: 40),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
        ]
        
        NSLayoutConstraint.activate(weatherImageViewConstraints)
        NSLayoutConstraint.activate(cityAndCountryLabelConstraints)
        NSLayoutConstraint.activate(temperatureLabelConstraints)
        NSLayoutConstraint.activate(stackViewConstraints)
    }
    
    public func configure(with city: City) {
        let imagePath = APICaller.shared.getWeatherIconUrl(with: city.weather[0].icon)
        guard let url = URL(string: imagePath) else {return}
        self.weatherImageView.sd_setImage(with: url, completed: nil)
        self.cityAndCountryLabel.text = city.name + ", " + city.sys.country
        self.temperatureLabel.text = String(Int(city.main.temp)) + "ºC | " + city.weather[0].main!
        self.cloudinessView.configure(systemName: "cloud.rain", descriptionText: "Cloudiness", informationText: String(city.clouds.all))
        self.humidityView.configure(systemName: "drop", descriptionText: "Humidity", informationText: String(city.main.humidity))
        self.windSpeedView.configure(systemName: "wind", descriptionText: "Wind Speed", informationText: String(city.wind.speed))
        self.windDirectionView.configure(systemName: "arrow.up.right", descriptionText: "Wind Direction", informationText: String(city.wind.deg))
    }
}
