#!/bin/bash

for file in ${IBEX_REPO}/rtl/*.sv ${FPGA}/soc/${SOC}/ibex_wrapper.sv; do
  module=`basename -s .sv $file`

  # Skip files
  if echo "$module" | grep -q '_pkg$'; then
      continue
  elif echo "$module" | grep -q '_lockstep$'; then
      continue
  elif echo "$module" | grep -q '_top$'; then
      continue
  elif echo "$module" | grep -q '_tracing$'; then
      continue
  elif echo "$module" | grep -q '_tracer$'; then
      continue
  fi

  sv2v \
    --define=SYNTHESIS \
    ${IBEX_REPO}/rtl/*_pkg.sv \
    -I${IBEX_REPO}/vendor/lowrisc_ip/ip/prim/rtl \
    -I${IBEX_REPO}/vendor/lowrisc_ip/dv/sv/dv_utils \
    $file \
    > ${FPGA_BUILD}/${VIVADO_PROJECT}/rtl_sources/${module}.v
done
#    ${IBEX_REPO}/vendor/lowrisc_ip/ip/prim/rtl/prim_ram_1p_pkg.sv \
#    ${IBEX_REPO}/vendor/lowrisc_ip/ip/prim/rtl/prim_ram_2p_pkg.sv \

