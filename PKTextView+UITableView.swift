//
//  PKTextView.swift
//  PKTextView
//
//  Created by Pramod Kumar on 11/05/16.
//  Copyright © 2016 Pramod Kumar. All rights reserved.
//

import UIKit


extension PKTextView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.totalNoOfOptions = self.pkDelegate?.numberOfOptions(textView: self) ?? 0.0
        return Int(self.totalNoOfOptions)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.optionHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "pkOptionsListCell") as! PKOptionsListCell
        
        cell.nameLabel.text = self.pkDelegate?.pkTextView(textView: self, titleTextForOption: indexPath.row) ?? ""
        cell.countLabel.text = self.pkDelegate?.pkTextView(textView: self, countTextForOption: indexPath.row) ?? ""
        cell.imageViewHeight.constant = 0.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textArray = self.text.components(separatedBy: "#")
        textArray.removeLast()
        
        if let textTag = self.pkDelegate?.pkTextView(textView: self, titleTextForSelectedOption: indexPath.row) {
            self.text = "\(textArray.joined(separator: "#"))" + "\(textTag) ".replacingOccurrences(of: "  ", with: " ")
            self.oldText = self.text
            self.delegate?.textViewDidChange!(self)
        }
        self.searchText = ""
        self.heighLightHashTags()
        self.isTypingForHashTag = false
        self.hideOptions(isHidden: true, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.pkDelegate?.pkTextView(textView: self, willDisplayOption: indexPath.row)
    }
}
