#ifndef EXAMPLES_IMAGE_NET_IMAGE_NET_CPU_H_
#define EXAMPLES_IMAGE_NET_IMAGE_NET_CPU_H_

#include "examples/image_net/image_net_base.h"

namespace qcraft::nets {

class ImageNetCPU : public ImageNetBase {
 public:
  void Inference() override;
};

}  // namespace qcraft::nets

#endif  // EXAMPLES_IMAGE_NET_IMAGE_NET_CPU_H_
