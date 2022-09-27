BINS=( \
    java \
    javac \
    jps \
)

for BIN in ${BINS[@]}; do
    [[ -f "${JAVA_HOME}/bin/${BIN}" ]] || continue
    sudo update-alternatives --install "${BIN_DIR}/${BIN}" ${BIN} "${JAVA_HOME}/bin/${BIN}" ${PRIOR}
done
