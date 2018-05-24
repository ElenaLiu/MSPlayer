//
//  FloatingPlayerViewController.swift
//  MSPlayer_Example
//
//  Created by Mason on 2018/5/17.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import MSPlayer

class FloatingPlayerViewController: UIViewController, MSFloatableViewController, UIGestureRecognizerDelegate {
   
    weak var floatingController: MSFloatingController? =  MSFloatingController.shared()
    
    lazy var floatingView: UIView = MSPlayer()
    
    let createAnotherVCButton = UIButton(type: UIButtonType.system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.addSubview(floatingView)
        floatingView.translatesAutoresizingMaskIntoConstraints = false
        floatingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        floatingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        floatingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        floatingView.heightAnchor.constraint(equalTo: self.floatingView.widthAnchor, multiplier: (9/16)).isActive = true
        self.view.addSubview(createAnotherVCButton)
        createAnotherVCButton.translatesAutoresizingMaskIntoConstraints = false
        createAnotherVCButton.topAnchor.constraint(equalTo: self.floatingView.bottomAnchor).isActive = true
        createAnotherVCButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        createAnotherVCButton.widthAnchor.constraint(equalToConstant: 250.0).isActive = true
        createAnotherVCButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        createAnotherVCButton.setTitle("Go To Second Video", for: .normal)
        createAnotherVCButton.addTarget(self, action: #selector(createAnotherVC), for: .touchUpInside)
        
        
        MSPlayerConfig.playerPanSeekRate = 0.5
        MSPlayerConfig.playerBrightnessChangeRate = 2.0
        MSPlayerConfig.playerVolumeChangeRate = 0.5
        let asset = MSPlayerResource(url: URL(string: "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8")!)
        
        if let player = floatingView as? MSPlayer {
            player.setVideoBy(asset)
        }
        
        // setup popNav gesture
        let target = self.navigationController?.interactivePopGestureRecognizer?.delegate
        let pan = UIPanGestureRecognizer(target: target,
                                         action: Selector(("handleNavigationTransition:")))
        pan.delegate = self
        self.view.addGestureRecognizer(pan)
        //同时禁用系统原先的侧滑返回功能
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = true
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.floatingController?.closeFloatingVC = { [weak self] in
           
        }
        
        self.floatingController?.shrinkFloatingVC = { [weak self] in
            if let player = self?.floatingView as? MSPlayer {
                player.closeControlViewAndRemoveGesture()
            }
            self?.createAnotherVCButton.isHidden = true
        }
        
        self.floatingController?.expandFloatingVC = { [weak self] in
            if let player = self?.floatingView as? MSPlayer {
                player.openControlViewAndSetGesture()
            }
            self?.createAnotherVCButton.isHidden = false
        }
        
        self.floatingController?.setToCurrentFloatingVC(self)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        } else {
            return true
        }
    }
    
    func createAnotherVC() {
        let floatingPlayerVC = FloatingPlayerViewController2()
        MSFloatingController.shared().showWithNav(true, floatableVC: floatingPlayerVC)
    }
    
    
    deinit {
        print("class", self.classForCoder, "dealloc")
    }
}
