//
//  FormsView.swift
//  WeatherForecast
//
//  Created by purnami indryaswari on 03/12/24.
//

import SwiftUI

struct FormsView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var selectedProvince: Province?
    @State private var selectedRegency: Regency?
    @State private var selectedDistrict: District?
    @FocusState private var isTFProvinceFocused: Bool
    @FocusState private var isTFRegencyFocused: Bool
    @FocusState private var isTFDistrictFocused: Bool
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 10){
                TextField("Masukkan Nama", text: $viewModel.name)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                searchProvince
                
                if let province = selectedProvince, !province.id.isEmpty {
                    searchRegency
                }
                
                if let regency = selectedRegency, !regency.id.isEmpty {
                    searchDistrict
                }
                
                nextButton
                
                Spacer()
            }
            .padding(.top, 30)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            )
            .alert(isPresented: $viewModel.isShowAlert, content: {
                Alert(title: Text("Input Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            })
            .navigationDestination(isPresented: $viewModel.navigateToWeatherView) {
                WeatherView(viewModel: viewModel)
            }
        }
    }

    private var searchProvince : some View {
        SearchField(
            searchText: $viewModel.searchProvinceText,
            isListVisible: $viewModel.isListProvinceVisible,
            listItems: viewModel.filteredProvinces,
            placeholder: "Pilih Provinsi",
            onItemSelected: { province in
                selectedProvince = province
                viewModel.searchProvinceText = province.name
                viewModel.fetchRegencies(provinceId: province.id)
                viewModel.searchRegencyText = ""
                viewModel.searchDistrictText = ""
            },
            onChange: {
                viewModel.filterProvinces()
            },
            selectedItem: selectedProvince
        )
    }
    
    private var searchRegency : some View {
        SearchField(
            searchText: $viewModel.searchRegencyText,
            isListVisible: $viewModel.isListRegencyVisible,
            listItems: viewModel.filteredRegencies,
            placeholder: "Pilih Kota/Kabupaten",
            onItemSelected: { regency in
                selectedRegency = regency
                viewModel.searchRegencyText = regency.name
                viewModel.fetchDistricts(regencyId: regency.id)
                viewModel.searchDistrictText = ""
            },
            onChange: {
                viewModel.filterRegencies()
            },
            selectedItem: selectedRegency
        )
    }
    
    private var searchDistrict : some View {
        SearchField(
            searchText: $viewModel.searchDistrictText,
            isListVisible: $viewModel.isListDistrictVisible,
            listItems: viewModel.filteredDistricts,
            placeholder: "Pilih Kecamatan",
            onItemSelected: { district in
                selectedDistrict = district
                viewModel.searchDistrictText = district.name
            },
            onChange: {
                viewModel.filterDistricts()
            },
            selectedItem: selectedDistrict
        )
    }
    
    private var nextButton : some View {
        Button(action: viewModel.handleNextButton) {
            Text("Next")
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 45)
                .frame(maxWidth: .infinity)
            
        }
        .frame(height: 45)
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(25)
        .padding(.horizontal)
    }
}

struct SearchField<T: Identifiable>: View {
    @Binding var searchText: String
    @Binding var isListVisible: Bool
    var listItems: [T]
    var placeholder: String
    var onItemSelected: (T) -> Void
    var onChange: () -> Void
    var selectedItem: T?

    @FocusState private var isFieldFocused: Bool
    
    var body: some View {
        Group {
            HStack {
                TextField(placeholder, text: $searchText)
                    .padding(10)
                    .focused($isFieldFocused)
                    .onChange(of: searchText) {
                        isListVisible = isFieldFocused
                        print(searchText)
                        onChange()
                    }
                Image(systemName: isListVisible ? "chevron.down" : "chevron.up")
                    .padding(.trailing, 10)
            }
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
            .onTapGesture {
                isListVisible.toggle()
                isFieldFocused.toggle()
            }
            
            if isListVisible {
                List(listItems) { item in
                    Button(action: {
                        onItemSelected(item)
                        isListVisible = false
                        isFieldFocused = false
                    }) {
                        HStack {
                            Text(item is Province ? (item as! Province).name : item is Regency ? (item as! Regency).name : (item as! District).name)
                            Spacer()
                            if let selectedItem = selectedItem,
                               let itemId = item as? (any Identifiable),
                               selectedItem.id == itemId.id as! T.ID {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

#Preview {
    FormsView()
}
