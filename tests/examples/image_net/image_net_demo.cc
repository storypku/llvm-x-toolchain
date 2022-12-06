#include <memory>

#include "examples/image_net/image_net.h"
#include "gflags/gflags.h"

int main(int argc, char* argv[]) {
  gflags::ParseCommandLineFlags(&argc, &argv, /*remove_flags=*/true);
  auto net = qcraft::nets::CreateImageNet();
  net->Inference();
  return 0;
}
