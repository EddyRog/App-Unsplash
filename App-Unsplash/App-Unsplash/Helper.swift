//
// Helper.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import Foundation
import UIKit

struct Helper {
    static func makePicture(with url: String) -> Data {
        let defaultData = UIImage(named: Constant.SearchPhoto.defaultImageName)?.pngData() ?? Data()
        guard let url = URL(string: url) else {
            return defaultData
        }
        let result = try? Data(contentsOf: url)
        return result ?? defaultData
    }
}
