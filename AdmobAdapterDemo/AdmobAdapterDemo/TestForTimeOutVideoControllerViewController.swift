//
//  TestForTimeOutVideoControllerViewController.swift
//  AdmobAdapterDemo
//
//  Created by Chan Gu on 2020/09/24.
//  Copyright © 2020 GuChan. All rights reserved.
//

import UIKit

class TestForTimeOutVideoControllerViewController: UIViewController {
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    var bannerView: GADBannerView!
    let unit1 = "ca-app-pub-3940256099942544/2934735716"
    let unit2 = "ca-app-pub-2748478898138855/7004935081"
    //let unit3 = "ca-app-pub-2748478898138855/1383004943"
    
    var bannerView2: GADBannerView!
    var bannerView3: GADBannerView!
    
    var expressBanner: BUNativeExpressBannerView!
    var nativeExpressAdManager: BUNativeExpressAdManager!
    var expressAdViews: NSMutableArray!
    
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
    let adPosition1 = 1
    let adPosition2 = 2
    let adPosition3 = 3

    let adPosition10 = 10
    
    @IBAction func onBackClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func loadView() {
        super.loadView()
        
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTemplateNativeAd(placementID: "945446626")
        // Please make sure the size here is same on Pangle
        let adFrameSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 50))
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = unit1
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        createAnotherBanner()
    }
    
    func createAnotherBanner(){
        print("createAnotherBanner")
        let adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 250))
        bannerView2 = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView2.adUnitID = unit2
        bannerView2.rootViewController = self
        bannerView2.delegate = self
        bannerView2.load(GADRequest())
    }

    
    func getTemplateNativeAd(placementID: String) {
        let ad_count = 1
        if((self.expressAdViews == nil)) {
            self.expressAdViews = NSMutableArray.init(capacity: ad_count)
        }
        let slot = BUAdSlot.init()
        slot.id = placementID
        slot.adType = BUAdSlotAdType.feed
        slot.imgSize = BUSize.init(by: BUProposalSize.feed228_150)
        slot.position = BUAdSlotPosition.feed
        slot.isSupportDeepLink = true
        
        nativeExpressAdManager = BUNativeExpressAdManager.init(slot: slot, adSize: CGSize.init(width: 300, height: 250))
        
        nativeExpressAdManager.delegate = self
        nativeExpressAdManager.loadAd(ad_count)
        
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

extension TestForTimeOutVideoControllerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = contents[indexPath.row]
        
        if ((obj.isKind(of: BUNativeExpressAdView.self))) {
            print("This is a pangle ad")
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "ContentCell",
                    for: indexPath) as? AdContentCell else {
                return UITableViewCell.init()
            }
            
            cell.contentMode = .center
            cell.container.addSubview(obj as! BUNativeExpressAdView)
            cell.container.backgroundColor = UIColor.white
            return cell
        }
        
        if ((obj.isKind(of: GADBannerView.self))) {
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "ContentCell",
                    for: indexPath) as? AdContentCell else {
                return UITableViewCell.init()
            }
            
            cell.contentMode = .center
            cell.container.addSubview(obj as! UIView)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let cellName = String(describing: contents[indexPath.row])
            cell.textLabel?.text = cellName
            return cell
        }
    }
}

extension TestForTimeOutVideoControllerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // ad
        let obj = contents[indexPath.row]
        if (obj.isKind(of: GADBannerView.self)){
            return 70
        }
        if (obj.isKind(of: BUNativeExpressAdView.self)) {
            return 250
        }
        return 50
    }
}

extension TestForTimeOutVideoControllerViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        
        // Insert the ad to table view's datasource and reload
        if (bannerView.adUnitID == unit1) {
            contents.insert(bannerView, at: adPosition1)
        }
        if (bannerView.adUnitID == unit2) {
            contents.insert(bannerView, at: adPosition2)
        }
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
        self.contents.remove(at: adPosition1)
        self.tableView.reloadData()
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension TestForTimeOutVideoControllerViewController: BUNativeExpressAdViewDelegate {
    func nativeExpressAdViewWillShow(_ nativeExpressAdView: BUNativeExpressAdView) {
        
    }
    
    func nativeExpressAdViewDidClick(_ nativeExpressAdView: BUNativeExpressAdView) {
        
    }
    
    func nativeExpressAdViewRenderSuccess(_ nativeExpressAdView: BUNativeExpressAdView) {
        
        print("\(#function):")
        let obj = contents[adPosition10]
        if (!obj.isKind(of: BUNativeExpressAdView.self)){
            contents.insert(nativeExpressAdView, at: adPosition10+2)
        }
        self.tableView.reloadData()
        
    }
    
    func nativeExpressAdFail(toLoad nativeExpressAd: BUNativeExpressAdManager, error: Error?) {
        
        print("\(#function):" + error.debugDescription)
    }

    func nativeExpressAdViewRenderFail(_ nativeExpressAdView: BUNativeExpressAdView, error: Error?) {
        print("\(#function):" + error.debugDescription)
        
    }

    func nativeExpressAdSuccess(toLoad nativeExpressAd: BUNativeExpressAdManager, views: [BUNativeExpressAdView]) {
        print("\(#function):")
        
        expressAdViews.removeAllObjects()
        
        if (views.count != 0) {
            expressAdViews.addObjects(from: views)
            for (_, value) in views.enumerated() {
                let expressView = value
                expressView.rootViewController = self
                expressView.render()
            }
        }
    }
}





