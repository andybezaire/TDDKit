# please run this script from the root of TDDKit
# the DocC files will be generated in the ./docs directory
swift package \
    --allow-writing-to-directory ./docs \
    generate-documentation \
        --target TDDKit \
        --disable-indexing \
        --include-extended-types \
        --transform-for-static-hosting \
        --hosting-base-path TDDKit \
        --output-path ./docs
