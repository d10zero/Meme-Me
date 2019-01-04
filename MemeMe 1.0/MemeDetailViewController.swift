//
//  MemeDetailViewController.swift
//  MemeMe 1.0
//
//  Created by Deena Tenzer on 1/15/18.
//  Copyright © 2018 Deena Tenzer. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        if(self.meme != nil){
            self.imageView!.image = self.meme.memedImage
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
