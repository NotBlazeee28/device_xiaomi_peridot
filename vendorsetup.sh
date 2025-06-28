cd hardware/qcom-caf/sm8650/audio/agm && git fetch https://github.com/Soverzion-Peridot/vendor_qcom_opensource_agm lineage-22.2-caf-sm8650 && git reset --hard FETCH_HEAD && croot

cd hardware/qcom-caf/sm8650/audio/pal && git fetch https://github.com/Soverzion-Peridot/vendor_qcom_opensource_arpal-lx lineage-22.2-caf-sm8650 && git reset --hard FETCH_HEAD && croot

cd hardware/qcom-caf/sm8650/audio/primary-hal && git fetch https://github.com/Soverzion-Peridot/hardware_qcom_audio-ar lineage-22.2-caf-sm8650 && git reset --hard FETCH_HEAD && croot

cd hardware/qcom-caf/sm8650/display && git fetch https://github.com/Soverzion-Peridot/hardware_qcom_display lineage-22.2-caf-sm8650 && git reset --hard FETCH_HEAD && croot

cd device/qcom/sepolicy_vndr/sm8650 && git fetch https://github.com/Soverzion-Peridot/device_qcom_sepolicy_vndr vic-sm8650 && git reset --hard FETCH_HEAD && croot

cd hardware/qcom-caf/common && git fetch https://github.com/Soverzion-Peridot/hardware_qcom-caf_common lineage-22.2 && git reset --hard FETCH_HEAD && croot

git clone https://github.com/NotBlazeee28/hardware_xiaomi -b clover hardware/xiaomi --depth=1 

git clone https://github.com/NotBlazeee28/vendor_xiaomi_peridot -b clover vendor/xiaomi/peridot --depth=1

git clone https://github.com/NotBlazeee28/device_xiaomi_peridot-kernel -b fifteen device/xiaomi/peridot-kernel --depth=1

git clone https://github.com/NotBlazeee28/vendor_xiaomi_peridot-miuicamera -b leica vendor/xiaomi/peridot-miuicamera --depth=1

git clone https://github.com/NotBlazeee28/device_xiaomi_peridot-miuicamera -b leica device/xiaomi/peridot-miuicamera --depth=1