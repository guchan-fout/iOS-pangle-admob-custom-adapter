//
//  NativeAdViewController.swift
//  AdmobAdapterDemo
//
//  Created by Gu Chan on 2020/07/02.
//  Copyright © 2020 GuChan. All rights reserved.
//

import UIKit

class NativeAdViewController: UIViewController {
    
    /// The ad loader. You must keep a strong reference to the GADAdLoader during the ad loading
    /// process.
    var adLoader: GADAdLoader!
    
    /// The native ad view that is being presented.
    var nativeAdView: GADNativeAdView!
    
    /// The ad unit ID.
    //adUnitID = "ca-app-pub-3940256099942544/3986624511" is test id from admob
    let adUnitID = "ca-app-pub-2748478898138855/8222002816"
    
    /// The height constraint applied to the ad view, where necessary.
    var heightConstraint: NSLayoutConstraint?
    
    var imageOptions = GADNativeAdImageAdLoaderOptions()
    
    
    @IBAction func onBackClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // here to set if download image by adapter or app
        imageOptions.disableImageLoading = true
        
        adLoader = GADAdLoader(
            adUnitID: adUnitID, rootViewController: self,
            adTypes: [.native], options: [imageOptions])
        adLoader.delegate = self
        adLoader.load(GADRequest())
        
        guard
            let nibObjects = Bundle.main.loadNibNamed("NativeAdView", owner: nil, options: nil),
            let adView = nibObjects.first as? GADNativeAdView
            else {
                assert(false, "Could not load nib file for adView")
        }
        
        setAdView(adView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    func setAdView(_ view: GADNativeAdView) {
        // Remove the previous ad view.
        nativeAdView = view
        nativeAdView.isHidden = true
        let screenSize: CGRect = UIScreen.main.bounds
        let containerView = UIView(frame: CGRect(x: 0, y: 100, width: screenSize.width, height: 300))
        
        containerView.addSubview(nativeAdView)
        self.view.addSubview(containerView)
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

extension NativeAdViewController: GADAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
    
}

extension NativeAdViewController: GADVideoControllerDelegate {

  func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
    print("\(videoController) Video playback has ended.")
  }
    
}

extension NativeAdViewController: GADNativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
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
        
        
        if (imageOptions.disableImageLoading == true) {

            // download icon image
            (nativeAdView.iconView as? UIImageView)?.image = loadImage(nativeAd.icon?.imageURL)

            if (!mediaContent.hasVideoContent) {
                //download ad main image
                let adImage = loadImage(nativeAd.images?[0].imageURL)
                let adImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: (nativeAdView.imageView?.frame.width)!, height: (nativeAdView.imageView?.frame.height)!))
                adImageView.image = adImage
                nativeAdView.imageView?.addSubview(adImageView)
            }
        } else {
            (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
            (nativeAdView.imageView as? UIImageView)?.image = nativeAd.images?[0].image
        }
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        nativeAdView.imageView?.isHidden = nativeAd.images == nil
    
        
        
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
    }

    func loadImage(_ url: URL?) -> UIImage? {
        var data: Data? = nil
        if let url = url {
            do {
                data = try Data(contentsOf: url)
            } catch let error as NSError {
                print(error)
            }
        }
        var image: UIImage? = nil
        if let data = data {
            image = UIImage(data: data)
        }
        return image
    }
}

// MARK: - GADUnifiedNativeAdDelegate implementation
extension NativeAdViewController: GADNativeAdDelegate {
    
    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADNativeAd) {
        print("\(#function) called")
    }
}
