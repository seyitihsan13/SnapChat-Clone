//
//  SnapViewController.swift
//  Snapchat Clone
//
//  Created by İhsan Elkatmış on 3.08.2022.
//

import UIKit
import ImageSlideshow
import ImageSlideshowKingfisher

class SnapViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    var selectedSnap : Snap?
    var inputArray = [KingfisherSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
    
        if let snap = selectedSnap {
            
            timeLabel.text = "Time Left: \(snap.timeDifference)"
            
            for imageUrl in snap.imageUrlArray {
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            let imageSlideShow = ImageSlideshow(frame: CGRect.init(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            imageSlideShow.backgroundColor = UIColor.black
            
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.blue
            pageIndicator.pageIndicatorTintColor = UIColor.white
            imageSlideShow.pageIndicator = pageIndicator
            
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel)
            
        }

}
    
}
