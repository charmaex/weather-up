//
//  AppCoordinator.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 05.10.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import UIKit
import JDCoordinator

class AppCoordinator: JDCoordinator {

	override func start() {
		showMain()
	}

	// MARK: - Show Methods

	private func showMain() {
		let main = MainVC()

		setViewControllers(main, animated: false)
	}
}
