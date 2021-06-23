//
//  SelfSizedTableView.swift
//  catpay-ios
//
//  Created by Juan Felipe Torres on 20/06/21.
//  Copyright © 2021 Technifiser. All rights reserved.
//

import UIKit

class SelfSizedTableView: UITableView {

    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
      super.reloadData()
      self.invalidateIntrinsicContentSize()
      self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
      let height = min(contentSize.height, maxHeight)
      return CGSize(width: contentSize.width, height: height)
    }
    
    override func layoutSubviews() {
    super.layoutSubviews()
    invalidateIntrinsicContentSize()
    }
}
