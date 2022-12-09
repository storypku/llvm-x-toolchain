#include "examples/if_platform/orin_only.h"

#include <iostream>

namespace galaxy {

void orin_only_function() {
  std::cout << "Only builds on Orin" << std::endl;
}

} // namespace galaxy
