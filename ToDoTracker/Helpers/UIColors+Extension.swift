//
//  UIColors+Extension.swift
//  ToDoTracker
//
//  Created by Денис on 16.06.2023.
//

import UIKit

extension UIColor {
    static let YPBackground = UIColor(named: "YPBackground")
    static let YPRed = UIColor(named: "YPRed")
    static let YPWhite = UIColor(named: "YPWhite")
    static let YPBlack = UIColor(named: "YPBlack")
    static let YPBlue = UIColor(named: "YPBlue")
    static let YPGrey = UIColor(named: "YPGrey")
    static let YPLightGrey = UIColor(named: "YPLightGrey")
    static let YPBackgroundDay = UIColor(named: "YPBackgroundDay")
}

///Цвета для UICollectionView!
extension UIColor {
    static let colorSection1 = UIColor(named: "Colorselection1")
    static let colorSection2 = UIColor(named: "Colorselection2")
    static let colorSection3 = UIColor(named: "Colorselection3")
    static let colorSection4 = UIColor(named: "Colorselection4")
    static let colorSection5 = UIColor(named: "Colorselection5")
    static let colorSection6 = UIColor(named: "Colorselection6")
    static let colorSection7 = UIColor(named: "Colorselection7")
    static let colorSection8 = UIColor(named: "Colorselection8")
    static let colorSection9 = UIColor(named: "Colorselection9")
    static let colorSection10 = UIColor(named: "Colorselection10")
    static let colorSection11 = UIColor(named: "Colorselection11")
    static let colorSection12 = UIColor(named: "Colorselection12")
    static let colorSection13 = UIColor(named: "Colorselection13")
    static let colorSection14 = UIColor(named: "Colorselection14")
    static let colorSection15 = UIColor(named: "Colorselection15")
    static let colorSection16 = UIColor(named: "Colorselection16")
    static let colorSection17 = UIColor(named: "Colorselection17")
    static let colorSection18 = UIColor(named: "Colorselection18")
}

///Для перевода цвета в КорДату и обратно (Привет, Хоббит)
extension UIColor {
    
    func hexString() -> String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        return String.init(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }
    
    func color(from hex: String) -> UIColor {
        var rgbValue:UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
