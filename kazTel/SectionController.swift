//
//  SectionController.swift
//  kazTel
//
//  Created by Нурлан on 28.06.2018.
//  Copyright © 2018 Нурлан. All rights reserved.
//

import UIKit
import CoreData
import EasyPeasy

class SectionController: UIViewController {
    @IBOutlet weak var adresField: UITextField!
//    @IBOutlet weak var invalidLabel: UILabel!
    
    lazy var promptLabel: UILabel = {
       let label = UILabel()
        label.text = "Неправильный адрес"
        label.font = label.font.withSize(13)
        label.textColor = .red
        return label
    }()
    
    let userDefaults_section = UserDefaults.standard
    
    let closure = UserDefaults.argumentDomain
    
    
   
    
    
    @IBAction func savePressed(_ sender: Any) {
        guard let adres = adresField.text else { return }
        if adres.contains("https") || adres.contains("http"){
            userDefaults_section.set(adres, forKey: "section")
        } else {
            userDefaults_section.set("https://\(adres)", forKey: "section")
        }
        userDefaults_section.synchronize()
        userDefaults_section.set(true, forKey: "onboardingComplete")
        self.performSegue(withIdentifier: "show", sender: self)
        
    
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(promptLabel)
        hideKeyboardWhenTappedAround()
        promptLabel.isHidden = true
        promptLabel.easy.layout(
            CenterX(),
            Top(70).to(adresField, .bottom)
        )
        print("SectionVC opened")
        adresField.layer.masksToBounds = true
        adresField.layer.borderColor = UIColor.black.cgColor
        adresField.layer.borderWidth = 1
        adresField.layer.cornerRadius = 5

    }

 

}
