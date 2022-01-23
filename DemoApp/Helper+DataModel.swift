//
//  StationData.swift
//  DemoApp
//
//  Created by Macbook on 23/01/22.
//
import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func load(url: URL) {
        if let image = imageCache.object(forKey: url.absoluteString as NSString){
            self.image = image
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCache.setObject(image, forKey:  url.absoluteString as NSString)
                        self?.image = image
                    }
                }
            }
        }
    }
}

struct Station {
    var ItemType: String = ""
    var StationId: String = ""
    var StationName: String = ""
    var LogoPl: String = ""
}

class ApiCall{
    
    func getStationListFrom(url: String,_ completion: @escaping (Bool,[Station]) -> ()) {
        var flag = false
        guard let url = URL(string:url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
                let parser = StationParser(data: data)
                if parser.parse() {
                    flag = true
                    DispatchQueue.main.async {
                        completion(flag,parser.stations)
                    }
                } else {
                    if let error = parser.parserError {
                        flag = false
                        DispatchQueue.main.async {
                            completion(flag,[])
                        }
                        print(error)
                    } else {
                        flag = false
                        DispatchQueue.main.async {
                            completion(flag,[])
                        }
                        print("Failed with unknown reason")
                    }
            }
           
        }
        task.resume()
    }
}
class StationParser: XMLParser {
    var stations: [Station] = []
    private var textBuffer: String = ""
    private var nextStation: Station? = nil
    override init(data: Data) {
        super.init(data: data)
        self.delegate = self
    }
}
extension StationParser: XMLParserDelegate {
   func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "Item":
            nextStation = Station()
        case "ItemType":
            textBuffer = ""
        case "StationId":
            textBuffer = ""
        case "StationName":
            textBuffer = ""
        case "LogoPl":
            textBuffer = ""
        default:
//            print("Ignoring \(elementName)")
            break
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "Item":
            if let station = nextStation {
                if station.ItemType == "Station" {
                    stations.append(station)
                }
            }
        case "ItemType":
            nextStation?.ItemType = textBuffer
            
        case "StationId":
            nextStation?.StationId = textBuffer
            
        case "StationName":
            nextStation?.StationName = textBuffer
            
        case "LogoPl":
            nextStation?.LogoPl = textBuffer
            
        default:
//            print("Ignoring \(elementName)")
            break
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        textBuffer += string
    }
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        guard let string = String(data: CDATABlock, encoding: .utf8) else {
            print("CDATA contains non-textual data, ignored")
            return
        }
        textBuffer += string
    }
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
        print("on:", parser.lineNumber, "at:", parser.columnNumber)
    }
}
