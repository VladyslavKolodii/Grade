//
//  UIFontExtestion+Heplers.swift
//


import UIKit

enum FontName: Int {
    case thin = 0
    case regular = 1
    case semiBold = 2
    case bold = 3
    
    var font: String {
        switch self {
        case .thin:
            return "ProximaNovaT-Thin"
        case .regular:
            return "ProximaNova-Regular"
        case .semiBold:
            return "ProximaNova-Semibold"
        case .bold:
            return "ProximaNova-Bold"
        }
    }
}

extension UIFont {
    
    static func appFontThin(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.thin.font, size: size) ?? UIFont.systemFont(ofSize: size, weight: .thin)
    }
    
    static func appFontRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.regular.font, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static func appFontBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.bold.font, size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    static func appFontSemiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: FontName.semiBold.font, size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
    }
}
