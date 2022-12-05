#ifndef EXAMPLES_BASE_SHA256_H_
#define EXAMPLES_BASE_SHA256_H_

#include <string>
#include <string_view>

#include "absl/status/statusor.h"
#include "absl/types/span.h"

namespace galaxy {

/**
 * @brief Compute Sha256 sum of file
 *
 * @param path Path to the file
 */
absl::StatusOr<std::string> Sha256SumForFile(std::string_view path);

/**
 * @brief Compute Sha256 sum for string
 *
 */
std::string Sha256SumForString(std::string_view str);
std::string Sha256SumForStrings(absl::Span<const std::string> strs);

}  // galaxy

#endif  // EXAMPLES_BASE_SHA256_H_
