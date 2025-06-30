//
//  String+AddText.swift
//  MyLocations
//
//  Created by Валерий Новиков on 30.06.25.
//

extension String {
  mutating func add(text: String?, separatedBy separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}
