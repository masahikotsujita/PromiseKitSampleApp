//
//  ViewController.swift
//  PromiseKitSampleApp
//
//  Created by 辻田晶彦 on 2015/09/26.
//  Copyright © 2015年 Masahiko Tsujita. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    let errorDomain = "jp.tsujitamasahiko.PromiseKitSampleApp.ViewController.ErrorDomain"
    enum ErrorCode: Int {
        case InvalidResponseData
    }
    
    @IBAction func loadWebPage(sender: UIButton) {
        guard let url = self.urlField.text else {
            return
        }
        if self.urlField.isFirstResponder() {
            self.urlField.resignFirstResponder()
        }
        Promise<String> { (fulfill, reject) -> Void in
            request(.GET, url).responseString(completionHandler: { (request, response, result) -> Void in
                if let html = result.value {
                    fulfill(html)
                } else {
                    reject(NSError(domain: self.errorDomain, code: ErrorCode.InvalidResponseData.rawValue, userInfo: nil))
                }
            })
        }.then { (html) in
            self.webView.loadHTMLString(html, baseURL: NSURL(string: url))
        }.report { (error) in
            let alert = UIAlertController(title: "Error", message: "Failed to loading page: \(self.urlField.text)", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        }
    }

}
