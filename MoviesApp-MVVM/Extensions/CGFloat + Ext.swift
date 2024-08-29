//
//  CGFloat + Ext.swift
//  MoviesApp-MVVM
//
//  Created by Mert Yılmaz on 28.08.2024.
//

import UIKit

extension UIViewController {
    var screenWidth: CGFloat {
        return view.frame.size.width
    }
    var screenHeight: CGFloat {
        return view.frame.size.height
    }
    var titleFontSize: CGFloat {
        return view.frame.size.height * 0.019
    }
}
extension UIView {
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    var titleFontSize: CGFloat {
        return UIScreen.main.bounds.height * 0.019
    }
    
}
