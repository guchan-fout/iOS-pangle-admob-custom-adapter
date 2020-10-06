//
//  VideoAdCellTableViewCell.swift
//  AdmobAdapterDemo
//
//  Created by Chan Gu on 2020/10/02.
//  Copyright © 2020 GuChan. All rights reserved.
//

import UIKit

class NativeAdCellTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoView: UIView!
    
    @IBOutlet weak var actionBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        containerView.subviews.forEach { view in
            view.removeFromSuperview()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(nativeAd: BUNativeAd) {
        title.text = nativeAd.data?.adTitle
        desc.text = nativeAd.data?.adDescription
        actionBtn.titleLabel?.text = nativeAd.data?.buttonText
    }
    
}
