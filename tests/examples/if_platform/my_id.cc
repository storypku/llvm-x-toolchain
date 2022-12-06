#include <string>
#include <iostream>

namespace {

std::string MyId() {
#if defined(Q_PLATFORM)
    std::string id(Q_PLATFORM);
#else
    std::string id = "Unknown";
#endif

#if defined(Q_CPU_ONLY_EXT)
    id += "-CPU";
#else
    id += "-GPU";
#endif
    return id;
}

} // namespace

int main(int argc, char *argv[]) {
    std::cout << "Hello from " << MyId() << std::endl;
    return 0;
}
