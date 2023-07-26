//
//  setupLabelAndButton.swift
//  DdokBaro
//
//  Created by 신서연 on 2023/07/24.
//

import UIKit

extension UIView {
    func setupLabelAndButton<T: UIView>(view: T, systemName: String, text: String, imageColor: UIColor, textColor: UIColor, font: UIFont, pointSize: CGFloat, weight: UIImage.SymbolWeight, forState state: UIControl.State = .normal) {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight, scale: .default)
        
        if let symbolImage = UIImage(systemName: systemName, withConfiguration: symbolConfiguration)?.withTintColor(imageColor).withRenderingMode(.alwaysOriginal){
            
            if let button = view as? UIButton {
                button.setImage(symbolImage, for: .normal)
                
                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: textColor,
                    .font: font
                ]
                let titleString = NSAttributedString(string: text, attributes: titleAttributes)
                button.setAttributedTitle(titleString, for: state)
                
            } else if let label = view as? UILabel {
                let symbolAttachment = NSTextAttachment()
                symbolAttachment.image = symbolImage
                
                let symbolAttributedString = NSAttributedString(attachment: symbolAttachment)
                
                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: textColor,
                    .font: font
                ]
                
                let titleString = NSAttributedString(string: text, attributes: titleAttributes)
                
                let combination = NSMutableAttributedString()
                combination.append(symbolAttributedString)
                combination.append(titleString)
                
                label.attributedText = combination
            }
        }
    }
}
