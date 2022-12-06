#include <iostream>

#include "cuda/include/cuda_runtime_api.h"
#include "examples/image_net/image_net_gpu.h"

namespace qcraft::nets {
namespace {

__global__ void ImageNetGpuKernel() {
  std::printf("Hello from ImageNetGPU Kernel\n");
}

}  // namespace

void ImageNetGPU::Inference() {
  ImageNetGpuKernel<<<1, 1>>>();
  std::printf("ImageNetGPU inference\n");
  cudaDeviceSynchronize();
}

}  // namespace qcraft::nets
