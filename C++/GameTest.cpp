#include "GameRunner.h"
#include <iostream>
#include <fstream>
#include <stdexcept>
#include <vector>
#include <sstream>

using namespace std;

class FakeFileInput : public Input {
private:
    vector<int> diceRolls;
    vector<bool> responses;
    size_t diceIndex;
    size_t responseIndex;
    
    void loadDataFromFile(const string& filename) {
        ifstream file(filename);
        if (!file.is_open()) {
            throw runtime_error("Could not open file: " + filename);
        }
        string line;
        getline(file, line);
        getline(file, line);
        responses = parseBooleanLine(line);

        getline(file, line);
        getline(file, line);
        getline(file, line);
        diceRolls = parseIntegerLine(line);

        file.close();
    }
    
    vector<int> parseIntegerLine(const string& line) {
        vector<int> result;
        stringstream ss(line);
        string item;
        
        while (getline(ss, item, ',')) {
            result.push_back(stoi(item));
        }
        
        return result;
    }
    
    vector<bool> parseBooleanLine(const string& line) {
        vector<bool> result;
        stringstream ss(line);
        string item;
        
        while (getline(ss, item, ',')) {
            int value = stoi(item);
            result.push_back(value != 7);
        }
        
        return result;
    }
    
public:
    FakeFileInput(const string& filename) : diceIndex(0), responseIndex(0) {
        loadDataFromFile(filename);
    }
    
    virtual int die() override {
        if (diceIndex >= diceRolls.size()) {
            throw runtime_error("No more dice rolls available");
        }
        return diceRolls[diceIndex++];
    }
    
    virtual bool responseIsCorrect() override {
        if (responseIndex >= responses.size()) {
            throw runtime_error("No more responses available");
        }
        return responses[responseIndex++];
    }
};

// No need for FakeOutput - we'll use stringstream directly

string readExpectedOutput(const string& filename) {
    ifstream file(filename);
    if (!file.is_open()) {
        throw runtime_error("Could not open expected output file: " + filename);
    }
    
    string content;
    string line;
    while (getline(file, line)) {
        content += line;
        if (!file.eof()) {
            content += "\n";
        }
    }
    
    file.close();
    return content;
}

int main() {
    try {
        FakeFileInput input("../reference/randomSeq.txt");
        stringstream output;

        GameRunner gameRunner(&input, output);
        gameRunner.run();

        string actualOutput = output.str();
        string expectedOutput = readExpectedOutput("../reference/result.txt");

        if (actualOutput == expectedOutput) {
            cout << "TEST PASSED: Game output matches expected result!" << endl;
            return 0;
        } else {
            cout << "TEST FAILED: Game output does not match expected result!" << endl;
            cout << "\n=== EXPECTED ===" << endl;
            cout << expectedOutput << endl;
            cout << "\n=== ACTUAL ===" << endl;
            cout << actualOutput << endl;
            return 1;
        }
        
    } catch (const exception& e) {
        cout << "TEST ERROR: " << e.what() << endl;
        return 1;
    }
}