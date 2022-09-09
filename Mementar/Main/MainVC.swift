//
//  MainVC.swift
//  Mementar
//
//  Created by d3pr3ss3r on 09.09.2022.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func createQuest() {
        
        let storyboard = UIStoryboard(name: "CreateQuestVC", bundle: nil)
        let createQuestVC = storyboard.instantiateInitialViewController()
        createQuestVC?.modalPresentationStyle = .fullScreen
        present(createQuestVC!, animated: true)
    }
}
