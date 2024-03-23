#!/usr/bin/env ash

pushd /as/firmware

ln -sf brcmfmac4366c-pcie.bin.69027 brcmfmac4366c-pcie.bin
ln -sf $PWD/brcmfmac4366c-pcie.bin /lib/firmware/

popd
