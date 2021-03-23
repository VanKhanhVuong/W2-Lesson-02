//
//  ViewController.swift
//  W2_Lesson-02
//
//  Created by Văn Khánh Vương on 22/03/2021.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentTextView.delegate = self
        self.contentLabel.isHidden = true
        self.contentLabel.font = .systemFont(ofSize: 13)
        self.contentTextView.font = .systemFont(ofSize: 13)
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        contentTextView.isHidden = true
        contentLabel.isHidden = false
        attributedString(strings: contentTextView.text)
    }
    
    func attributedString(strings:String){
        let types : NSTextCheckingResult.CheckingType = [.link]
        let dataDatector = try! NSDataDetector(types: types.rawValue)
        let links = dataDatector.matches(in: strings, options: [], range: NSRange(location: 0, length: strings.utf8.count))
        let attributedString = NSMutableAttributedString(string:strings)
        for link in links {
            attributedString.addAttribute(.link, value: String(""), range: link.range)
        }
        self.contentLabel.attributedText = attributedString
    }
    
    func creatTime(){
        _ = Timer.scheduledTimer(timeInterval: 10,
                                         target: self,
                                         selector: #selector(fireTimer),
                                         userInfo: nil,
                                         repeats: true)
    }
    @objc func fireTimer(){
        if contentTextView.isEditable{
            
        }
    }
}
extension UILabel{
    
}
