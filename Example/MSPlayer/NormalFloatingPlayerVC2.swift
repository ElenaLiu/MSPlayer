//
//  NormalFloatingPlayerVC2.swift
//  MSPlayer_Example
//
//  Created by Mason on 2018/6/4.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import MSPlayer

class NormalFloatingPlayerVC2: UIViewController, MSFloatableViewController, UIGestureRecognizerDelegate {
    var floatingPlayer: MSPlayer = MSPlayer()
    
    
    weak var floatingController: MSFloatingController? =  MSFloatingController.shared()
    
    lazy var player = MSPlayer()
    
    let createAnotherVCButton = UIButton(type: UIButton.ButtonType.system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        createAnotherVCButton.addTarget(self, action: #selector(createAnotherVC), for: .touchUpInside)
        self.setupPlayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.white
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.addSubview(player)
        player.translatesAutoresizingMaskIntoConstraints = false
        player.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        player.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        player.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        player.heightAnchor.constraint(equalTo: self.player.widthAnchor, multiplier: (9/16)).isActive = true
        
        self.view.addSubview(createAnotherVCButton)
        createAnotherVCButton.translatesAutoresizingMaskIntoConstraints = false
        createAnotherVCButton.topAnchor.constraint(equalTo: self.player.bottomAnchor).isActive = true
        createAnotherVCButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        createAnotherVCButton.widthAnchor.constraint(equalToConstant: 250.0).isActive = true
        createAnotherVCButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        createAnotherVCButton.setTitle("Go To Second Video", for: .normal)
    }
    
    func setupPlayer() {
        MSPlayerConfig.playerPanSeekRate = 0.5
        MSPlayerConfig.playerBrightnessChangeRate = 2.0
        MSPlayerConfig.playerVolumeChangeRate = 0.5
        let asset = MSPlayerResource(url: URL(string: "http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8")!)
        
        player.setVideoBy(asset)
        
        //MARK: - Do something when floatingVC being closed
        self.floatingController?.closeFloatingVC = { [weak self] in
            
        }
        
        //MARK: - Do something when floatingVC being shrinked
        self.floatingController?.shrinkFloatingVC = { [weak self] in
            self?.createAnotherVCButton.isHidden = true
        }
        
        //MARK: - Do something when floatingVC being expanded
        self.floatingController?.expandFloatingVC = { [weak self] in
            self?.createAnotherVCButton.isHidden = false
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            return false
        } else {
            return true
        }
    }
    
    @objc func createAnotherVC() {
        let floatingPlayerVC = NormalFloatingPlayerVC()
        MSFloatingController.shared().show(true, floatableVC: floatingPlayerVC)
    }
    
    deinit {
        print("class", self.classForCoder, "dealloc")
    }
}

