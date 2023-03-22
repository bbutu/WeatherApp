//
//  WeatherInforamtionReusableView.swift
//  WeatherApp
//
//  Created by Beka Buturishvili on 02.03.23.
//

import UIKit

class WeatherInforamtionReusableView: UIView {
    
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .accentColor
        label.text = "75 %"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Cloudiness"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .accentColor
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(descriptionLabel)
        addSubview(informationLabel)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureConstraints() {
        let imageViewConstraints = [
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            imageView.heightAnchor.constraint(equalToConstant: bounds.height * 0.8),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ]
        
        let descriptionLabelConstraints = [
            descriptionLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
        ]
        
        let informationLabelConstraints = [
            informationLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            informationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
        NSLayoutConstraint.activate(informationLabelConstraints)
    }
    
    public func configure(systemName: String, descriptionText: String, informationText: String ) {
        self.imageView.image = UIImage(systemName: systemName)
        self.descriptionLabel.text = descriptionText
        if(descriptionText == "Cloudiness") {
            self.informationLabel.text = informationText + " %"
        }else if (descriptionText == "Humidity") {
            self.informationLabel.text = informationText + " mm"
        }else if (descriptionText == "Wind Speed") {
            self.informationLabel.text = informationText + " km/h"
        }else if (descriptionText == "Wind Direction") {
            self.informationLabel.text = informationText
        }
    }
    
}
