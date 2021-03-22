//
//  ViewController.swift
//  Vegan russia search
//
//  Created by Владимир Дельгадильо on 25.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    
    private var stories: [Hit] = []
        
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(StoryTableViewCell.self, forCellReuseIdentifier: StoryTableViewCell.identifier)
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchRequest()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    func searchRequest () {
        let url = URL(string: "https://veganrussian.ru/api/search/")!
        var request = URLRequest(url: url);
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let json = try? JSONSerialization.data(withJSONObject: ["query": "oreo", "offset": 0], options: .fragmentsAllowed)
        request.httpBody = json
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "no data")
                return
            }
            
            let responseJson = try? JSONDecoder().decode(SearchResponse.self, from: data)
            if let response = responseJson {
                self.stories = response.hits
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        task.resume()
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryTableViewCell.identifier, for: indexPath) as! StoryTableViewCell
        cell.configure(with: stories[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

struct Hit: Codable {
    let feature_image: String
    let slug: String
    let title: String
}

struct SearchResponse: Codable {
    let hits: [Hit]
}
