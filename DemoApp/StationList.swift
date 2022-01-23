//
//  StationList.swift
//  DemoApp
//
//  Created by Macbook on 23/01/22.
//

import UIKit

class StationList: UIViewController {
    var url : String!
    var tableView = UITableView()
    var stationList : [Station] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Station List"
        self.tableView.frame = CGRect(x: 0, y:  0, width: (self.view.frame.width), height: (self.view.frame.height))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
    }
}

extension StationList : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stationList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        let model = self.stationList[indexPath.row]
        cell.textLabel?.text = model.StationName
        cell.detailTextLabel?.text = model.StationId
        if let url = URL(string: model.LogoPl)
        {
            cell.imageView?.load(url: url)
        }
        return cell
    }
}

