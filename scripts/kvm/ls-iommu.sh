#!/usr/bin/env bash

o=
for d in /sys/kernel/iommu_groups/*/devices/*; do
  n=${d#*/iommu_groups/*}; n=${n%%/*}
  if [[ $n != $o ]]; then
    printf 'IOMMU Group %s ' "$n"
    printf "\n"
    o=$n
  fi
  printf "\t"
  lspci -nns "${d##*/}"
done

