//
//  VCTutorial.swift
//  getz
//
//  Created by admin on 21/09/2017.
//  Copyright © 2017 Zeppelin Group. All rights reserved.
//
// VC в котором происходит лаусч приложения. В случае первого запуска приложения человеку показывается туториал что это все такое, в обратном случае переводит его в начало приложения
import UIKit
import paper_onboarding
import Locksmith


class WelcomePageController: UIViewController, UIScrollViewDelegate,UIApplicationDelegate, PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    @IBOutlet weak var getStartButton: UIButton!
    @IBOutlet weak var onboarding: PaperOnboarding!
    @IBAction func startPressed(_ sender: Any) {

        self.performSegue(withIdentifier: "go", sender: self)
        let userDefaults = UserDefaults.standard
        
        
        
        userDefaults.synchronize()
    }
    
    override func viewDidLoad()
    {
        onboarding.dataSource = self
        onboarding.delegate = self
        getStartButton.layer.cornerRadius = 5
        self.getStartButton.alpha = 0
        
        do{
            try Locksmith.deleteDataForUserAccount(userAccount: "loginLast")
        }catch{
            print("cant delete")
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let backgroundColorOne = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)
        let backgroundColorTwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1)
        let backgroundColorThree = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1)
        let backgroundColorFour = UIColor(red: 255/255, green: 162/255, blue: 0/255, alpha: 1)
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descirptionFont = UIFont(name: "AvenirNext-Regular", size: 15)!
        
        return [("Obj", "Удобность", "Теперь портал в мобильном \n приложений ", "", backgroundColorOne, UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                ("Obj2", "Почта", "Вдобавок для удобства отдельная вкладка \n для почты", "", backgroundColorTwo, UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                ("Obj3", "Защищенность", "Аутентитификация при каждой сессии", "", backgroundColorThree, UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                ("Obj4", "Плати в одно нажатие", "", "", backgroundColorFour, UIColor.white, UIColor.white, titleFont, descirptionFont)][index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
                if index == 1{
                    if self.getStartButton.alpha == 1{
                        UIView.animate(withDuration: 0.2, animations: {
                            self.getStartButton.alpha = 0
                        })
                    }
                }
    }
    func onboardingDidTransitonToIndex(_ index: Int) {
                if index == 2{
                    UIView.animate(withDuration: 0.4) {
                        self.getStartButton.alpha = 1
                    }
                }
    }
    
    
}
