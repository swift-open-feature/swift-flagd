# Code generation
# -----------------------------------------------------------------------------
PROTO_ROOT = flagd-schemas/protobuf
PROTOS += $(PROTO_ROOT)/flagd/evaluation/v1/evaluation.proto
GEN_SWIFT_ROOT = Sources/Flagd/Generated
GEN_SWIFTS = $(patsubst  $(PROTO_ROOT)/%.proto,$(GEN_SWIFT_ROOT)/%.pb.swift,$(PROTOS))
GEN_GRPC_SWIFTS = $(subst $(PROTO_ROOT),$(GEN_SWIFT_ROOT),$(PROTOS:.proto=.grpc.swift))
PROTOC_GEN_SWIFT = .build/debug/protoc-gen-swift
PROTOC_GEN_GRPC_SWIFT = .build/debug/protoc-gen-grpc-swift

$(PROTOC_GEN_SWIFT):
	swift build --product protoc-gen-swift

$(PROTOC_GEN_GRPC_SWIFT):
	swift build --product protoc-gen-grpc-swift

$(GEN_SWIFTS): $(PROTOS) $(PROTOC_GEN_SWIFT)
	@mkdir -pv $(GEN_SWIFT_ROOT)
	protoc $(PROTOS) \
		--proto_path=$(PROTO_ROOT) \
		--plugin=$(PROTOC_GEN_SWIFT) \
		--swift_out=$(GEN_SWIFT_ROOT) \
		--swift_opt=Visibility=Internal \
		--experimental_allow_proto3_optional

$(GEN_GRPC_SWIFTS): $(PROTOS) $(PROTOC_GEN_GRPC_SWIFT)
	@mkdir -pv $(GEN_SWIFT_ROOT)
	protoc $(PROTOS) \
		--proto_path=$(PROTO_ROOT) \
		--plugin=$(PROTOC_GEN_GRPC_SWIFT) \
		--plugin=$(PROTOC_GEN_SWIFT) \
		--swift_out=$(GEN_SWIFT_ROOT) \
		--swift_opt=Visibility=Internal \
		--grpc-swift_out=Client=true,Server=false:$(GEN_SWIFT_ROOT)

.PHONY: generate
generate: $(GEN_SWIFTS) $(GEN_GRPC_SWIFTS)

.PHONY: delete-generated-code
delete-generated-code:  # Delete all pb.swift and .grpc.swift files.
	@read -p "Delete all *.pb.swift and *.grpc.swift files in Sources/Flagd [y/N]" ans && [ $${ans:-N} = y ]
	find Sources -name *.pb.swift -delete -o -name *.grpc.swift -delete
