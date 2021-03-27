//
//  FSCartController.swift
//  Flower shop
//
//  Created by Eugene Hamitsevich on 3/22/21.
//

import UIKit

class FSCartController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Initialize
        let items = ["Purple", "Green", "Blue"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        // Set up Frame and SegmentedControl
        let frame = UIScreen.main.bounds
        customSC.frame = CGRect(x: frame.minX + 10, y: frame.minY + 50, width: frame.width - 20, height: frame.height*0.1)
        // Style the Segmented Control
        customSC.layer.cornerRadius = 5.0  // Don't let background bleed
        customSC.backgroundColor = .black
        customSC.tintColor = .white
        // Add target action method
        customSC.addTarget(self, action: #selector(self.changeColor(sender:)), for: .valueChanged)
        // Add this custom Segmented Control to our view
        self.view.addSubview(customSC)
    }
    @objc func changeColor(sender: UISegmentedControl) {
        print("Changing Color to ")
        switch sender.selectedSegmentIndex {
        case 1:
            self.view.backgroundColor = .green
            print("Green")
        case 2:
            self.view.backgroundColor = .blue
            print("Blue")
        default:
            self.view.backgroundColor = .purple
            print("Purple")
        }
    }
}
