//
//  ViewController.swift
//  W2_Lesson-02
//
//  Created by Văn Khánh Vương on 22/03/2021.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var confirmedButton: UIButton!
    
    
    var rangeArr = Array<NSRange>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentTextView.delegate = self
        self.contentLabel.isHidden = true
        self.contentLabel.font = .systemFont(ofSize: 13)
        self.contentTextView.font = .systemFont(ofSize: 13)
        self.contentLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLabel(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.contentLabel.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        contentTextView.isHidden = true
        contentLabel.isHidden = false
        attributedString(strings: contentTextView.text)
    }
    
    func attributedString(strings: String) {
        
        
        let types : NSTextCheckingResult.CheckingType = [.link]
        
        do {
            let dataDatector = try NSDataDetector(types: types.rawValue)
            let links = dataDatector.matches(in: strings, options: [], range: NSRange(location: 0, length: strings.count))
            
            let attributedString = NSMutableAttributedString(string: strings)
            for link in links {
                attributedString.addAttribute(.link, value: link, range: link.range)
                rangeArr.append(link.range)
            }
            self.contentLabel.attributedText = attributedString
        } catch (let error) {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    @objc func tapLabel(_ gesture: UITapGestureRecognizer) {
        // Dectect lai xem co phai la chu hay link
        // Neu link thi mo nhu binh thuong
        
        // Neu khong phai link thi mo textView
        for range in rangeArr {
            if gesture.didTapAttributedTextInLabel(label: self.contentLabel, inRange: range) {
                print("Nhan link")
                //UIApplication.shared.open()
            }else{
                print("Không nhấp vào link")
            }
        }
        
    }
    
    func createTime() {
        Timer.scheduledTimer(timeInterval: 10,
                             target: self,
                             selector: #selector(fireTimer),
                             userInfo: nil,
                             repeats: true).fire()
    }
    @objc func fireTimer() {
        if contentTextView.isEditable {
            // Sau 10s khong hoat dong
        }
    }
}
extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: (locationOfTouchInLabel.x - textContainerOffset.x), y: 0);
        // Adjust for multiple lines of text
        let lineModifier = Int(ceil(locationOfTouchInLabel.y / label.font.lineHeight)) - 1
        let rightMostFirstLinePoint = CGPoint(x: labelSize.width, y: 0)
        let charsPerLine = layoutManager.characterIndex(for: rightMostFirstLinePoint, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        let adjustedRange = indexOfCharacter + (lineModifier * charsPerLine)
        
        return NSLocationInRange(adjustedRange, targetRange)
    }
}
