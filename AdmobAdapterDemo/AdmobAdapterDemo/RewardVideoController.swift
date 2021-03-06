//
//  RewardVideoController.swift
//  AdmobAdapterDemo
//
//  Created by Gu Chan on 2020/07/01.
//  Copyright © 2020 GuChan. All rights reserved.
//

import UIKit

class RewardVideoController: UIViewController, GADFullScreenContentDelegate {
    
    var rewardedAd: GADRewardedAd?
    
    
    @IBAction func onBackBtnClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onLoadClicked(_ sender: UIButton) {
        showRewardedAd()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-2748478898138855/2704625864", request: request, completionHandler: { (ad, error) in
            if let error = error {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                
                return
            }
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
        })
    }
    
    func showRewardedAd() {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: self,
                       userDidEarnRewardHandler: {
                        // TODO: Reward the user.
                        //let reward = ad.adReward
                       })
        } else {
            print("Ad wasn't ready")
        }
    }
    
    
    /// Tells the delegate that the rewarded ad was presented.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad presented.")
    }
    /// Tells the delegate that the rewarded ad was dismissed.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad dismissed.")
    }
    /// Tells the delegate that the rewarded ad failed to present.
    func ad(_ ad: GADFullScreenPresentingAd,
            didFailToPresentFullScreenContentWithError error: Error) {
        print("Rewarded ad failed to present with error: \(error.localizedDescription).")
    }
    
}
