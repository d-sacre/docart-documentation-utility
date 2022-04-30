// Requires C++ 17 or higher

#include <iostream>
#include <ctime>

int main() {
    std::time_t result = std::time(nullptr); 
    std::cout << "Hello World, it is " << std::asctime(std::localtime(&result));
    return 0;
}
