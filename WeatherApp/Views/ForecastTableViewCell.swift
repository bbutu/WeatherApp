//
//  ForecastTableViewCell.swift
//  WeatherApp
//
//  Created by Beka Buturishvili on 14.02.23.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    static let identifier = "ForecastTableViewCell"
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .accentColor
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "-5°C"
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()
    
    private let weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.text = "Broken Clouds"
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.text = "01:00"
        return label
    }()
    
    private let forecastImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .blueBackgroundColor
        addSubViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addSubViews() {
        contentView.addSubview(forecastImageView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(weatherDescriptionLabel)
        contentView.addSubview(temperatureLabel)
    }
    
    private func configureConstraints() {
        let forecastImageViewConstraints = [
            forecastImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            forecastImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            forecastImageView.widthAnchor.constraint(equalToConstant: 50),
            forecastImageView.heightAnchor.constraint(equalTo: forecastImageView.widthAnchor)
        ]
        
        let stackViewConstraints = [
            stackView.leadingAnchor.constraint(equalTo: forecastImageView.trailingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            stackView.trailingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor, constant: -10)
        ]
        
        let temperatureLabelConstraints = [
            temperatureLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ]
        
        NSLayoutConstraint.activate(forecastImageViewConstraints)
        NSLayoutConstraint.activate(temperatureLabelConstraints)
        NSLayoutConstraint.activate(stackViewConstraints)
    }
    
}
