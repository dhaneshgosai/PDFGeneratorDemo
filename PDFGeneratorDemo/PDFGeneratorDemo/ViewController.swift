//
//  ViewController.swift
//  PDFGeneratorDemo
//
//  Created by Dhanesh Gosai on 17/03/19.
//  Copyright © 2019 My Future Partner. All rights reserved.
//

import UIKit
import PDFGenerator
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var scrPDFView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgMap: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerView.layer.borderWidth = 2.0
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func btnPdfGenerateClicked(_ sender: Any) {
        self.generatePDF()
    }
    func generatePDF(){
        
        self.view.endEditing(true)
        
        do {
            let view = try containerView.copyObject()!
            let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending("sample12.pdf"))
            // outputs as Data
            do {
                let data = try PDFGenerator.generated(by: [view])
                try data.write(to: dst, options: .atomic)
            } catch (let error) {
                print(error)
            }
        } catch {
            print("Error")
        }
    
        
//        createPdfFromView(aView: containerView, saveToDocumentsWithFileName: "TestPDF.pdf")
        
        
        
    }
    
    func createPdfFromView(aView: UIView, saveToDocumentsWithFileName fileName: String)
    {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil)
        UIGraphicsBeginPDFPage()
        
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return }
        
        aView.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let documentsFileName = documentDirectories + "/" + fileName
            debugPrint(documentsFileName)
            pdfData.write(toFile: documentsFileName, atomically: true)
        }
    }


}

extension UIView {
    
    func takeScreenshot() -> UIImage {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}

extension ViewController : MKMapViewDelegate {
    
    public func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        self.imgMap.image = self.mapView.takeScreenshot()
    }
}

//extension UIView
//{
//    func copyView<T: UIView>() -> T {
//
//        do {
//            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIView.self, from: NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)) as! T
//        } catch {
//            print("error")
//        }
//
//        return self as! T
//
//    }
//}

extension UIView {
    func copyObject<T:UIView>() throws -> T? {
        let data = try NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false)
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
    }
}
