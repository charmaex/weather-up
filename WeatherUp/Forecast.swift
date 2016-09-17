//
//  Forecast.swift
//  WeatherUp
//
//  Created by Jan Dammshäuser on 23.03.16.
//  Copyright © 2016 Jan Dammshäuser. All rights reserved.
//

import Foundation

class Forecast: NSObject, NSCoding, WeatherObject {

	let IMG_SIZE = "055"

	fileprivate var _date: Date!
	fileprivate var _img: String!
	fileprivate var _degrees: Double!

	var weekday: String {
		return saveWDay(_date)
	}

	var imageName: String {
		return saveImageName(_img)
	}

	var degreesDbl: Double {
		return _degrees
	}

	var degrees: String {
		return saveUnit(_degrees, type: .temperature, nilValue: .dash)
	}

	init(date: Date, img: String, degrees: Double) {
		_date = date
		_img = img
		_degrees = degrees
	}

	override init() {
		_date = DEF_DATE as Date!
		_img = DEF_IMG
		_degrees = DEF_VALUE
	}

	required convenience init?(coder aDecoder: NSCoder) {
		self.init()

		self._date = aDecoder.decodeObject(forKey: "date") as? Date
		self._img = aDecoder.decodeObject(forKey: "img") as? String
		self._degrees = aDecoder.decodeObject(forKey: "degrees") as? Double
	}

	func encode(with aCoder: NSCoder) {
		aCoder.encode(self._date, forKey: "date")
		aCoder.encode(self._img, forKey: "img")
		aCoder.encode(self._degrees, forKey: "degrees")
	}
}
