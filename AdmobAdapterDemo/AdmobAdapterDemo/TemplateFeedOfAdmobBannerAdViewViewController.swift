//
//  TemplateBannerAdViewViewController.swift
//  AdmobAdapterDemo
//
//  Created by Chan Gu on 2020/09/03.
//  Copyright © 2020 GuChan. All rights reserved.
//

import UIKit

class TemplateFeedOfAdmobBannerAdViewViewController: UIViewController {
    
    var bannerView: GADBannerView!
    
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
        bannerView.adUnitID = "ca-app-pub-2748478898138855/1197230743"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
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
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        
        // Insert the ad to table view's datasource and reload
        contents.insert(bannerView, at: adPosition)
        self.tableView.reloadData()
    }

    /// Tells the delegate an ad request failed.
    func bannerView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: Error) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
        self.bannerView .removeFromSuperview()
    }
}

