//
//  UITextField_wordFrames.swift
//  word play
//
//  Created by Andy Bell on 08/02/2016.
//  Copyright © 2016 bellovic. All rights reserved.
//

import UIKit

extension UITextView {
    
    typealias Index = String.CharacterView.Index
    
    private var wordsArrayUnique:Array<String> {
        get {
            let mainTxtForSearch = self.text
            let wordsArray = mainTxtForSearch!.componentsSeparatedByString(" ")
            return uniq(wordsArray)
        }
    }
    
    private var completeTxtRange:Range<Index>{
        get {
            return self.text!.startIndex..<self.text!.startIndex.advancedBy(self.text!.characters.count)
        }
    }
    
    public func wordRects() -> [CGRect] {
        
        var rectsArray = [CGRect]()
        for wordStr in self.wordsArrayUnique where (wordStr != "") {
            
            let ranges = rangesOfString(wordStr, inString: self.text!, options: .LiteralSearch, searchRange: self.completeTxtRange)
            for ran in ranges {
                let wordRect = rectForWordRange(ran, inTextView: self)
                rectsArray.append(wordRect)
            }
        
        }
        return rectsArray
     
    }
    
    public func wordRects(withCompletion: (word: String, rect: CGRect) -> () ) {
        
        for wordStr in wordsArrayUnique where (wordStr != "") {
            let ranges = rangesOfString(wordStr, inString: self.text!, options: .LiteralSearch, searchRange: self.completeTxtRange)
            for ran in ranges {
                let wordRect = rectForWordRange(ran, inTextView: self)
                withCompletion(word: wordStr, rect: wordRect)
            }
        }
        
    }
    
    private func rectForWordRange(wordRange: Range<Index>, inTextView textView: UITextView) -> CGRect {
        
        let intIndex: Int = textView.text.startIndex.distanceTo(wordRange.startIndex)
        let wordStartPos = textView.positionFromPosition(textView.beginningOfDocument, inDirection: UITextLayoutDirection.Right, offset: intIndex)
        let wordEndPos = textView.positionFromPosition(wordStartPos!, inDirection: UITextLayoutDirection.Right, offset: wordRange.count)
        let txtRange = textView.textRangeFromPosition(wordStartPos!, toPosition: wordEndPos!)
     
        return textView.firstRectForRange(txtRange!)
        
    }
    
    private func checkRangeIsAtEnd(range: Range<Index>) -> Bool {
        var count = 0
        for _ in range {
            ++count
        }
        return count < 1
    }
    
    private func rangesOfString(searchString:String, inString mainString:String, options: NSStringCompareOptions = [], searchRange:Range<Index>? = nil ) -> [Range<Index>] {
        
        if let range = mainString.rangeOfString(searchString, options: options, range:searchRange) {
            
            let nextRange = Range(start:range.endIndex, end:mainString.endIndex)
            if(checkRangeIsAtEnd(nextRange)){
                return [range]
            }else if(isCompleteWord(forRange: range, inString: mainString)){
                return [range] + rangesOfString(searchString, inString: mainString, searchRange: nextRange)
            }else{
                return rangesOfString(searchString, inString: mainString, searchRange: nextRange)
            }
            
        } else {
            // didn't find the string
            return []
        }
        
    }
    
    private func isCompleteWord(forRange range:Range<Index>, inString string:String) -> Bool {
        
        let nextCharAlpha = nextCharIsAlphanumeric(inString: string, withRange: range)
        let prevCharBlank = prevCharIsBlank(inString: string, withRange: range)
        return (!nextCharAlpha && prevCharBlank)
        
    }
    
    private func nextCharIsAlphanumeric(inString string:String, withRange range: Range<Index>) -> Bool {
        let nextChar = string[range.endIndex]
        let nextCharUtf = "\(nextChar)".utf16.first
        let letterSet = NSCharacterSet.alphanumericCharacterSet()
        return letterSet.characterIsMember(nextCharUtf!)
    }

    private func prevCharIsBlank(inString string:String, withRange range: Range<Index>) -> Bool {
        
        if(string.startIndex == range.startIndex){
            return true
        }else{
            let prevChar = string[range.startIndex.advancedBy(-1)]
            return ("\(prevChar)" == " ")
        }
        
    }
    
    private func uniq<S : SequenceType, T : Hashable where S.Generator.Element == T>(source: S) -> [T] {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
}