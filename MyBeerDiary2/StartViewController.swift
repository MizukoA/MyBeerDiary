//
//  StartViewController.swift
//  MyBeerDiary2
//
//  Created by 青柳瑞子 on 2018/08/19.
//  Copyright © 2018年 青柳瑞子. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    //    var diaries: [[String: String]]? = [[String: String]]()
    

    @IBOutlet weak var diaryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        // Do any additional setup after loading the view.
        //        drinkLabel.text = oldDrinkSet[index]["drink"]
        //
        //        let drinkSet = ["date": date, "drink": drink, "place": place]
        //
        //        let oldDrinkSet = UserDefaults.standard.array(forKey:)
        //            oldDrinkSet.append()
        //        let newDrinkSet = oldDrinkSet.append()
        //
        //        let oldDrinkSet = UserDefaults.standard.array(forKey:)
        //
        //        let drinkSet[String: Any] = ["date": date, "drink": drink, "place": place ]
        //
        //        let newDrinkSet = oldDrinkSet.append()
        //
        //        UserDefaults.set(forKey)
        //
        //        let oldDrinkSet = UserDefaults.standard.array(forKey:)
        //
        //        oldDrinkSet[0].drink
        //        drinkLabel.text = oldDrinkSet[index].drink
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        diaries = UserDefaults.standard.array(forKey: "diary") as? [[String: String]]
        //        diaryTableView.reloadData()
        
        
        
        
        //        let date = UserDefaults.standard.object(forKey: "date") as? Date
        //        let drink = UserDefaults.standard.string(forKey: "drink")
        //        let place = UserDefaults.standard.string(forKey: "place")
        //
        //        print("aaa", date, drink, place)
        
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            guard let data = sender as? DiaryNode else {
//                return
//            }
//            let viewController = segue.destination as! ViewController
//            viewController.data = data
//        }
//    }
    
    
}





extension StartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let _nodes = diary.nodes else {
            print("diary empty")
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryTableViewCell", for: indexPath) as! DiaryTableViewCell
        
        //        cell.dateLabei.text = diaries?[indexPath.row]["myDate"]
        //// ここにLabelをかく
        //        cell.drinkLabel.text = diaries?[indexPath.row]["myDrink"]
        //        cell.placeLabel.text = diaries?[indexPath.row]["myPlace"]
        //        cell.textLabel?.text = diaries?[indexPath.row]["myDate"]
        //        cell.detailTextLabel?.text = "bbb"
        
        
        cell.dateLabei.text = _nodes[indexPath.row].date
        cell.drinkLabel.text = _nodes[indexPath.row].drink
        cell.placeLabel.text = _nodes[indexPath.row].place
        
        
        cell.imageLabel?.image = UIImage(named: "launchlogo")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _nodes = diary.nodes else {
            print("diary empty")
            return 0
        }
        return _nodes.count
    }
    
    
}

extension StartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tap")
        
        //        let detailVC = ViewController()
        //        self.navigationController?.pushViewController(detailVC, animated: true)
        guard let _nodes = diary.nodes else {
            print("diary empty")
            return
        }
        let node = _nodes[indexPath.row]
        self.performSegue(withIdentifier: "showDetail", sender: node)
        
    }
    
}
