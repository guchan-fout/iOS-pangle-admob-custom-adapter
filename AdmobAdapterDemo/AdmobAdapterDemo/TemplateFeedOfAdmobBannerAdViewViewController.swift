//
//  TemplateBannerAdViewViewController.swift
//  AdmobAdapterDemo
//
//  Created by Chan Gu on 2020/09/03.
//  Copyright © 2020 GuChan. All rights reserved.
//

import UIKit
import MoPub

class TemplateFeedOfAdmobBannerAdViewViewController: UIViewController {
    
    var bannerView: GADBannerView!
    var bannerView2: GADBannerView!
    var bannerView3: GADBannerView!
    
    var mpAdView: MPAdView!
    
    let tableView = UITableView()
    
    var contents: [AnyObject] = [
        "sunday" as AnyObject, "monday" as AnyObject, "tuesday" as AnyObject, "wednesday" as AnyObject,
        "thursday" as AnyObject, "friday" as AnyObject, "saturday" as AnyObject,
        "sunday" as AnyObject, "monday" as AnyObject, "tuesday" as AnyObject, "wednesday" as AnyObject,
        "thursday" as AnyObject, "friday" as AnyObject, "saturday" as AnyObject,
        "sunday" as AnyObject, "monday" as AnyObject, "tuesday" as AnyObject, "wednesday" as AnyObject,
        "thursday" as AnyObject, "friday" as AnyObject, "saturday" as AnyObject,
    ]
    
    // This is the position in the table view that you want to show the ad
    let adPosition = 5

    @IBAction func onBackClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func loadView() {
        super.loadView()

        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Please make sure the size here is same on Pangle
        let adFrameSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 250))
        bannerView = GADBannerView(adSize: adFrameSize)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        createAnotherBanner()
        createAnotherBanner2()
    }
    
    func createAnotherBanner(){
        print("createAnotherBanner")
        let adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 250))
        bannerView2 = GADBannerView(adSize: adSize)
        bannerView2.adUnitID = "ca-app-pub-2748478898138855/7004935081"
        bannerView2.rootViewController = self
        bannerView2.delegate = self
        bannerView2.load(GADRequest())
    }
    
    func createAnotherBanner2(){
        print("createAnotherBanner")
        let adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 250))
        bannerView2 = GADBannerView(adSize: adSize)
        bannerView2.adUnitID = "ca-app-pub-2748478898138855/1383004943"
        bannerView2.rootViewController = self
        bannerView2.delegate = self
        bannerView2.load(GADRequest())
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
        tableView.register(
            UINib(nibName: "AdContentCell", bundle: nil),
            forCellReuseIdentifier: "ContentCell"
        )
    }
}

extension TemplateFeedOfAdmobBannerAdViewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == adPosition) {
            guard let item = contents[indexPath.row] as? GADBannerView else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                let cellName = String(describing: contents[indexPath.row])
                cell.textLabel?.text = cellName
                return cell
            }
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "ContentCell",
                for: indexPath) as? AdContentCell else {
                return UITableViewCell.init()
            }
            
            cell.contentMode = .center
            cell.container.addSubview(item)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let cellName = String(describing: contents[indexPath.row])
            cell.textLabel?.text = cellName
            return cell
        }
    }
}

extension TemplateFeedOfAdmobBannerAdViewViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // ad
        if (indexPath.row == adPosition) {
            if(contents[indexPath.row] .isKind(of: GADBannerView.self)) {
                return 250
            }
        }
        return 50
    }
}

extension TemplateFeedOfAdmobBannerAdViewViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        
        // Insert the ad to table view's datasource and reload
        contents.insert(bannerView, at: adPosition)
        self.tableView.reloadData()
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
        self.contents.remove(at: adPosition)
        self.tableView.reloadData()
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
        
}



