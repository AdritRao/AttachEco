//
//  LearnMoreViewController.swift
//  AttachEcoApp
//
//  Created by Adrit Rao on 10/3/20.
//

import UIKit
import WebKit

class LearnMoreViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://climatekids.nasa.gov/")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func climateKidsTapped(_ sender: UIButton) {
        let url = URL(string: "https://climatekids.nasa.gov/")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    @IBAction func climateAdvancedTapped(_ sender: UIButton) {
        let url = URL(string: "https://climate.nasa.gov/")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
