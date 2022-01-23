//
//  ViewController.swift
//  DemoApp
//
//  Created by Macbook on 23/01/22.
//

import UIKit
class ViewController: UIViewController {

    var stringUrl = "http://phorus.vtuner.com/setupapp/phorus/asp/browsexml/navXML.asp?gofile=LocationLevelFourCityUS-North%20America-New%20York-ExtraDir-1-Inner-14&bkLvl=9237&mac=a8f58cd9758b710c43a7a63762e755947f83f0ad9194aa294bbaee55e0509e02&dlang=eng&fver=1.4.4.2299%20(20150604)&hw=CAP:%201.4.0.075%20MCU:%201.032%20BT:%200.002"
    @IBOutlet weak var urlTextField: UITextField!
    
    var indicatorView = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.frame = CGRect(x: (self.view.frame.width/2)-50, y:  (self.view.frame.height/2)-50, width: 100, height: 100)
        self.view.addSubview(indicatorView)
        self.indicatorView.isHidden = true
    }
    
    @IBAction func submitBtnAction(_ sender: UIButton) {
        let url = self.urlTextField.text ?? ""
        if url != "" {
            self.callApi(url: url)
        }else{
            self.callApi(url: stringUrl)
        }
    }
    func callApi(url:String){
        self.view.isUserInteractionEnabled = false
        self.indicatorView.isHidden = false
        self.indicatorView.startAnimating()
        ApiCall().getStationListFrom(url: url) { sucess, result in
            if sucess {
                print(result)
                self.indicatorView.isHidden = true
                self.indicatorView.stopAnimating()
                self.view.isUserInteractionEnabled = true
                var stationVC = StationList()
                stationVC.stationList = result
                self.navigationController?.pushViewController(stationVC, animated: true)
            }else{
                self.indicatorView.isHidden = true
                self.view.isUserInteractionEnabled = true
                self.indicatorView.stopAnimating()
                let alert = UIAlertController(title: "Alert", message: "Data not found", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

