//
//  API.swift
//  CoronaApp
//
//  Created by 佐藤大樹 on 2022/03/24.
//

import UIKit

struct CovidAPI {
    static func getTotal(completion: @escaping (CovidInfo.Total) -> Void) {
        let url = URL(string: "https://covid19-japan-web-api.now.sh/api//v1/total")
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let result = try! JSONDecoder().decode(CovidInfo.Total.self, from: data)
                completion(result)
            }
        }.resume()
    }
    
    static func getPrefecture(completion: @escaping ([CovidInfo.Prefecture]) -> Void) {
        let url = URL(string: "https://covid19-japan-web-api.now.sh/api//v1/prefectures")
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let result = try! JSONDecoder().decode([CovidInfo.Prefecture].self, from: data)
                completion(result)
            }
        }.resume()
    }
}
