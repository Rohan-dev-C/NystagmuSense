
 
 #include <iostream>
 #include <fstream>
 #include <vector>
 #include <nlohmann-json.hpp>
 
 using json = nlohmann::json;
 
 class Gaze {
 public:
 double startX, endX, startTime, endTime;
 
 Gaze(double startX, double endX, double startTime, double endTime)
 : startX(startX), endX(endX), startTime(startTime), endTime(endTime) {}
 };
 
 class AnalyzeGaze {
 public:
 double changeX, changeTime;
 
 AnalyzeGaze(double changeX, double changeTime)
 : changeX(changeX), changeTime(changeTime) {}
 };
 
 bool isWithinRange(const AnalyzeGaze& gaze1, const AnalyzeGaze& gaze2, double maxXDifference, double maxTimeDifference) {
 return std::abs(gaze1.changeX - gaze2.changeX) <= maxXDifference &&
 std::abs(gaze1.changeTime - gaze2.changeTime) <= maxTimeDifference;
 }
 
 int main() {
 std::ifstream file("GazaData.json");
 if (!file.is_open()) {
 std::cerr << "Failed to open JSON file." << std::endl;
 return 1;
 }
 
 json jsonData;
 file >> jsonData;
 
 std::vector<Gaze> gazeList;
 
 for (auto& entry : jsonData) {
 double startX = entry["startX"];
 double endX = entry["endX"];
 double startTime = entry["startTime"];
 double endTime = entry["endTime"];
 
 gazeList.emplace_back(startX, endX, startTime, endTime);
 }
 
 std::vector<AnalyzeGaze> analyzeGazeList;
 
 for (size_t i = 1; i < gazeList.size(); ++i) {
 double changeX = gazeList[i].startX - gazeList[i - 1].endX;
 double changeTime = gazeList[i].startTime - gazeList[i - 1].endTime;
 
 analyzeGazeList.emplace_back(changeX, changeTime);
 }
 
 double maxXDifference = 0.2; // Adjust
 double maxTimeDifference = 0.5; // Adjust
 
 for (size_t i = 0; i < analyzeGazeList.size(); ++i) {
     for (size_t j = i + 1; j < analyzeGazeList.size();) {
         if (!isWithinRange(analyzeGazeList[i], analyzeGazeList[j], maxXDifference, maxTimeDifference)) {
            analyzeGazeList.erase(analyzeGazeList.begin() + j);
            } else {
                    ++j;
            }
    }
 }
 
 return 0;
 }
 
 
