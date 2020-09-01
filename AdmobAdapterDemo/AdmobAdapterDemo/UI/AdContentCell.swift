//
//  AdContentCell.swift
//  Created by Gu Chan on 2020/07/01.
//  Copyright © 2020 GuChan. All rights reserved.
//

import UIKit

class AdContentCell: UITableViewCell {

    @IBOutlet weak var container: UIView!

    override func prepareForReuse() {
        super.prepareForReuse()

        container.subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
}
