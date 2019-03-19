//
//  ViewController.swift
//  PDFGeneratorDemo
//
//  Created by Dhanesh Gosai on 17/03/19.
//  Copyright © 2019 My Future Partner. All rights reserved.
//

import UIKit
import PDFGenerator

class ViewController: UIViewController {

    @IBOutlet weak var scrPDFView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerView.layer.borderWidth = 2.0
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func btnPdfGenerateClicked(_ sender: Any) {
        self.generatePDF()
    }
    func generatePDF(){
        
        let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending("sample1.pdf"))
        // outputs as Data
        do {
            let data = try PDFGenerator.generated(by: [scrPDFView])
            try data.write(to: dst, options: .atomic)
        } catch (let error) {
            print(error)
        }
        
    }


}

