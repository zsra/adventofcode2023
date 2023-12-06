#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>

int main() {
    const std::string filePath = "day6part2.in";
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

    std::stringstream timeStringbuilder;
    std::stringstream distanceStringbuilder;

    int increaser = 1;
    for(int i = 0; i < timeArray.size(); i++) {
        timeStringbuilder << timeArray[i];
        distanceStringbuilder << distanceArray[i];
    }

    long long time = std::stoll(timeStringbuilder.str());
    long long distance = std::stoll(distanceStringbuilder.str());

    long long counter = 0;

    for(long long timeCounter = 14; timeCounter < time; timeCounter++) {
        long long totalDistance = timeCounter * (time - timeCounter);

        if (totalDistance > distance) {
            counter++;
        }
    }

    std::cout << counter << "\n";

    return 0;
}