//================================
import UIKit
//================================
class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    //----
    @IBOutlet weak var tabview: UITableView!
    //----
    @IBOutlet weak var champEng: UITextField!
    @IBOutlet weak var champFr: UITextField!
    //----
    @IBOutlet weak var displayTraduction: UILabel!
    @IBOutlet weak var displayTheme: UILabel!
    //----
    @IBOutlet weak var buttonEng: UIButton!
    @IBOutlet weak var buttonFr: UIButton!
    //----
    @IBOutlet weak var addTraduction: UIButton!
    //----
    var arrButtons: [UIButton]!
    //----
    var dictStrings = [String : String]()
    var flagBool = 1
    var arrayChampEng = [String]()
    var arrayChampFr = [String]()
    var sortedTuple = [(key: String,value: String)]()
    //---- Constante objet defObj
    let defObj = UserDefaultsManager()
    //----
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        //----
        arrButtons = [buttonEng, buttonFr]
        //----
        manageUserDef()
        sortTuple()
    }
    //----
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // Nombre d'éléments dans sortedTuple
            return sortedTuple.count
    }
    //----
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: UITableViewCell = UITableViewCell(style:
                                        UITableViewCellStyle.default,
                                        reuseIdentifier: nil)
            let motsAnglais = (sortedTuple[indexPath.row].key)
            let motsFrancais = (sortedTuple[indexPath.row].value)
            if flagBool == 1 {
                cell.textLabel?.text = "\(motsAnglais)"
            } else {
                cell.textLabel?.text = "\(motsFrancais)"
            }
            return cell
    }
    //----
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            displayTraduction.alpha = 0.5
            var temp = Array(dictStrings.keys)
            let key = temp[indexPath.item]
            let index = dictStrings.index(where: {t in
                return t.key == key
            })
            dictStrings.remove(at: index!)
            sortedTuple = dictStrings.sorted(by: {$0.0.lowercased() < $1.0.lowercased()})
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            UserDefaults.standard.set(dictStrings, forKey: "mots")
            displayTraduction.text = ""
        }
    }
    //----
    fileprivate func sortTuple() {
        if flagBool == 1 {
            sortedTuple = dictStrings.sorted(by: {$0.0.lowercased() < $1.0.lowercased()})
        } else {
            sortedTuple = dictStrings.sorted(by: {$0.1.lowercased() < $1.1.lowercased()})
        }
    }
    //----
    @IBAction func ajouterTraduction(_ sender: UIButton) {
        if (champFr.text == "" || champEng.text == "") {
            return
        }
        for a in dictStrings {
            if (champFr.text == a.value) || (champEng.text == a.key) {
                champFr.text = ""
                champEng.text = ""
                return
            }
        }
        // Ajouter champEng et champFr à dictStrings
        dictStrings[(champEng.text!)] = String(champFr.text!)
        sortTuple()
        // Sauvegarder dictSalaires avec clé "mots"
        defObj.setKey(theValue: dictStrings as AnyObject, theKey: "mots")
        // Exécution méthode viderLesChamps()
        viderLesChamps()
        tabview.reloadData()
    }
    //----
    func viderLesChamps() {
        // Vider champEng
        champEng.text = ""
        // Vider champFr
        champFr.text = ""
    }
    //----
    func manageUserDef() {
        if defObj.doesKeyExist(theKey: "mots") {
            // dictStrings égale à la valeur sauvegardée avec la clé "mots"
            dictStrings = defObj.getValue(theKey: "mots") as! [String: String]
        }
    }
    //----
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //----
    @IBAction func anglaisFrancaisButton(_ sender: UIButton) {
        if sender.alpha == 1.0 {
            return
        }
        for button in arrButtons {
            if button.alpha == 1.0 {
                flagBool = 1
                champEng.placeholder = "English word"
                champFr.placeholder = "French word"
                addTraduction.setTitle("ADD", for: UIControlState.normal)
                button.alpha = 0.5
                button.backgroundColor = UIColor.red
                tabview.reloadData()
                displayTraduction.text = ""
                displayTheme.text = "THEME: Food"
                sortTuple()
            } else {
                flagBool = 0
                champEng.placeholder = "Anglais mot"
                champFr.placeholder = "Francais mot"
                addTraduction.setTitle("AJOUTER", for: UIControlState.normal)
                button.alpha = 1.0
                button.backgroundColor = UIColor.red
                tabview.reloadData()
                displayTraduction.text = ""
                displayTheme.text = "THÈME: Nourriture"
                sortTuple()
            }
        }
    }
    //----
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displayTraduction.alpha = 1
        if flagBool == 1 {
            displayTraduction.text = sortedTuple[indexPath.row].value
        } else {
            displayTraduction.text = sortedTuple[indexPath.row].key
        }
    }
    //----
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    //----
    @objc func dismissKeyboard() {
        view.endEditing(true)
        displayTraduction.alpha = 0.5
        displayTraduction.text = ""
    }
    //----
}
