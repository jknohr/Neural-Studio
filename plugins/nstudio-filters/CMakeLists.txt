cmake_minimum_required(VERSION 3.28...3.30)

add_library(obs-filters MODULE)
add_library(OBS::filters ALIAS obs-filters)

target_sources(
  obs-filters
  PRIVATE
  async-delay-filter.c
  chroma-key-filter.c
  color-correction-filter.c
  color-grade-filter.c
  color-key-filter.c
  compressor-filter.c
  crop-filter.c
  eq-filter.c
  expander-filter.c
  gain-filter.c
  gpu-delay.c
  hdr-tonemap-filter.c
  invert-audio-polarity.c
  limiter-filter.c
  luma-key-filter.c
  mask-filter.c
  noise-gate-filter.c
  obs-filters.c
  scale-filter.c
  scroll-filter.c
  sharpness-filter.c
)

target_link_libraries(obs-filters PRIVATE OBS::libobs)

include(cmake/speexdsp.cmake)
include(cmake/rnnoise.cmake)



set_target_properties_obs(obs-filters PROPERTIES FOLDER plugins PREFIX "")
