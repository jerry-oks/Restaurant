//
//  KitchenViewController.swift
//  Restaurant
//
//  Created by Alexey Efimov on 16.08.2023.
//

import UIKit

// Кухня
final class KitchenViewController: UIViewController {
    @IBOutlet private var suspicionLabel: UILabel!
    @IBOutlet private var completeOrderButton: UIButton!
    
    // Назначаем официанта, который должен будет забрать заказ
    unowned var delegate: KitchenViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if delegate.isCrime() {
            suspicionLabel.text = "Это вы в прошлый раз не оплатили заказ?"
            completeOrderButton.setTitle("Ой...", for: .normal)
            completeOrderButton.tintColor = .systemRed
        }

    }
    
    @IBAction private func completeOrderButtonPressed() {
        // Передача заказа официанту
        delegate.completeOrder()
        dismiss(animated: true)
    }
}
