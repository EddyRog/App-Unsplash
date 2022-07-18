//
// Extension+Storyboard.swift
// App-Unsplash
// Created in 2022
// Swift 5.0


import UIKit

extension UIStoryboard {
    func isIDViewControllerExist(withIdentifier id: String) -> Bool {
        if let identifierList = self.value(forKey: "identifierToNibNameMap") as? [String: Any] {
            if identifierList[id] != nil {
                return true
            }
        }
        return false
    }
}

enum ErrorStoryboard: Error {
    case identifierNil
    case castingToSearchPhotosViewImpl
}
