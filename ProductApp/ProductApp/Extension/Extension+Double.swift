//
//  Extension+Double.swift
//  ProductApp
//
//  Created by Lê Kim Hoàng on 30/3/26.
//

import Foundation

extension Double {
    var formattedCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let text = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return "$\(text)"
    }
}
