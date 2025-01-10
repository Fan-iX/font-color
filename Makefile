MAP=rainbow.map
TEMPLATE_FONT=monospace
WIDTH=768
HEIGHT=1024
FONT_SIZE=1024
ASCENDER=768
COLOR_FORMAT=glyf_colr_0

FONT_NAME=$(notdir $(basename $(MAP)))

BUILD_DIR=build
RAW_SVG_DIR=$(BUILD_DIR)/rawsvg
FONT_SVG_DIR=$(BUILD_DIR)/fontsvg
CHARS:=

ifndef CHARS
CHARS:=$(shell perl -ale 'print @F[0]' $(MAP))
endif

$(foreach EXPR,$(shell perl -ale 'use Encode;@F[1]=~s/#/\\#/;printf("_C_%04X=%s ",ord(decode "UTF-8", @F[0]),@F[1])' $(MAP)),$(eval $(EXPR)))

_H_WIDTH=$(shell perl -e 'print $(WIDTH)/2')
_DESCENDER=$(shell perl -e 'print $(ASCENDER)-$(HEIGHT)')
CODES:=$(shell echo $(CHARS) | perl -ae 'use Encode;map{printf "%04X ",ord(decode "UTF-8", $$_)}@F')

all: $(BUILD_DIR)/$(MAP).ttf

$(BUILD_DIR)/$(MAP).ttf: $(patsubst %,$(FONT_SVG_DIR)/emoji_u%.svg,$(CODES))
	nanoemoji --color_format $(COLOR_FORMAT) --descender $(_DESCENDER) --ascender $(ASCENDER) --width $(WIDTH) --build_dir $(BUILD_DIR)/ --family $(FONT_NAME) $^
	cp $(BUILD_DIR)/Font.ttf build/$(FONT_NAME).ttf
	rm -r $(FONT_SVG_DIR)

define MODULE_RULE
$(RAW_SVG_DIR)/u$(1)_$$(_C_$(1)).svg: | $(RAW_SVG_DIR)
	printf '<svg viewBox="0 0 $(WIDTH) $(HEIGHT)" version="1.1"><text fill="$(_C_$(1))" x="$(_H_WIDTH)" y="$(ASCENDER)" font-size="$(FONT_SIZE)" text-anchor="middle" font-family="$(TEMPLATE_FONT)">&#x$(1);</text></svg>' | inkscape -p --export-text-to-path --export-type svg -o $$@

$(FONT_SVG_DIR)/emoji_u$(1).svg: $(RAW_SVG_DIR)/u$(1)_$$(_C_$(1)).svg | $(FONT_SVG_DIR)
	cp $$< $$@
endef

$(foreach C,$(CODES),$(eval $(call MODULE_RULE,$(C))))

$(RAW_SVG_DIR) $(FONT_SVG_DIR):
	mkdir -p $@

clean:
	rm -r build/*

.SECONDARY:
.DELETE_ON_ERROR:
