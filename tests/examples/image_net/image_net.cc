#include "examples/image_net/image_net.h"

#include "examples/image_net/common_flags.h"
#include "examples/image_net/image_net_cpu.h"
#ifndef Q_CPU_ONLY
#include "examples/image_net/image_net_gpu.h"
#endif

namespace qcraft::nets {

std::unique_ptr<ImageNetBase> CreateImageNet() {
#ifndef Q_CPU_ONLY
  if (FLAGS_use_gpu) {
    return std::make_unique<ImageNetGPU>();
  } else {
    return std::make_unique<ImageNetCPU>();
  }
#else
  return std::make_unique<ImageNetCPU>();
#endif
}

}  // namespace qcraft::nets
