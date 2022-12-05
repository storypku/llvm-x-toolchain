#include "examples/base/sha256.h"

#include <cerrno>
#include <cstring>
#include <fstream>
#include <iomanip>

#include "absl/status/status.h"
#include "absl/strings/str_format.h"
#include "openssl/sha.h"

namespace galaxy {

namespace {

std::string Stringify(int errnum) {
  constexpr size_t kBufLen = 1024;
  char buf[kBufLen];
  (void)strerror_r(errnum, buf, kBufLen); /* for thread-safety */
  return buf;
}

}  // namespace

absl::StatusOr<std::string> Sha256SumForFile(std::string_view path) {
  std::ifstream fin(path.data(), std::ios::in | std::ios::binary);
  if (!fin) {
    return absl::InternalError(
        absl::StrFormat("Failed to open %s: %s", path, Stringify(errno)));
  }

  constexpr size_t kBufferSize = 4096;
  char buffer[kBufferSize];

  unsigned char hash[SHA256_DIGEST_LENGTH] = {0};

  SHA256_CTX ctx;
  SHA256_Init(&ctx);

  while (fin.good()) {
    fin.read(buffer, kBufferSize);
    SHA256_Update(&ctx, buffer, fin.gcount());
  }

  SHA256_Final(hash, &ctx);
  fin.close();

  std::ostringstream os;
  os << std::hex << std::setfill('0');

  for (int i = 0; i < SHA256_DIGEST_LENGTH; ++i) {
    os << std::setw(2) << static_cast<unsigned int>(hash[i]);
  }
  return os.str();
}

std::string Sha256SumForString(std::string_view str) {
  SHA256_CTX ctx;
  SHA256_Init(&ctx);
  unsigned char hash[SHA256_DIGEST_LENGTH] = {0};
  SHA256_Update(&ctx, str.data(), str.size());
  SHA256_Final(hash, &ctx);
  std::ostringstream os;
  os << std::hex << std::setfill('0');

  for (int i = 0; i < SHA256_DIGEST_LENGTH; ++i) {
    os << std::setw(2) << static_cast<unsigned int>(hash[i]);
  }
  return os.str();
}

std::string Sha256SumForStrings(absl::Span<const std::string> strs) {
  SHA256_CTX ctx;
  SHA256_Init(&ctx);
  unsigned char hash[SHA256_DIGEST_LENGTH] = {0};
  for (const auto& str : strs) {
    SHA256_Update(&ctx, str.data(), str.size());
  }

  SHA256_Final(hash, &ctx);
  std::ostringstream os;
  os << std::hex << std::setfill('0');

  for (int i = 0; i < SHA256_DIGEST_LENGTH; ++i) {
    os << std::setw(2) << static_cast<unsigned int>(hash[i]);
  }
  return os.str();
}

}  // namespace galaxy
