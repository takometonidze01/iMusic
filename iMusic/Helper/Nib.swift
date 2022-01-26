//
//  Nib.swift
//  iMusic
//
//  Created by CodergirlTM on 27.01.22.
//

import UIKit

extension UIView {
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0]
        as! T
    }
}
