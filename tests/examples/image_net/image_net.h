#ifndef EXAMPLES_IMAGE_NET_IMAGE_NET_H_
#define EXAMPLES_IMAGE_NET_IMAGE_NET_H_

#include <memory>

#include "examples/image_net/image_net_base.h"

namespace qcraft::nets {

std::unique_ptr<ImageNetBase> CreateImageNet();

}  // namespace qcraft::nets

#endif  // EXAMPLES_IMAGE_NET_IMAGE_NET_H_
