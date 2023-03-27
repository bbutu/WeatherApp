//
//  ErrorPopupView.swift
//  WeatherApp
//
//  Created by Beka Buturishvili on 27.03.23.
//

import UIKit

class ErrorPopupView: UIView {

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red.withAlphaComponent(0.95)
        view.layer.cornerRadius = 10
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(backgroundView)
        backgroundView.addSubview(messageLabel)

        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),

            messageLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 12),
            messageLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -12),
            messageLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -12)
        ])
    }

    func showMessage(_ message: String, inView view: UIView) {
        messageLabel.text = message
        view.addSubview(self)

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])

        alpha = 0
        transform = CGAffineTransform(translationX: 0, y: -frame.height)
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            self.alpha = 1
            self.transform = .identity
        }, completion: nil)
    }

    @objc func dismiss() {
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first?.location(in: self)
        if !backgroundView.frame.contains(location!) {
            dismiss()
        }
    }
}
