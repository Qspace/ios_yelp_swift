//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var searchBar = UISearchBar()
    var searchActive : Bool = false

    var currentFilter = [String : AnyObject]()
    var businesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.addSubview(searchBar)
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.delegate = self

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        //        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
        //            self.businesses = businesses
        //
        //            for business in businesses {
        //                println(business.name!)
        //                println(business.address!)
        //            }
        //        })
        
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            //            for business in businesses {
            //                print(business.name!)
            //                print(business.address!)
            //            }
        }
        print("After View Did Load")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Handle search behavior
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let searchTerm = searchBar.text
        var newFilter = currentFilter
        newFilter["term"] = searchTerm ?? ""
        loadBusineesWithFilter(newFilter)
    }
    ///////////////////////////////////////////////////////////////////////////////////
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (businesses != nil) {
            return businesses.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print("Prepare for segueeee")
        
        let navigationController = segue.destinationViewController as! UINavigationController
        
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func filersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        loadBusineesWithFilter(filters)
    }
    func loadBusineesWithFilter(filters: [String : AnyObject]) {
        currentFilter = filters
        let categories = filters["categories"] as? [String]
        var deal = filters["deal"] as? Bool
        let sortTypeStr = filters["sort"] as? String
        print("sortTypeStr",sortTypeStr)
        let sortType = Business.getSortTypeFromString(sortTypeStr)
        let distance = filters["distance"] as? Float
        
        var term: String?
        if !searchBar.text!.isEmpty {
            term = searchBar.text
        }
        else {
            term = "Restaurant"
        }
        
        
        
        
        print(categories)
        
        Business.searchWithTerm(term!, sort: sortType , categories: categories , deals: deal, distance:  distance) {
            (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
        //        Business.searchWithTerm("Restaurant", sort: nil, categories: categories, deals: nil) { (businesses: [Business]!, error: NSError!) -> Void in
        //            self.businesses = businesses
        //            self.tableView.reloadData()
        //        }
 
    }
    
}
