//
//  DestroyViewController.swift
//  Restaurant
//
//  Created by HOLY NADRUGANTIX on 20.08.2023.
//

import UIKit

final class DestroyViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        crash()
    }
    
    private func crash() {
        sleep(3)
        fatalError()
    }
}
