#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>

int main() {
    const std::string filePath = "day6.in";
    std::ifstream file(filePath);

    if (!file.is_open()) {
        std::cerr << "Error opening file: " << filePath << std::endl;
        return 1;
    }

    std::vector<int> timeArray;
    std::vector<int> distanceArray;
    std::string line;

    while (std::getline(file, line)) {
        std::istringstream iss(line);
        std::string dataType;
        iss >> dataType;

        int value;
        while (iss >> value) {
            if (dataType == "Time:") {
                timeArray.push_back(value);
            } else if (dataType == "Distance:") {
                distanceArray.push_back(value);
            }
        }
    }

    file.close();

    int result = 1;

    for (int index = 0; index < timeArray.size(); index++) {
        int counter = 0;
        
        for (int time = 1; time < timeArray[index]; time++) {
            int travelTotal = time * (timeArray[index] - time);

            if (travelTotal > distanceArray[index]) {
                counter++;
            }
        }

        result *= counter;
    }

    std::cout << result << "\n";

    return 0;
}