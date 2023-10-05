//
//  ContentView.swift
//  BudgetwiseDemo
//
//  Created by Ben Ashkenazi on 10/3/23.
//

import SwiftUI

struct ContentView: View {
    //popover toggle
    @State private var showAddNewItem = false
    //picker values for popover
    @State var selectedCategory = "Food"
    @State var selectedTransaction = "Add"
    @State var amount = 0.0
    
    var subGray = Color(red: 112.0/255, green: 112.0/255, blue: 112.0/255)
    var lightGray = Color(red: 221.0/255, green: 221.0/255, blue: 221.0/255)
    var titleGreen = Color(red: 83.0/255, green: 190.0/255, blue: 114.0/255)
    var subGreen = Color(red: 230.0/255, green: 246.0/255, blue: 234.0/255)
    
    //Colors per each category
    var barColors = [
        "Food": Color(red: 33.0/255, green: 59.0/255, blue: 128.0/255),
        "Shopping": Color(red: 55.0/255, green: 107.0/255, blue: 188.0/255),
        "Transportation": Color(red: 254.0/255, green: 185.0/255, blue: 2.0/255),
        "Education": Color(red: 70.0/255, green: 190.0/255, blue: 198.0/255)]
    
    //formatter for number entry in popover
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    @State private var budgets: [Budget] = []
    
    
    var body: some View {
        GeometryReader{ geometry in
            VStack {
                //Top titles
                Text("October 2023")
                    .foregroundStyle(titleGreen)
                    .background(subGreen)
                    .padding()
                HStack{
                    VStack{
                        Text("Spent")
                            .foregroundStyle(subGray)
                            .fontWeight(.bold)
                        Text(String(format:"$%2.0f", (getTotals(budgets: budgets)[0])))
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    Divider()
                        .frame(maxHeight: UIScreen.screenHeight*0.05)
                        .padding()
                    VStack{
                        Text("Available")
                            .foregroundStyle(subGray)
                            .fontWeight(.bold)
                        Text(String(format:"$%2.0f", (getTotals(budgets: budgets)[1])))
                            .foregroundStyle(titleGreen)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    Divider()
                        .frame(maxHeight: UIScreen.screenHeight*0.05)
                        .padding()
                    VStack{
                        Text("Budget")
                            .foregroundStyle(subGray)
                            .fontWeight(.bold)
                        Text(String(format:"$%2.0f", (getTotals(budgets: budgets)[2])))
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                HStack {
                    //Progress/Amount spent bar
                    Spacer()
                    
                    ZStack {
                        //background bar
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 15, bottomLeading: 15, bottomTrailing: 15, topTrailing: 15))
                            .fill(lightGray)
                            .frame(width: UIScreen.screenWidth*0.7, height: UIScreen.screenHeight*0.05)
                    
                        //Color segments
                        HStack(spacing: 0) {
                            ForEach(budgets) { bud in
                                UnevenRoundedRectangle(cornerRadii: .init(
                                    topLeading: getCornerRounding(bud: bud)[0],
                                    bottomLeading: getCornerRounding(bud: bud)[0], bottomTrailing: getCornerRounding(bud: bud)[1], topTrailing: getCornerRounding(bud: bud)[1]
                                ))
                                .fill(barColors[bud.name] ?? .black)
                                .frame(width: getCumulativeWidth(bud: bud, totalSize: getTotals(budgets: budgets)[2]),
                                       height: UIScreen.screenHeight*0.05)
                            }
                            
                            Spacer()
                        }.padding(.leading,50)
                     
                    }
                    
                    Spacer()
                }
                
                //Budget Category tabs
                ZStack{
                    List($budgets, id: \.id) { budBinding in
                        let bud = budBinding.wrappedValue
                        VStack{
                            //Name and title
                            HStack{
                                VStack{
                                    Image(systemName: (bud.imageName))
                                        .imageScale(.large)
                                        .foregroundColor(barColors[bud.name] ?? .black)
                                        .font(.title)
                                        .foregroundStyle(.tint)
                                }
                                VStack{
                                    Text(bud.name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    
                                    Group{
                                        Text("spent ")
                                        +
                                        Text(String(format:"$%2.0f", bud.amountSpent)
                                        ).foregroundStyle(titleGreen)
                                        +
                                        Text(String(format:" of $%3.0f", bud.amountBudgeted))
                                    }
                                    
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(subGray)
                                    .fontWeight(.bold)
                                }
                                Spacer()
                                //Money left
                                VStack{
                                    Text(String(format:"$%2.0f", (bud.amountBudgeted-bud.amountSpent)))
                                        .foregroundStyle(titleGreen)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text("left")
                                }
                            }
                            
                            
                            ZStack{
                                //gray background bar
                                Divider()
                                    .frame(maxWidth: UIScreen.screenWidth*(0.65), maxHeight: 6)
                                    .overlay(.gray)
                                
                                HStack{
                                    //Front colored bar
                                    Divider()
                                        .frame(maxWidth: UIScreen.screenWidth*(0.65)*(bud.amountSpent/bud.amountBudgeted), maxHeight: 6)
                                        .overlay(barColors[bud.name] ?? .black)
                                    Spacer()
                                }
                                
                            }
                        }.padding()
                        
                    }.scrollContentBackground(.hidden)
                    
                    Spacer()
                    VStack{
                        Spacer()
                        HStack{
                            Spacer(minLength: UIScreen.screenWidth*0.8)
                            Button {
                                //open budget addition popover view
                                showAddNewItem = true
                            } label: {
                                Image("floating")
                                    .padding(.top)
                                    .frame(alignment: .trailing)
                            }
                            Spacer()
                        }
                    }
                }
                Spacer()
                //bottom button placeholder
                Image("Main Component Menu")
                    .resizable()
                    .frame(width: UIScreen.screenWidth*0.95, height: 80)
                    .alignmentGuide(.bottom) { d in
                        d[VerticalAlignment.bottom]
                    }
                    .padding(.bottom, -geometry.safeAreaInsets.bottom - 8)
            }
            .popover(isPresented: $showAddNewItem) { //popover view
                VStack{
                    List {
                        Picker("Choose Category", selection: $selectedCategory) {
                            Text("Food").tag("Food")
                            Text("Shopping").tag("Shopping")
                            Text("Transportation").tag("Transportation")
                            Text("Education").tag("Education")
                        }
                        .padding()
                        
                        Picker("Type of Transaction", selection: $selectedTransaction) {
                            Text("Make a Purchase").tag("Purchase")
                            Text("Add Money").tag("Add")
                        }
                        .padding()
                        
                        TextField("Enter your score", value: $amount, formatter: formatter)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                    }
                    Button(action: updateBudget, label: {
                        Text("Submit")
                    })
                }
            }
        } .onAppear{
            var userArray = getUserArray()
            if(userArray.isEmpty){
                print("We got nothing")
                budgets =  [
                    Budget(name: "Food", imageName: "fork.knife.circle.fill", amountSpent: 75.0, amountBudgeted: 100.0),
                    Budget(name: "Shopping", imageName: "cart.circle.fill", amountSpent: 20.0, amountBudgeted: 100.0),
                    Budget(name: "Transportation", imageName: "car.circle.fill", amountSpent: 40.0, amountBudgeted: 100.0),
                    Budget(name: "Education", imageName: "graduationcap.circle.fill", amountSpent: 90.0, amountBudgeted: 100.0),
                    
                ]
            }else{
                print("We got something \(userArray)")
                budgets = userArray
            }
        }
    }
    //iterates through budget, updating the one that was changed
    func updateBudget(){
        for i in (0...budgets.count-1) {
            if(budgets[i].name == selectedCategory){
                if(selectedTransaction == "Purchase"){
                    budgets[i].amountSpent += amount
                    print(budgets[i].name+" spent this much \(amount)")
                }else{
                    budgets[i].amountBudgeted += amount
                    print(budgets[i].name+" added this much \(amount)")
                }
            }
        }
        //stores in user default
        storeNewUserArray()
    }
    //returns total spent, left and budgeted
    func getTotals(budgets: [Budget])->[Double]{
        var totalSpent = 0.0
        var totalBudget = 0.0
        for bud in budgets{
            totalSpent += bud.amountSpent
            totalBudget += bud.amountBudgeted
        }
        return [totalSpent, totalBudget-totalSpent, totalBudget]
    }
    //returns cumulative width for segments
    func getCumulativeWidth(bud: Budget, totalSize: Double)->Double{
        let newSize = (bud.amountSpent/totalSize)*UIScreen.screenWidth*0.8
        return newSize
    }
    //rounds corners of first and last segment
    func getCornerRounding(bud:Budget)->[Double]{
        var rounding = [0.0,0.0]
        if(bud.name == "Food"){
            rounding = [15.0,0.0]
        }else if (bud.name=="Education"){
            rounding = [0.0,15.0]
        }
        return rounding
    }
    //stores budgets in user defaults
    func storeNewUserArray(){
        print("Saved!")
        UserDefaults.standard.set(try? PropertyListEncoder().encode(budgets), forKey:"budgets")
    }
    //gets stored data from user default
    func getUserArray()->[Budget]{
        if let data = UserDefaults.standard.value(forKey:"budgets") as? Data {
            
            let budgets2 = (try? PropertyListDecoder().decode(Array<Budget>.self, from: data)) ?? []
            print("Loaded! \(budgets2)")
            return budgets2
        }else{
            print("Failed to load")
            return  []
        }
        
        
    }
}



#Preview {
    ContentView()
}

extension Binding {
    func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
