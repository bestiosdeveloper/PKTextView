//
//  PKTextView.swift
//  PKTextView
//
//  Created by Pramod Kumar on 11/05/16.
//  Copyright © 2016 Pramod Kumar. All rights reserved.
//

import UIKit

protocol PKTextViewDelegate: class, UITextViewDelegate {
//    func keyForHashTagText(textView: PKTextView) -> String
//    func keyForHashTagCount(textView: PKTextView) -> String
    func numberOfOptions(textView: PKTextView) -> CGFloat
    func heightForOptions(textView: PKTextView) -> CGFloat
    func maximumVisibleOptionsInList(textView: PKTextView) -> CGFloat
    func pkTextView(textView: PKTextView, titleTextForOption atIndex: Int) -> String
    func pkTextView(textView: PKTextView, countTextForOption atIndex: Int) -> String
    func pkTextView(textView: PKTextView, titleTextForSelectedOption atIndex: Int) -> String
    func pkTextView(textView: PKTextView, willDisplayOption atIndex: Int)

    func pkTextView(textView: PKTextView, dataForSearchText text: String)
}

extension PKTextViewDelegate {
    func numberOfOptions(textView: PKTextView) -> CGFloat { return 0.0 }
    func heightForOptions(textView: PKTextView) -> CGFloat { return 0.0 }
    func maximumVisibleOptionsInList(textView: PKTextView) -> CGFloat { return 0.0 }
    func pkTextView(textView: PKTextView, titleTextForOption atIndex: Int) -> String { return "" }
    func pkTextView(textView: PKTextView, countTextForOption atIndex: Int) -> String { return "" }
    func pkTextView(textView: PKTextView, titleTextForSelectedOption atIndex: Int) -> String { return "" }
    func pkTextView(textView: PKTextView, willDisplayOption atIndex: Int) { }
    
    func pkTextView(textView: PKTextView, dataForSearchText text: String) { }
}

class PKTextView: UITextView {
    
    //MARK:- Internal Properties
    //MARK:-
    fileprivate var shouldDrawPlaceholder = true
    var isTypingForHashTag = false
    fileprivate var currentFont: UIFont!
    var oldText = ""
    
    var searchText = "" {
        didSet{
            if "\(self.searchText.firstCharacter)" == "#" {
                self.searchText = String(self.searchText.dropFirst())
            }
        }
    }
    
    fileprivate var isDelPress: Bool {
        var flag = false
        if (self.text ?? "").count < self.oldText.count {
            flag = true
        }
        return flag
    }
    
    //MARK:- Public Properties
    //MARK:-
//    var kHashTagText: String = "", kHashTagCount: String = ""
    var optionListBackView: UIView?
    var optionListTableView : UITableView?
    var optionHeight : CGFloat = 50.0 //height for option table view cell
    var maxVisibleOptions : CGFloat = 5.0
    var totalNoOfOptions : CGFloat = 0.0
    
    //Text view changeable properties
    var placeholder: String = ""
    var attributedPlaceholder : NSMutableAttributedString?
    var borderWidth: CGFloat = 0.0
    var borderColor: UIColor = UIColor.darkGray
    
    //Hash tag options changeable properties
    var hashTagsColor = UIColor.blue
    var hashTagsFont: UIFont = UIFont.systemFont(ofSize: 13.0)
    var isHashTagEnabled: Bool = false
    
    weak var pkDelegate: PKTextViewDelegate? {
        didSet{
            self.delegate = self.pkDelegate
        }
    }
    
    //MARK:- View Initialization
    //MARK:-
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        super.canPerformAction(action, withSender: sender)
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialSetup()
        
        //Add option list view
        self.delay(0.2, closure: { [weak self] in
            self?.getIntialValue()
            self?.addOptionsListView()
        })
    }
    
    deinit {
        //Remove Notification for Text View Delegates
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidEndEditing, object: nil)
        NotificationCenter.default.removeObserver(self)

        //Remove Observer text key
        self.removeObserver(self, forKeyPath: "text", context: nil)
        self.removeObserver(self, forKeyPath: "font", context: nil)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
        self.font = self.currentFont
        
        if self.shouldDrawPlaceholder {
            
            var textFrame = CGRect.zero
            if self.frame.size.height > 60.0 {
                textFrame = CGRect(x: 5.0,y: 5.0,width: self.frame.size.width-10,height: self.frame.size.height-10.0)
            }
            else {
                let oneLineH = self.font?.lineHeight ?? 0
                let newY = (self.frame.size.height - oneLineH) / 2.0
                textFrame = CGRect(x: 5.0,y: newY,width: self.frame.size.width-10,height: self.frame.size.height-10.0)
            }
            
            if let plceText = self.attributedPlaceholder {
                plceText.draw(in: textFrame)
            }
            else {
                self.placeholder.draw(in: textFrame, withAttributes: [NSAttributedStringKey.font : self.currentFont, NSAttributedStringKey.foregroundColor : UIColor.lightGray])
            }
        }
        self.heighLightHashTags()
    }
    
    
    //MARK:- Action Methods
    //MARK:-
    @objc func textDidChange(_ sender : Foundation.Notification) {
        self.font = self.currentFont
        self.updatePlaceHolderDrawer()
        self.heighLightHashTags()
        self.updateSearchText()
        self.oldText = self.text
    }
    
    @objc func textViewDidBeginEditing(_ sender : Foundation.Notification) {
        self.heighLightHashTags()
    }
    
    @objc func textViewDidEndEditing(_ sender : Foundation.Notification) {
    }
    
    //MARK:- Observer method for registered keys
    //MARK:-
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == "text") && (object as AnyObject).isKind(of: PKTextView.self) {
//            self.delegate?.textViewDidChange!(self)
            self.updatePlaceHolderDrawer()
        }
        if keyPath == "font" && (object as AnyObject).isKind(of: PKTextView.self) {
            self.currentFont = self.font
        }
    }
    
    
    //MARK:- Private Methods
    //MARK:-
    private func getIntialValue() {
        if isHashTagEnabled {
//            self.kHashTagText = self.pkDelegate?.keyForHashTagText(textView: self) ?? ""
//            self.kHashTagCount = self.pkDelegate?.keyForHashTagCount(textView: self) ?? ""
            
            self.maxVisibleOptions = self.pkDelegate?.maximumVisibleOptionsInList(textView: self) ?? self.maxVisibleOptions
            self.optionHeight = self.pkDelegate?.heightForOptions(textView: self) ?? self.optionHeight
            self.totalNoOfOptions = self.pkDelegate?.numberOfOptions(textView: self) ?? self.totalNoOfOptions
            self.searchText = ""
        }
    }
    
    private func initialSetup() {
        self.layer.borderWidth = self.borderWidth
        self.layer.cornerRadius = self.cornerRadius
        self.clipsToBounds = true
        self.currentFont = self.font
        
        //Add Notification for Text View Delegates
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidBeginEditing(_:)), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidEndEditing(_:)), name: NSNotification.Name.UITextViewTextDidEndEditing, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        //Add Observer text key
        self.addObserver(self, forKeyPath: "text", options: [], context: nil)
        self.addObserver(self, forKeyPath: "font", options: [], context: nil)
    }
    
    private func updatePlaceHolderDrawer() {
        self.shouldDrawPlaceholder = self.text.count <= 0 ? true : false
        self.setNeedsDisplay()
    }
    
    private func updateSearchText() {
        
        func callForSearchText() {
            if !self.searchText.isEmpty, self.isHashTagEnabled, self.isTypingForHashTag {
                self.pkDelegate?.pkTextView(textView: self, dataForSearchText: self.searchText)
                self.updateList()
            }
            else {
                self.hideOptions(isHidden: true, animated: true)
            }
        }
        
        //check if typing for hash tag or not
        if self.isTypingForHashTag {
            if ("\(self.text.lastCharacter)" != " ") {
                //update if tying for hash tagj
                 self.searchText = self.isDelPress ? String(self.searchText.dropLast()) : "\(self.searchText)\(self.text.lastCharacter)"
            }
            else {
                self.isTypingForHashTag = false
                self.searchText = ""
            }
            callForSearchText()
        }
        else if !self.isTypingForHashTag {
            if self.isDelPress {
                if "\(self.text.lastWord.firstCharacter)" == "#" {
                    self.searchText = String(self.text.lastWord.dropFirst())
                    self.isTypingForHashTag = true
                }
            }
            else {
                self.isTypingForHashTag = "\(self.text.lastCharacter)" == "#"
            }
        }
    }
    
    func heighLightHashTags() {
        if self.isHashTagEnabled {
            self.attributedText = self.text.heighLightHashTags(hashTagsFont: self.hashTagsFont, hashTagsColor: self.hashTagsColor)
        }
    }
    
    func reloadOptions() {
        guard let optionTbl = self.optionListTableView, let backV = self.optionListBackView else {
            return
        }

        backV.frame = CGRect(x: backV.frame.origin.x, y: backV.frame.origin.y, width: backV.frame.width, height: self.getOptionTableViewHeight())
        optionTbl.frame = backV.bounds
        optionTbl.alpha = 1.0
        optionTbl.reloadData()
    }
    
    //Add table view for option list
    fileprivate func addOptionsListView() {
        if self.optionListTableView == nil {
            let newFrame = self.convert(self.frame, to: self.parentViewController?.view)
            
            self.optionListBackView = UIView(frame: CGRect(x: self.frame.origin.x, y: newFrame.origin.y+self.frame.size.height, width: self.frame.size.width-5.0, height: 0.0))
            self.optionListTableView = UITableView(frame: self.optionListBackView!.bounds)
            self.optionListTableView?.register(UINib(nibName:"PKOptionsListCell" ,bundle: nil), forCellReuseIdentifier: "pkOptionsListCell")
            self.optionListTableView?.delegate = self
            self.optionListTableView?.dataSource = self
            self.optionListTableView?.clipsToBounds = true
            self.optionListTableView?.separatorStyle = UITableViewCellSeparatorStyle.none
            
            self.optionListBackView?.addShadowWith()
            self.optionListBackView?.addSubview(self.optionListTableView!)
            self.parentViewController?.view.addSubview(self.optionListBackView!)
        }
    }
    
    //Hide options list view
    func hideOptions(isHidden: Bool, animated: Bool) {
        guard let optionTbl = self.optionListTableView else {
            return
        }
        let optionsFrame = optionTbl.frame
        if isHidden { optionTbl.isHidden = false }
        UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
            let height = isHidden ? 0.0 : self.getOptionTableViewHeight()
            optionTbl.frame = CGRect(x: optionsFrame.origin.x, y: optionsFrame.origin.y, width: optionsFrame.size.width, height: height)
            optionTbl.alpha = 0.0
        }, completion: {
            completed in
            optionTbl.isHidden = isHidden
            optionTbl.alpha = isHidden ? 0.0 : 1.0
            if !isHidden { self.reloadOptions() }
        })
    }
    
    //Get option table view height
    fileprivate func getOptionTableViewHeight() -> CGFloat {
        var maxHeight: CGFloat = self.maxVisibleOptions * self.optionHeight
        let newHeight: CGFloat = self.totalNoOfOptions * self.optionHeight
        maxHeight = maxHeight > newHeight ? newHeight : maxHeight
        return maxHeight
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
    
    func getAllHashTags() -> [String] {
        return self.text.allWords(startWith: "#")
    }
    
    func updateList() {
        self.totalNoOfOptions = self.pkDelegate?.numberOfOptions(textView: self) ?? self.totalNoOfOptions
        self.hideOptions(isHidden: self.totalNoOfOptions <= 0.0, animated: true)
        self.reloadOptions()
    }
}
