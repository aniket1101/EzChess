//
//  SecondLaunchViewController.swift
//  EzChess
//
//  Created by Aniket Gupta on 21/10/2021.
//

import UIKit

class SecondLaunchViewController: UIViewController, HolderViewDelegate {
    
    var holderView = HolderView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addHolderView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addHolderView() {
        let boxSize: CGFloat = 100.0
        holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2,
                                  y: view.bounds.height / 2 - boxSize / 2,
                                  width: boxSize,
                                  height: boxSize)
        holderView.parentFrame = view.frame
        holderView.delegate = self
        view.addSubview(holderView)
        holderView.addOval()
        
    }
    
    func animateLabel() {
        // 1
        holderView.removeFromSuperview()
        view.backgroundColor = Colors.blue
        
        // 2
        let iconView: UIImageView = UIImageView()
        iconView.image = UIImage(named: "icon")
        iconView.layer.borderColor = UIColor.white.cgColor
        iconView.layer.borderWidth = 2
        iconView.frame = CGRect(x: 0,
                                y: 0,
                                width: view.width/3,
                                height: view.width/3)
        iconView.center = view.center
        iconView.transform = iconView.transform.scaledBy(x: 0.25, y: 0.25)
        view.addSubview(iconView)
        
        // 3
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1, options: UIView.AnimationOptions.curveEaseInOut) {
            iconView.transform = iconView.transform.scaledBy(x: 4.0, y: 4.0)
        } completion: { finished in
            UIView.animate(withDuration: 0.5, delay: 0.8) {
                iconView.alpha = 0
            } completion: { finished in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "board")
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present (nav, animated: false)
            }
        }
        
       

    }

    
}
