//
//  WeatherViewController.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 26.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, ScrollingViewDelegate {

	@IBOutlet weak var scrollView: ScrollingView!
	@IBOutlet weak var svLeftConstraint: NSLayoutConstraint!
	@IBOutlet weak var svRightConstraint: NSLayoutConstraint!

	@IBOutlet weak var weatherConstraint: NSLayoutConstraint!
	@IBOutlet weak var weatherSV: UIStackView!
	@IBOutlet weak var weatherImV: UIImageView!
	@IBOutlet weak var weatherLbl: StyledLabel!

	@IBOutlet weak var arrowView: ArrowView!

	@IBOutlet weak var infoConstraint: NSLayoutConstraint!
	@IBOutlet weak var infoSV: UIStackView!
	@IBOutlet weak var cloudsLbl: StyledLabel!
	@IBOutlet weak var rainLbl: StyledLabel!
	@IBOutlet weak var windLbl: StyledLabel!
	@IBOutlet weak var pressureLbl: StyledLabel!
	@IBOutlet weak var humidityLbl: StyledLabel!

	fileprivate var screenWidth: CGFloat!
	fileprivate var spacing: CGFloat!

	override func viewDidLoad() {
		super.viewDidLoad()

		setDelegates()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		initializeView()
		setViewWidth()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		scrollView.positionView()
	}

	func scrollingView(leftAlpha left: CGFloat, MoveWithRightAlpha right: CGFloat, arrow: CGFloat) {
		weatherSV.alpha = left
		infoSV.alpha = right
		arrowView.fraction = arrow
	}

	func reset() {
		defaultImage()
		weatherLbl.alpha = 0
		scrollView.reset()
	}

	func initWithWeather(_ weather: Weather) {
		weatherImV.image = weather.image
		weatherLbl.text = weather.mainDescription
		weatherLbl.alpha = 1

		cloudsLbl.text = weather.cloudsText
		rainLbl.text = weather.rainText
		windLbl.text = weather.windText
		pressureLbl.text = weather.pressureText
		humidityLbl.text = weather.humidityText
	}

	fileprivate func setViewWidth() {
		let viewWidth = screenWidth * 2 - spacing + 20

		view.frame = CGRect(x: 0, y: 0, width: viewWidth, height: 184)
	}

	fileprivate func defaultImage() {
		weatherImV.image = #imageLiteral(resourceName: "01d160")
	}

	fileprivate func initializeView() {
		infoSV.alpha = 0

		screenWidth = UIScreen.main.bounds.width
		spacing = (screenWidth - 160) / 2

		weatherConstraint.constant = spacing
		infoConstraint.constant = spacing
	}

	fileprivate func setDelegates() {
		scrollView.delegate = self
	}
}
