#ifndef EXAMPLES_IMAGE_NET_IMAGE_NET_BASE_H_
#define EXAMPLES_IMAGE_NET_IMAGE_NET_BASE_H_

namespace qcraft::nets {

class ImageNetBase {
 public:
  ImageNetBase() = default;
  virtual ~ImageNetBase() = default;

 public:
  virtual void Inference() = 0;
};

}  // namespace qcraft::nets

#endif  // EXAMPLES_IMAGE_NET_IMAGE_NET_BASE_H_
