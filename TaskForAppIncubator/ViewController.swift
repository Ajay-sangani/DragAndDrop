//
//  ViewController.swift
//  TaskForAppIncubator
//
//  Created by Ajay Sangani on 28/06/22.
//
// Topic: Drag and drop Sticker on View and
//        On Long press sticker will be selected and user can drag onto view or Trash.

import UIKit

class ViewController: UIViewController {
    
    //MARK: Declare Constants
    private struct Constants {
        static let padding: CGFloat = 10
        static let blockDimension: CGFloat = 70
        static let trashButtonDimension: CGFloat = 40
    }
    
    //Variable Declaration
    var trashButton: UIButton?
    var beginningPosition: CGPoint = .zero
    var initialMovableViewPosition: CGPoint = .zero
    var arrStickers = ["AppIncubator1", "AppIncubator2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call Add Moveable Stickers
        addMoveableSticker(count: arrStickers.count)
        
        //Call Add Trash
        addTrashButton()
    }
    
    //MARK: Create Moveable Image View Dynamic using Function
    private func addMoveableSticker(count: Int) {
        var xOffset = Constants.padding
        for i in 0..<count {
            let moveableImageView = UIImageView(frame: CGRect(x: xOffset, y: 64, width: Constants.blockDimension, height: Constants.blockDimension))
            moveableImageView.image = UIImage(named: arrStickers[i])
            view.addSubview(moveableImageView)
            
            //Add UIPanGesture for Drag And Drop Stickers
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(touched(_:)))
            moveableImageView.isUserInteractionEnabled = true
            moveableImageView.addGestureRecognizer(gestureRecognizer)
            
            //Add Long Press Gesture for Drag And Drop Stickers
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            moveableImageView.isUserInteractionEnabled = true
            moveableImageView.addGestureRecognizer(longPressGesture)
            
            
            xOffset += Constants.blockDimension + Constants.padding
        }
    }
    
    //MARK: Create Trash Button
    private func addTrashButton() {
        let xPosition = view.frame.width - Constants.padding - Constants.blockDimension
        let yPosition = view.frame.height - Constants.padding - Constants.blockDimension
        trashButton = UIButton(frame: CGRect(x: xPosition, y: yPosition, width: Constants.trashButtonDimension, height: Constants.trashButtonDimension))
        trashButton?.setImage(UIImage(named: "trash-bin"), for: .normal)
        view.addSubview(trashButton!)
    }
    
    //Handle Touched Method For UIPanGesture
    @objc private func touched(_ gestureRecognizer: UIGestureRecognizer) {
        if let touchedView = gestureRecognizer.view {
            var imageView = gestureRecognizer.view as! UIImageView
            if gestureRecognizer.state == .began { //Began
                
                let point = gestureRecognizer.location(in: touchedView)
                let xPosition: CGFloat = point.x
                let yPosition: CGFloat = point.y
                
                imageView = UIImageView(frame: CGRect(x: (xPosition - 50.0), y: (yPosition - 50.0), width: Constants.blockDimension, height: Constants.blockDimension))
                
            } else if gestureRecognizer.state == .ended { //Ended
                
                let point = gestureRecognizer.location(in: touchedView)
                let xPosition: CGFloat = point.x
                let yPosition: CGFloat = point.y
                
                imageView = UIImageView(frame: CGRect(x: (xPosition - 50.0), y: (yPosition - 50.0), width: Constants.blockDimension, height: Constants.blockDimension))
                
            } else if gestureRecognizer.state == .changed { //Changed
                let locationInView = gestureRecognizer.location(in: touchedView)
                touchedView.frame.origin = CGPoint(x: touchedView.frame.origin.x + locationInView.x - beginningPosition.x, y: touchedView.frame.origin.y + locationInView.y - beginningPosition.y)
            }
        }
    }
    
    //Handle Long Press Gesture
    @objc private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        if let touchedView = gestureRecognizer.view {
            let imageView = gestureRecognizer.view as! UIImageView
            if gestureRecognizer.state == .began { //Began
                beginningPosition = gestureRecognizer.location(in: touchedView)
                initialMovableViewPosition = touchedView.frame.origin
                //Changes Background Color When Select ImageView
                imageView.backgroundColor = .lightGray
            } else if gestureRecognizer.state == .ended { //Ended
                touchedView.frame.origin = initialMovableViewPosition
                imageView.backgroundColor = .clear
            } else if gestureRecognizer.state == .changed { //Changed
                imageView.backgroundColor = .clear
                let locationInView = gestureRecognizer.location(in: touchedView)
                touchedView.frame.origin = CGPoint(x: touchedView.frame.origin.x + locationInView.x - beginningPosition.x, y: touchedView.frame.origin.y + locationInView.y - beginningPosition.y)
                
                //Delete Image When Match Frame With Trash Button
                if touchedView.frame.intersects(trashButton!.frame) {
                    touchedView.removeFromSuperview()
                    //set Initial Position zero
                    initialMovableViewPosition = .zero
                }
            }
        }
    }
}
