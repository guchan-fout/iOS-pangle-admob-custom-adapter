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
        bannerView.adUnitID = "ca-app-pub-2748478898138855/1197230743"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        createAnotherBanner()
    }
    
    func createAnotherBanner(){
        print("createAnotherBanner")
        var bannerView2: GADBannerView!
        let adSize = GADAdSizeFromCGSize(CGSize(width: 300, height: 250))
        bannerView2 = GADBannerView(adSize: adSize)
        bannerView2.adUnitID = "ca-app-pub-2748478898138855/7004935081"
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
    
    func initializeMoPubSdk(adUnitIdForConsent: String,
                            containerViewController: ContainerViewController,
                            mopub: MoPub = .sharedInstance()) {
        // MoPub SDK initialization
        let sdkConfig = MPMoPubConfiguration(adUnitIdForAppInitialization: adUnitIdForConsent)
        sdkConfig.globalMediationSettings = []
        sdkConfig.loggingLevel = .info
        
        mopub.initializeSdk(with: sdkConfig) {
            // Update the state of the menu now that the SDK has completed initialization.
        }
    }
    
}

class ContainerViewController: UIViewController {
    // Constants
    struct Constants {
        static let menuAnimationDuration: TimeInterval = 0.25 //seconds
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var menuContainerLeadingEdgeConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuContainerWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Menu Gesture Recognizers
    
    private var menuCloseGestureRecognizer: UISwipeGestureRecognizer!
    private var menuCloseTapGestureRecognizer: UITapGestureRecognizer!
    private var menuOpenGestureRecognizer: UISwipeGestureRecognizer!
    
    // MARK: - Properties
    
    /**
     Current collection of override traits for mainTabBarController.
     */
    var forcedTraitCollection: UITraitCollection?  = nil {
        didSet {
            updateForcedTraitCollection()
        }
    }
    
    /**
     Main TabBar Controller of the app.
     */
    
    /**
     Menu TableView Controller of the app.
     */
    

    
    // MARK: - Forced Traits
    
    func setForcedTraits(for size: CGSize) {
        let device = traitCollection.userInterfaceIdiom
        let isPortrait: Bool = view.bounds.size.width < view.bounds.size.height
        
        switch (device, isPortrait) {
        case (.pad, true): forcedTraitCollection = UITraitCollection(horizontalSizeClass: .compact)
        default: forcedTraitCollection = nil
        }
    }
    
    /**
     Updates the Main Tab Bar controller with the new trait overrides.
     */
    func updateForcedTraitCollection() {

    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // When the children view controllers are loaded, each will perform
        // a segue which we must capture to initialize the view controller
        // properties.
        switch segue.identifier {
        case "onEmbedTabBarController":
            break
        case "onEmbedMenuController":
            break
        default:
            break
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup trait overrides
        setForcedTraits(for: view.bounds.size)
        
        // Initialize the gesture recognizers and attach them to the view.
        menuCloseGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeMenuClose(_:)))
        menuCloseGestureRecognizer.direction = .left
        view.addGestureRecognizer(menuCloseGestureRecognizer)
        
        menuCloseTapGestureRecognizer = UITapGestureRecognizer (target: self, action: #selector(tapMenuClose(_:)))
        menuCloseTapGestureRecognizer.isEnabled = false
        menuCloseTapGestureRecognizer.delegate = self
        view.addGestureRecognizer(menuCloseTapGestureRecognizer)
        
        menuOpenGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeMenuOpen(_:)))
        menuOpenGestureRecognizer.direction = .right
        view.addGestureRecognizer(menuOpenGestureRecognizer)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.setForcedTraits(for: size)
        }, completion: nil)
    }

    // MARK: - Menu
    
    /**
     Closes the menu if it open.
     */
    func closeMenu() {
        swipeMenuClose(menuCloseGestureRecognizer)
    }
    
    @objc func swipeMenuClose(_ sender: UISwipeGestureRecognizer) {
        // Do nothing if the menu is not fully open since it may either
        // be closed, or in the process of being closed.
        guard menuContainerLeadingEdgeConstraint.constant == 0 else {
            return
        }
        
        // Disable the tap outside of menu to close gesture recognizer.
        menuCloseTapGestureRecognizer.isEnabled = false
        
        // Close the menu by setting the leading edge constraint to the negative width,
        // which will put it offscreen.
        UIView.animate(withDuration: Constants.menuAnimationDuration, animations: {
            self.menuContainerLeadingEdgeConstraint.constant = -self.menuContainerWidthConstraint.constant
            self.view.layoutIfNeeded()
        }) { _ in
            // Re-enable user interaction for the main content container.
        }
    }
    
    @objc func swipeMenuOpen(_ sender: UISwipeGestureRecognizer) {
        // Do nothing if the menu is already open or in the process of opening.
        guard (menuContainerWidthConstraint.constant + menuContainerLeadingEdgeConstraint.constant) == 0 else {
            return
        }
        
        // Disable user interaction for the main content container.
        
        // Open the menu by setting the leading edge constraint back to zero.
        UIView.animate(withDuration: Constants.menuAnimationDuration, animations: {
            self.menuContainerLeadingEdgeConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { _ in
            // Enable the tap outside of menu to close gesture recognizer.
            self.menuCloseTapGestureRecognizer.isEnabled = true
        }
    }
    
    @objc func tapMenuClose(_ sender: UITapGestureRecognizer) {
        // Allow any previously queued animations to finish before attempting to close the menu
        view.layoutIfNeeded()
        
        // Close the menu
        closeMenu()
    }
}

extension ContainerViewController: UIGestureRecognizerDelegate {
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Only handle the menu tap to close gesture
        guard gestureRecognizer == menuCloseTapGestureRecognizer else {
            return true
        }
        
        // If the menu is not fully open, disregard the tap.
        guard menuContainerLeadingEdgeConstraint.constant == 0 else {
            return false
        }
        
        // If the tap intersects the open menu, disregard the tap.
        guard gestureRecognizer.location(in: view).x > menuContainerWidthConstraint.constant else {
            return false
        }
        
        return true
    }
}

