//
//  ContentView.swift
//  convertor
//
//  Created by Igor Florentino on 20/02/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var inputValue = 0.0
    @State private var inputUnit: Dimension = UnitLength.kilometers
    @State private var outputUnit: Dimension = UnitLength.miles
    @State private var selectedUnit = 0
    
    @FocusState private var inputIsFocused: Bool
    
    let conversions = ["Distance", "Mass", "Temperature", "Time"]
    let unitTypes = [
        [UnitLength.meters, UnitLength.kilometers, UnitLength.feet, UnitLength.yards, UnitLength.miles],
        [UnitMass.grams, UnitMass.kilograms, UnitMass.ounces, UnitMass.pounds],
        [UnitTemperature.celsius, UnitTemperature.fahrenheit, UnitTemperature.kelvin],
        [UnitDuration.hours, UnitDuration.minutes, UnitDuration.seconds]
    ]
    
    let formatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .long
        return formatter
    }()
    
    var outputValue: String{
        let inputMeasurement = Measurement(value: inputValue, unit: inputUnit)
        let outputMeasurement = inputMeasurement.converted(to: outputUnit)
        return formatter.string(from: outputMeasurement)
    }
    
    var body: some View {
        NavigationStack{
            Form {
                Section("Choose the conversion"){
                    Picker("Conversion", selection: $selectedUnit){
                        ForEach(0..<conversions.count, id: \.self){
                            Text(conversions[$0])
                        }
                    }
                }
                Section("Insert the value to be converted") {
                    TextField("Input Value", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($inputIsFocused)
                    
                    Picker("Unit", selection: $inputUnit){
                        ForEach(unitTypes[selectedUnit], id: \.self){
                            Text(formatter.string(from: $0).capitalized)
                        }
                    }
                }
                Section("Converted value") {
                    Text(outputValue)
                    
                    Picker("Unit", selection: $outputUnit){
                        ForEach(unitTypes[selectedUnit], id: \.self){
                            Text(formatter.string(from: $0).capitalized)
                        }
                    }
                }
            }
            .navigationTitle("Converter")
            .toolbar {
                if inputIsFocused {
                    Button("Done"){
                        inputIsFocused = false
                    }
                }
            }
            .onChange(of: selectedUnit) {
                let units = unitTypes[selectedUnit]
                inputUnit = units[0]
                outputUnit = units[1]
            }
        }
    }
}

#Preview {
    ContentView()
}
