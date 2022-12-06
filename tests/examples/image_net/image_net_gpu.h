#ifndef EXAMPLES_IMAGE_NET_IMAGE_NET_GPU_H_
#define EXAMPLES_IMAGE_NET_IMAGE_NET_GPU_H_

#include "examples/image_net/image_net_base.h"

namespace qcraft::nets {

class ImageNetGPU : public ImageNetBase {
 public:
  void Inference() override;
};

}  // namespace qcraft::nets

#endif  // EXAMPLES_IMAGE_NET_IMAGE_NET_GPU_H_
