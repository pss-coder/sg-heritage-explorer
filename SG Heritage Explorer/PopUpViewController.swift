//
//  PopUpViewController.swift
//  SG Heritage Explorer
//
//  Created by VongolaKillerAir on 26/9/17.
//  Copyright © 2017 PawandeepSingh. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
    

    //MARK: Properties
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var labelDisplay: UILabel!//remove this later,just for testing
    
     var text:String! = "";
    var selectedHeritage:Heritage = Heritage(name: "", description: "",location: Location(latitude: 0, longtitude: 0,address:Location.Address(name: "", blockNum: "", roadName: "", building: "")));
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
    }
    
    // function which is triggered when handleTap is called
    func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
        if sender.view != popUpView
        {
            self.dismiss(animated: true, completion: nil);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    /**
     Any tap outside of the popup view will dimiss the popup
     */
//    override func touchesBegan(_ touches: Set<UITouch>,with event: UIEvent?) {
//        let touch: UITouch? = touches.first;
//        //location is relative to the current view
//        // do something with the touched point
////        if touch?.view != popUpView {
////            //popUpView.isHidden = true
////            self.dismiss(animated: true, completion: nil);
////           
////        }
//        //self.popUpView.isHidden = true;
//        self.dismiss(animated: false, completion: nil);
//    }
    
    
    
    /**
    Dismiss Button action
     */
    @IBAction func dismissBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
    
    //Start Quiz action
    @IBAction func startquizBtnAction(_ sender: Any) {
       
      // let LocationValue = labelDisplay.text
        //self.navigationController?.pushViewController(popupViewController, animated: true)
       performSegue(withIdentifier: "toQuizViewController", sender: nil)
        
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // == Storyboard ID 
        if (segue.identifier == "toQuizViewController"){
            if let destination = segue.destination as? QuizViewController {
                
                destination.passedTitle = labelDisplay.text;
                    //sender as? String
                
            }
        }
    }
    

}
