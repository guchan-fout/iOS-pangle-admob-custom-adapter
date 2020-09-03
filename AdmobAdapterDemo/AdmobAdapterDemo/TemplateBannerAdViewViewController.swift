//
//  TemplateBannerAdViewViewController.swift
//  AdmobAdapterDemo
//
//  Created by Chan Gu on 2020/09/03.
//  Copyright © 2020 GuChan. All rights reserved.
//

import UIKit

class TemplateBannerAdViewViewController: UIViewController {
    
    var bannerView: GADBannerView!
    
    let tableView = UITableView()
    
    let a = BUDAdmob_TemplateNativeFeedCustomEventAdapter.init()
    
    let contents = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday","sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday","sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday" ]
    
    let adPositon = 5

    @IBAction func onBackClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func loadView() {
        super.loadView()
        
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 250))
        bannerView = GADBannerView(adSize: adSize)
        bannerView.adUnitID = "ca-app-pub-2748478898138855/1197230743"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        
        tableView.register(
            UINib(nibName: "AdContentCell", bundle: nil),
            forCellReuseIdentifier: "ContentCell"
        )
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor,constant: 80.0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension TemplateBannerAdViewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if (indexPath.row == adPositon) {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "ContentCell",
                for: indexPath) as? AdContentCell else {
                return UITableViewCell.init()
            }
            
            cell.contentMode = .center
            cell.container.addSubview(bannerView)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = contents[indexPath.row]
            return cell
        }
    }
}

extension TemplateBannerAdViewViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // ad
        if (indexPath.row == adPositon) {
            return 250
        }
        return 50
    }
}

extension TemplateBannerAdViewViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("adViewDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
        let indexPath = IndexPath(item: adPositon, section: 0)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

