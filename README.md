# Word-Frames
Swift extension for UITextField to fetch CGRect of every word via return Array or completion closure.

self.textView.wordRects { (word, rect) -> () in
            
   let btn = UIButton(frame: rect)
    btn.backgroundColor = UIColor.randomColor(withAlpha: 0.4)
    btn.setTitle(word, forState: .Normal)
    btn.addTarget(self, action: "btnAction:", forControlEvents: .TouchUpInside)
    self.textView .addSubview(btn)
            
}
        
let wordRects = self.textView.wordRects()
    for rect in wordRects {
    let view = UIView(frame: rect)
    view.backgroundColor = UIColor.randomColor(withAlpha: 0.4)
    self.textView.addSubview(view)
}
