#pragma once

#include <algorithm>
#include <cstdint>
#include <random>
#include <vector>

namespace cc_opt {
template <typename FloatTy>
inline std::vector<FloatTy> GenRandomFloatVec(int64_t size, FloatTy lower_bound,
                                              FloatTy upper_bound) {
  // engine
  std::random_device seed;
  std::ranlux48 rand_engine(seed());
  // distribution
  std::uniform_real_distribution<FloatTy> dist(lower_bound, upper_bound);

  auto gen = [&dist, &rand_engine]() { return dist(rand_engine); };

  std::vector<FloatTy> vec(size);
  std::generate(vec.begin(), vec.end(), gen);

  return vec;
}

template <typename IntTy>
inline std::vector<IntTy> GenRandomIntVec(int64_t size, IntTy lower_bound,
                                          IntTy upper_bound) {
  // engine
  std::random_device seed;
  std::ranlux48 rand_engine(seed());
  // distribution
  std::uniform_int_distribution<IntTy> dist(lower_bound, upper_bound);

  auto gen = [&dist, &rand_engine]() { return dist(rand_engine); };

  std::vector<IntTy> vec(size);
  std::generate(vec.begin(), vec.end(), gen);

  return vec;
}

template <typename FloatTy>
inline std::vector<FloatTy>
GenRandomFloatVec(int64_t size, std::vector<FloatTy> lower_bound,
                  std::vector<FloatTy> upper_bound) {
  // engine
  std::random_device seed;
  std::ranlux48 rand_engine(seed());

  std::vector<FloatTy> vec(size);
  for (int64_t i = 0; i < size; ++i) {
    // distribution
    std::uniform_real_distribution<FloatTy> dist(lower_bound[i],
                                                 upper_bound[i]);

    vec[i] = dist(rand_engine);
  }
  return vec;
}

template <typename IntTy>
inline std::vector<IntTy> GenRandomIntVec(int64_t size,
                                          std::vector<IntTy> lower_bound,
                                          std::vector<IntTy> upper_bound) {
  // engine
  std::random_device seed;
  std::ranlux48 rand_engine(seed());

  std::vector<IntTy> vec(size);
  for (int64_t i = 0; i < size; ++i) {
    // distribution
    std::uniform_int_distribution<IntTy> dist(lower_bound[i], upper_bound[i]);
    vec[i] = dist(rand_engine);
  }

  return vec;
}

template <typename FloatTy>
inline FloatTy GetRandomFloat(double lower_bound, double upper_bound) {
  // engine
  std::random_device seed;
  std::ranlux48 rand_engine(seed());
  // distribution
  std::uniform_real_distribution<FloatTy> dist(lower_bound, upper_bound);

  return dist(rand_engine);
}

template <typename IntTy>
inline IntTy GetRandomInt(int64_t lower_bound, int64_t upper_bound) {
  // engine
  std::random_device seed;
  std::ranlux48 rand_engine(seed());
  // distribution
  std::uniform_int_distribution<IntTy> dist(lower_bound, upper_bound);

  return dist(rand_engine);
}

} // namespace cc_opt
