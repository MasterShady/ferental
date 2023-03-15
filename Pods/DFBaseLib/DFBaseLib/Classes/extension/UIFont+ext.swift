//
//  UIFont+ext.swift
//  DoFunNew
//
//  Created by Rice.Chen on 2021/7/9.
//

import UIKit

// MARK: - CustomFont
public enum FontAlias: String {
    case pfRegular  = "PingFangSC-Regular"
    case pfMedium   = "PingFangSC-Medium"
    case pfLight    = "PingFangSC-Light"
    case pfSemibold = "PingFangSC-Semibold"
    case hltRegular = "HelveticaNeue"
    case hltMedium  = "HelveticaNeue-Medium"
    case hltBold    = "HelveticaNeue-Bold"
    case dinRegular = "DIN Alternate"
    case dinBold    = "DINAlternate-Bold"
    case arialIMT   = "Arial-ItalicMT"
}

public extension UIFont {
    static func font(size: CGFloat, alias: FontAlias) -> UIFont {
        let diff = size * (UIScreen.main.bounds.size.width / 375.0)
        return UIFont(name: alias.rawValue, size: diff) ?? UIFont.systemFont(ofSize: diff)
    }
}

