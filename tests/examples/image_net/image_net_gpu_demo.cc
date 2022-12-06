#include <memory>

#include "examples/image_net/image_net_gpu.h"
#include "gflags/gflags.h"

int main(int argc, char* argv[]) {
  gflags::ParseCommandLineFlags(&argc, &argv, /*remove_flags=*/true);

  auto net = std::make_unique<qcraft::nets::ImageNetGPU>();
  net->Inference();

  return 0;
}
