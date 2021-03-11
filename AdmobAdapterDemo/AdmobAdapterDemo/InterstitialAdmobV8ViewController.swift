//
//  InterstitialAdmobV8ViewController.swift
//  AdmobAdapterDemo
//
//  Created by Chan Gu on 2021/02/10.
//  Copyright © 2021 GuChan. All rights reserved.
//

import UIKit

class InterstitialAdmobV8ViewController: UIViewController, GADFullScreenContentDelegate {
    
    var interstitial: GADInterstitialAd!
    
    @IBAction func onBackBtnClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onShowClicked(_ sender: UIButton) {
        showInterstitial()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-2748478898138855/9253482066",
                                   request: request,
                                   completionHandler: { (ad, error) in
                                    if let error = error {
                                        print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                        return
                                    }
                                    self.interstitial = ad
                                    self.interstitial.fullScreenContentDelegate = self
                                    

                                   })
    }
    
    
    func showInterstitial() {
        if let ad = self.interstitial {
        ad.present(fromRootViewController: self)
      } else {
        print("Ad wasn't ready")
      }
    }
    
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did present full screen content.")
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("Ad failed to present full screen content with error \(error.localizedDescription).")
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did dismiss full screen content.")
    }
}
