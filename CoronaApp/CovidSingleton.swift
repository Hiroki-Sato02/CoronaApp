//
//  CovidSingleton.swift
//  CoronaApp
//
//  Created by 佐藤大樹 on 2022/03/24.
//

import Foundation

class CovidSingleton {
    private init() {}
    static let shared = CovidSingleton()
    var prefecuture:[CovidInfo.Prefecture] = []
}
