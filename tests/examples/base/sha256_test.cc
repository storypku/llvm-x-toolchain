#include "examples/base/sha256.h"

#include <algorithm>
#include <vector>

#include "gtest/gtest.h"

namespace galaxy {

TEST(Sha256Test, TestSha256SumForString) {
  const std::string mystr("hello world");
  const std::string expected_sha = "b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9";
  EXPECT_EQ(Sha256SumForString(mystr), expected_sha);
}

}  // namespace galaxy
