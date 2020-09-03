//
//  TemplateNativeFeedAdViewController.swift
//  AdmobAdapterDemo
//
//  Created by Chan Gu on 2020/08/28.
//  Copyright © 2020 GuChan. All rights reserved.
//

import UIKit

class TemplateNativeFeedAdViewController: UIViewController, GADVideoControllerDelegate {
    
    /// The ad loader. You must keep a strong reference to the GADAdLoader during the ad loading
    /// process.
    var adLoader: GADAdLoader!
    
    /// The native ad view that is being presented.
    var nativeAdView: GADUnifiedNativeAdView!
    
    /// The ad unit ID.
    //ca-app-pub-2748478898138855/6043806278
    let adUnitID = "ca-app-pub-2748478898138855/6043806278"
    
    /// The height constraint applied to the ad view, where necessary.
    var heightConstraint: NSLayoutConstraint?
    
    let tableView = UITableView()
    
    let contents = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday","sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday","sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday" ]
    
    let adPositon = 5
    
    @IBAction func onBtnClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func loadView() {
        super.loadView()
        
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        adLoader = GADAdLoader(
            adUnitID: adUnitID, rootViewController: self,
            adTypes: [.unifiedNative], options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
        
        
        guard
            let nibObjects = Bundle.main.loadNibNamed("UnifiedNativeAdView", owner: nil, options: nil),
            let adView = nibObjects.first as? GADUnifiedNativeAdView
            else {
                assert(false, "Could not load nib file for adView")
        }

        setAdView(adView)
        
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
    
    func setAdView(_ view: GADUnifiedNativeAdView) {
        // Remove the previous ad view.
        nativeAdView = view
        nativeAdView.isHidden = true
     
        self.view.addSubview(nativeAdView)
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        
        // Layout constraints for positioning the native ad view to stretch the entire width and height
        // of the nativeAdPlaceholder.
        let viewDictionary = ["_nativeAdView": nativeAdView!]
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[_nativeAdView]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        )
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[_nativeAdView]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
        )
    }
}


extension TemplateNativeFeedAdViewController: UITableViewDataSource {
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
   
            let adView = UIView(frame: cell.bounds)
            adView.contentMode = .scaleAspectFit

            adView.clipsToBounds = true
            adView.addSubview(nativeAdView)
            cell.container.addSubview(adView)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = contents[indexPath.row]
            return cell
        }
    }
}

extension TemplateNativeFeedAdViewController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 30
        return UITableView.automaticDimension
        /*
        // ad
        if (indexPath.row == adPositon) {
            return 250
        }
        return 50
 */
    }    
}


extension TemplateNativeFeedAdViewController: GADAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
        
    }
    
}

extension TemplateNativeFeedAdViewController: GADUnifiedNativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        nativeAdView.isHidden = false
        // Set ourselves as the native ad delegate to be notified of native ad events.
        nativeAd.delegate = self
        
        // Deactivate the height constraint that was set when the previous video ad loaded.
        heightConstraint?.isActive = false
        
        // Populate the native ad view with the native ad assets.
        // The headline and mediaContent are guaranteed to be present in every native ad.
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        
        // Some native ads will include a video asset, while others do not. Apps can use the
        // GADVideoController's hasVideoContent property to determine if one is present, and adjust their
        // UI accordingly.
        let mediaContent = nativeAd.mediaContent
        if mediaContent.hasVideoContent {
            // By acting as the delegate to the GADVideoController, this ViewController receives messages
            // about events in the video lifecycle.
            mediaContent.videoController.delegate = self
            
        } else {
            
        }
        
        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
        // ratio of the media it displays.
        if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
            heightConstraint = NSLayoutConstraint(
                item: mediaView,
                attribute: .height,
                relatedBy: .equal,
                toItem: mediaView,
                attribute: .width,
                multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
                constant: 0)
            heightConstraint?.isActive = true
        }
        
        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        
        
        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        nativeAdView.storeView?.isHidden = nativeAd.store == nil
        
        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil
        
        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil
        
        // In order for the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        
        // Associate the native ad view with the native ad object. This is
        // required to make the ad clickable.
        // Note: this should always be done after populating the ad views.
        nativeAdView.nativeAd = nativeAd
        
        self.tableView.reloadData()
        
    }
}

// MARK: - GADUnifiedNativeAdDelegate implementation
extension TemplateNativeFeedAdViewController: GADUnifiedNativeAdDelegate {
    
    func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
}



