//
//  FiltersViewController.swift
//  Yelp
//
//  Created by MAC on 11/19/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate{
    optional func filersViewController(filtersViewController :FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, OptionCellDelegate {
    
    // Define all field in filter view
    let DEAL_FIELD = 0
    let DISTANCE_FIELD = 1
    let SORT_FIELD = 2
    let CATEGORY_FIELD = 3
    let NUM_FIELD = 4
    
    var expandSortCellState = false
    var expandDistanceCellState = false
    
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    var filters = [String : AnyObject]()
    var categories: [[String:String]]!
    var switchState = [Int: Bool]()
    
    var distanceArray : [Float?]!
    var sortTypeArray : [String?]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK init vaue for filter field
        categories = yelpCategories()
        distanceArray = [nil, 0.3, 1, 5, 20]
        sortTypeArray = ["Auto", "Best Match", "Distance", "Rating"]
        
        // reset option cell expandable status
        expandSortCellState = false
        expandDistanceCellState = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //        tableView.rowHeight = UITableViewAutomaticDimension
        //        tableView.estimatedRowHeight = 100
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return NUM_FIELD
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case DEAL_FIELD:
            return ""
        case DISTANCE_FIELD:
            return "Distance"
        case SORT_FIELD:
            return "Sort by"
        case CATEGORY_FIELD:
            return "Category"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case DEAL_FIELD:
            return 1
        case DISTANCE_FIELD:
            return distanceArray.count
        case SORT_FIELD:
            return 4
        case CATEGORY_FIELD:
            return categories.count
        default:
            break
        }
        return 0 // never jump to this case
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case SORT_FIELD:
            if expandSortCellState == false {
                switch indexPath.row {
                case 0:
                    return 50
                case 1:
                    return 0
                case 2:
                    return 0
                case 3:
                    return 0
                default:
                    return 0
                }
            }
            else {
                return 50
            }
        case DISTANCE_FIELD:
            if expandDistanceCellState == false {
                print("Expand false")
                switch indexPath.row {
                case 0:
                    return 50
                case 1:
                    return 0
                case 2:
                    return 0
                case 3:
                    return 0
                default:
                    return 0
                }
            } else {
                return 50
            }
        default:
            return 50
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case DEAL_FIELD:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            cell.switchLabel.text = "Offering a Deal"
            cell.delegate = self
            cell.onSwitch.on = filters["deal"] as? Bool ?? false
            return cell
            
        case DISTANCE_FIELD:
            let cell = tableView.dequeueReusableCellWithIdentifier("OptionCell", forIndexPath: indexPath) as! OptionCell
            cell.delegate = self
            print("Distance",indexPath.row)
            var fieldName: String?
            var iconImg: UIImage?
            if expandDistanceCellState == false {
                iconImg = UIImage(named: "Expand")
            }
            if expandDistanceCellState == true {
                
                if filters["distance"] as! Float? == distanceArray[indexPath.row] {
                    iconImg = UIImage(named: "Checked")
                } else {
                    iconImg = nil
                }
                
                // Set label for each cell
                if indexPath.row == 0 {
                    fieldName = "Auto"
                }
                else {
                    fieldName =  String(format: "%g", distanceArray[indexPath.row]!) + " mile"
                }
            }
            
            cell.showOptionCellView(fieldName,iconImg: iconImg)
            return cell
            
        case SORT_FIELD:
            let cell = tableView.dequeueReusableCellWithIdentifier("OptionCell", forIndexPath: indexPath) as! OptionCell
            cell.delegate = self
            var fieldName: String?
            var iconImg: UIImage?
            if expandSortCellState == false {
                iconImg = UIImage(named: "Expand")
            }
            if expandSortCellState == true {
                
                if filters["sort"] as! String? == sortTypeArray[indexPath.row] {
                    iconImg = UIImage(named: "Checked")
                } else {
                    iconImg = nil
                }
                
                // Set label for each cell
                if indexPath.row == 0 {
                    fieldName = "Auto"
                }
                else {
                    fieldName =  sortTypeArray[indexPath.row]
                }
            }
            cell.showOptionCellView(fieldName,iconImg: iconImg)
            return cell
        case CATEGORY_FIELD:
            print("reload switch state")
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            cell.switchLabel.text = categories[indexPath.row]["name"]
            // Detect switch change value event
            cell.delegate = self
            cell.onSwitch.on = switchState[indexPath.row] ?? false
            //        print("cell \(indexPath.row)",cell.onSwitch.on)
            
            
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func switchCell(switchCell: SwitchCell, didChangeVaue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        switch indexPath.section {
        case DEAL_FIELD:
            filters["deal"] = value
            break
        case CATEGORY_FIELD:
            print("switch state change ",indexPath.row)
            switchState[indexPath.row] = value
            break
        default:
            break
            
        }
        tableView.reloadData()
    }
    
    func optionCell(optionCell: OptionCell, onRowSelect selected: Bool) {
        //        let indexPath = tableView.indexPathForCell(optionCell)'
        
        let index = tableView.indexPathForCell(optionCell)
        if index != nil {
            switch index!.section {
            case DISTANCE_FIELD:
                if selected == true {
                    expandDistanceCellState = true
                    filters["distance"] = distanceArray[index!.row]
                    //                    optionCell.setIcon(UIImage(named: "Checked.png"))
                    tableView.reloadData()
                }
                break
            case SORT_FIELD:
                if selected == true {
                    expandSortCellState = true
                    filters["sort"] = optionCell.fieldLabel.text
                    //                    optionCell.setIcon(UIImage(named: "Checked.png"))
                    tableView.reloadData()
                }
                
                break
            default:
                break
            }
            
        }
        
    }
    
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filCategories = [String]()
        for (row,isSelected) in switchState {
            if isSelected {
                print("row Selected",row)
                filCategories.append(categories[row]["code"]!)
            }
        }
        if filCategories.count > 0 {
            filters["categories"] = filCategories
        }
        
        
        delegate?.filersViewController?(self, didUpdateFilters: filters)
    }
    
    func yelpCategories() -> [[String:String]] {
        let categories = [["name" : "Afghan", "code": "afghani"],
            ["name" : "African", "code": "african"],
            ["name" : "American, New", "code": "newamerican"],
            ["name" : "American, Traditional", "code": "tradamerican"],
            ["name" : "Arabian", "code": "arabian"],
            ["name" : "Argentine", "code": "argentine"],
            ["name" : "Armenian", "code": "armenian"],
            ["name" : "Asian Fusion", "code": "asianfusion"],
            ["name" : "Asturian", "code": "asturian"],
            ["name" : "Australian", "code": "australian"],
            ["name" : "Austrian", "code": "austrian"],
            ["name" : "Baguettes", "code": "baguettes"],
            ["name" : "Bangladeshi", "code": "bangladeshi"],
            ["name" : "Barbeque", "code": "bbq"],
            ["name" : "Basque", "code": "basque"],
            ["name" : "Bavarian", "code": "bavarian"],
            ["name" : "Beer Garden", "code": "beergarden"],
            ["name" : "Beer Hall", "code": "beerhall"],
            ["name" : "Beisl", "code": "beisl"],
            ["name" : "Belgian", "code": "belgian"],
            ["name" : "Bistros", "code": "bistros"],
            ["name" : "Black Sea", "code": "blacksea"],
            ["name" : "Brasseries", "code": "brasseries"],
            ["name" : "Brazilian", "code": "brazilian"],
            ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
            ["name" : "British", "code": "british"],
            ["name" : "Buffets", "code": "buffets"],
            ["name" : "Bulgarian", "code": "bulgarian"],
            ["name" : "Burgers", "code": "burgers"],
            ["name" : "Burmese", "code": "burmese"],
            ["name" : "Cafes", "code": "cafes"],
            ["name" : "Cafeteria", "code": "cafeteria"],
            ["name" : "Cajun/Creole", "code": "cajun"],
            ["name" : "Cambodian", "code": "cambodian"],
            ["name" : "Canadian", "code": "New)"],
            ["name" : "Canteen", "code": "canteen"],
            ["name" : "Caribbean", "code": "caribbean"],
            ["name" : "Catalan", "code": "catalan"],
            ["name" : "Chech", "code": "chech"],
            ["name" : "Cheesesteaks", "code": "cheesesteaks"],
            ["name" : "Chicken Shop", "code": "chickenshop"],
            ["name" : "Chicken Wings", "code": "chicken_wings"],
            ["name" : "Chilean", "code": "chilean"],
            ["name" : "Chinese", "code": "chinese"],
            ["name" : "Comfort Food", "code": "comfortfood"],
            ["name" : "Corsican", "code": "corsican"],
            ["name" : "Creperies", "code": "creperies"],
            ["name" : "Cuban", "code": "cuban"],
            ["name" : "Curry Sausage", "code": "currysausage"],
            ["name" : "Cypriot", "code": "cypriot"],
            ["name" : "Czech", "code": "czech"],
            ["name" : "Czech/Slovakian", "code": "czechslovakian"],
            ["name" : "Danish", "code": "danish"],
            ["name" : "Delis", "code": "delis"],
            ["name" : "Diners", "code": "diners"],
            ["name" : "Dumplings", "code": "dumplings"],
            ["name" : "Eastern European", "code": "eastern_european"],
            ["name" : "Ethiopian", "code": "ethiopian"],
            ["name" : "Fast Food", "code": "hotdogs"],
            ["name" : "Filipino", "code": "filipino"],
            ["name" : "Fish & Chips", "code": "fishnchips"],
            ["name" : "Fondue", "code": "fondue"],
            ["name" : "Food Court", "code": "food_court"],
            ["name" : "Food Stands", "code": "foodstands"],
            ["name" : "French", "code": "french"],
            ["name" : "French Southwest", "code": "sud_ouest"],
            ["name" : "Galician", "code": "galician"],
            ["name" : "Gastropubs", "code": "gastropubs"],
            ["name" : "Georgian", "code": "georgian"],
            ["name" : "German", "code": "german"],
            ["name" : "Giblets", "code": "giblets"],
            ["name" : "Gluten-Free", "code": "gluten_free"],
            ["name" : "Greek", "code": "greek"],
            ["name" : "Halal", "code": "halal"],
            ["name" : "Hawaiian", "code": "hawaiian"],
            ["name" : "Heuriger", "code": "heuriger"],
            ["name" : "Himalayan/Nepalese", "code": "himalayan"],
            ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
            ["name" : "Hot Dogs", "code": "hotdog"],
            ["name" : "Hot Pot", "code": "hotpot"],
            ["name" : "Hungarian", "code": "hungarian"],
            ["name" : "Iberian", "code": "iberian"],
            ["name" : "Indian", "code": "indpak"],
            ["name" : "Indonesian", "code": "indonesian"],
            ["name" : "International", "code": "international"],
            ["name" : "Irish", "code": "irish"],
            ["name" : "Island Pub", "code": "island_pub"],
            ["name" : "Israeli", "code": "israeli"],
            ["name" : "Italian", "code": "italian"],
            ["name" : "Japanese", "code": "japanese"],
            ["name" : "Jewish", "code": "jewish"],
            ["name" : "Kebab", "code": "kebab"],
            ["name" : "Korean", "code": "korean"],
            ["name" : "Kosher", "code": "kosher"],
            ["name" : "Kurdish", "code": "kurdish"],
            ["name" : "Laos", "code": "laos"],
            ["name" : "Laotian", "code": "laotian"],
            ["name" : "Latin American", "code": "latin"],
            ["name" : "Live/Raw Food", "code": "raw_food"],
            ["name" : "Lyonnais", "code": "lyonnais"],
            ["name" : "Malaysian", "code": "malaysian"],
            ["name" : "Meatballs", "code": "meatballs"],
            ["name" : "Mediterranean", "code": "mediterranean"],
            ["name" : "Mexican", "code": "mexican"],
            ["name" : "Middle Eastern", "code": "mideastern"],
            ["name" : "Milk Bars", "code": "milkbars"],
            ["name" : "Modern Australian", "code": "modern_australian"],
            ["name" : "Modern European", "code": "modern_european"],
            ["name" : "Mongolian", "code": "mongolian"],
            ["name" : "Moroccan", "code": "moroccan"],
            ["name" : "New Zealand", "code": "newzealand"],
            ["name" : "Night Food", "code": "nightfood"],
            ["name" : "Norcinerie", "code": "norcinerie"],
            ["name" : "Open Sandwiches", "code": "opensandwiches"],
            ["name" : "Oriental", "code": "oriental"],
            ["name" : "Pakistani", "code": "pakistani"],
            ["name" : "Parent Cafes", "code": "eltern_cafes"],
            ["name" : "Parma", "code": "parma"],
            ["name" : "Persian/Iranian", "code": "persian"],
            ["name" : "Peruvian", "code": "peruvian"],
            ["name" : "Pita", "code": "pita"],
            ["name" : "Pizza", "code": "pizza"],
            ["name" : "Polish", "code": "polish"],
            ["name" : "Portuguese", "code": "portuguese"],
            ["name" : "Potatoes", "code": "potatoes"],
            ["name" : "Poutineries", "code": "poutineries"],
            ["name" : "Pub Food", "code": "pubfood"],
            ["name" : "Rice", "code": "riceshop"],
            ["name" : "Romanian", "code": "romanian"],
            ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
            ["name" : "Rumanian", "code": "rumanian"],
            ["name" : "Russian", "code": "russian"],
            ["name" : "Salad", "code": "salad"],
            ["name" : "Sandwiches", "code": "sandwiches"],
            ["name" : "Scandinavian", "code": "scandinavian"],
            ["name" : "Scottish", "code": "scottish"],
            ["name" : "Seafood", "code": "seafood"],
            ["name" : "Serbo Croatian", "code": "serbocroatian"],
            ["name" : "Signature Cuisine", "code": "signature_cuisine"],
            ["name" : "Singaporean", "code": "singaporean"],
            ["name" : "Slovakian", "code": "slovakian"],
            ["name" : "Soul Food", "code": "soulfood"],
            ["name" : "Soup", "code": "soup"],
            ["name" : "Southern", "code": "southern"],
            ["name" : "Spanish", "code": "spanish"],
            ["name" : "Steakhouses", "code": "steak"],
            ["name" : "Sushi Bars", "code": "sushi"],
            ["name" : "Swabian", "code": "swabian"],
            ["name" : "Swedish", "code": "swedish"],
            ["name" : "Swiss Food", "code": "swissfood"],
            ["name" : "Tabernas", "code": "tabernas"],
            ["name" : "Taiwanese", "code": "taiwanese"],
            ["name" : "Tapas Bars", "code": "tapas"],
            ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
            ["name" : "Tex-Mex", "code": "tex-mex"],
            ["name" : "Thai", "code": "thai"],
            ["name" : "Traditional Norwegian", "code": "norwegian"],
            ["name" : "Traditional Swedish", "code": "traditional_swedish"],
            ["name" : "Trattorie", "code": "trattorie"],
            ["name" : "Turkish", "code": "turkish"],
            ["name" : "Ukrainian", "code": "ukrainian"],
            ["name" : "Uzbek", "code": "uzbek"],
            ["name" : "Vegan", "code": "vegan"],
            ["name" : "Vegetarian", "code": "vegetarian"],
            ["name" : "Venison", "code": "venison"],
            ["name" : "Vietnamese", "code": "vietnamese"],
            ["name" : "Wok", "code": "wok"],
            ["name" : "Wraps", "code": "wraps"],
            ["name" : "Yugoslav", "code": "yugoslav"]]
        return categories
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
