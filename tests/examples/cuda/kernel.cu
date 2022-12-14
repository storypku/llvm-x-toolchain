// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
#include <cstdio>
#include <iostream>

#include "examples/cuda/kernel.h"

__global__ void Kernel() { printf("Hello CUDA!\n"); }

void ReportIfError(cudaError_t error) {
  if (error != cudaSuccess) {
    std::cerr << "CUDA error: " << cudaGetErrorString(error) << std::endl;
  }
}

void Launch() {
  Kernel<<<1, 1>>>();
  ReportIfError(cudaGetLastError());
  ReportIfError(cudaDeviceSynchronize());
}
