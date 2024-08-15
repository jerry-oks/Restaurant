//
//  Card.swift
//  Restaurant
//
//  Created by HOLY NADRUGANTIX on 21.08.2023.
//

import Foundation

struct Card {
    let firstFourNumbers: String
    let secondFourNumbers: String
    let thirdFourNumbers: String
    let fourthFourNumbers: String
    var cardNumber: String {
        firstFourNumbers + secondFourNumbers + thirdFourNumbers + fourthFourNumbers
    }
    
    let month: String
    let year: String
    
    let cardHolder: String
    
    let cvv: String
    
    var cardInfo: String {
        "*\(fourthFourNumbers), до \(month)/\(year), \(cardHolder)"
    }
}
