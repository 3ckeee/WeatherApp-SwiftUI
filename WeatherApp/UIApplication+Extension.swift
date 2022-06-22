//
//  UIApplication+Extension.swift
//  WeatherApp
//
//  Created by Erik Kokinda on 23/06/2022.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


