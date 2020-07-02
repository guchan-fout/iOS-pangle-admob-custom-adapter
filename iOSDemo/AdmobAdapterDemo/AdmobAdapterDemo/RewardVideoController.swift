//
//  RewardVideoController.swift
//  AdmobAdapterDemo
//
//  Created by Gu Chan on 2020/07/01.
//  Copyright © 2020 GuChan. All rights reserved.
//

import UIKit

class RewardVideoController: UIViewController, GADRewardedAdDelegate {

    var rewardedAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-2748478898138855/2704625864")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        rewardedAd?.load(GADRequest()) { error in
          if let error = error {
            print("Loading failed: \(error)")
          } else {
            print("Loading Succeeded")
            if self.rewardedAd?.isReady == true {
                self.rewardedAd?.present(fromRootViewController: self, delegate:self)
             }
          }
        }
    }

    @IBAction func onBackClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onLoadClick(_ sender: Any) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.rewardedAd = nil
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }
    
}
