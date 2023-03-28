//
//  AddCityPopUpView.swift
//  WeatherApp
//
//  Created by Beka Buturishvili on 10.03.23.
//

import UIKit

class AddCityPopUpView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        return stackView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let plusSign = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22,weight: .bold))
        button.setImage(plusSign, for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemGreen
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        return button
    }()
    
    private let enterCityTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.textColor = .black
        return textField
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = "Enter City name you wish to add"
        label.textColor = .white
        return label
    }()
    
    private let addCityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "Add City"
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGreen
        addSubview(stackView)
        stackView.addArrangedSubview(addCityLabel)
        stackView.addArrangedSubview(instructionLabel)
        stackView.addArrangedSubview(enterCityTextField)
        stackView.addArrangedSubview(addButton)
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        configureConstraints()
    }
    
    @objc private func didTapAddButton() {
        guard let todayViewController = self.firstViewController as? TodayViewController else {return}
        let cityName = enterCityTextField.text ?? ""
        addIndicatorViewToButton(viewController: todayViewController, cityName: cityName)
        todayViewController.animateOut()
    }
    
    private func addIndicatorViewToButton(viewController: TodayViewController, cityName: String) {
        prepareViewForLoadingInformation()
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        ConfigureActivityIndicatorViewConstraints(activityIndicatorView: activityIndicatorView)
        activityIndicatorView.startAnimating()
        viewController.updateDataWithCityName(cityName: cityName)
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
        returnViewToTheStartingStage()
    }
    
    private func returnViewToTheStartingStage() {
        enterCityTextField.text = ""
        let plusSign = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22,weight: .bold))
        addButton.setImage(plusSign, for: .normal)
        addButton.isEnabled = true
    }
    
    private func prepareViewForLoadingInformation() {
        addButton.isEnabled = false
        addButton.setImage(nil, for: .normal)
    }
    
    private func ConfigureActivityIndicatorViewConstraints(activityIndicatorView: UIActivityIndicatorView) {
        activityIndicatorView.color = .systemGreen
        addButton.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: addButton.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: addButton.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureConstraints() {
        let enterCityTextFieldConstraints = [
            enterCityTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor,constant: 20),
            enterCityTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor,constant: -20),
        ]
        
        let addButtonConstraints = [
            addButton.widthAnchor.constraint(equalToConstant: 44),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor)
        ]
        
        let stackViewConstraints = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ]
        
        NSLayoutConstraint.activate(enterCityTextFieldConstraints)
        NSLayoutConstraint.activate(addButtonConstraints)
        NSLayoutConstraint.activate(stackViewConstraints)
    }

}

fileprivate extension UIView {

  var firstViewController: UIViewController? {
    let firstViewController = sequence(first: self, next: { $0.next }).first(where: { $0 is UIViewController })
    return firstViewController as? UIViewController
  }

}
