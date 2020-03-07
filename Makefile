# A Simple Makefile for LaTeX
# Author: Lester James V. Miranda
# E-mail: ljvmiranda@gmail.com
# Modified by Jesper Dramsch
.DEFAULT_GOAL := default

# Default variables which can be edited via the terminal
comma := ,
BUILDDIR = _build
COMPILER = xelatex
BIBCOMPILER = biber
BIBLIOGRAPHY = bibliography

pdf: headon clean
	@echo "Building $(PROJECT) in $(BUILDDIR) directory using $(COMPILER)."
	@echo "Creating $(BUILDDIR) directory..."
	@mkdir -p $(BUILDDIR)
	@$(COMPILER) -interaction=nonstopmode -halt-on-error -output-directory=$(BUILDDIR) $(PROJECT).tex
	@echo "First pass (via $(COMPILER)) done!"
ifeq ($(PROJECT), "cv")
	@cp $(BIBLIOGRAPHY).bib $(BUILDDIR)
	@$(BIBCOMPILER) --output_directory=$(BUILDDIR) $(PROJECT)
	@echo "Second pass (via $(BIBCOMPILER)) done!"
endif
	@$(COMPILER) -interaction=nonstopmode -halt-on-error -output-directory=$(BUILDDIR) $(PROJECT).tex
	@echo "Third pass (via $(COMPILER)) done!"
	@$(COMPILER) -interaction=nonstopmode -halt-on-error -output-directory=$(BUILDDIR) $(PROJECT).tex
	@echo "Last pass (via $(COMPILER)) done!"
	@cp $(BUILDDIR)/$(PROJECT).pdf $(PROJECT)-$(subst $(comma),-,$(strip $(DOCOPTIONS))).pdf
	@echo "Compilation done. Output file is $(PROJECT)-$(subst $(comma),-,$(strip $(DOCOPTIONS))).pdf"

headon:
ifneq ($(OPTIN),)
	@$(eval DOCOPTIONS:=$(DOCOPTIONS),$(OPTIN))
endif
	@echo "\documentclass[$(DOCOPTIONS)]{friggeri-cv}" > .head

a4pdf:
	$(MAKE) headon OPTIN=a4pdf
	$(MAKE) default DOCOPTIONS=$(DOCOPTIONS),a4pdf

nocolors:
	$(MAKE) headon OPTIN=nocolors
	$(MAKE) default DOCOPTIONS=$(DOCOPTIONS),nocolors

print:
	$(MAKE) headon OPTIN=print
	$(MAKE) default DOCOPTIONS=$(DOCOPTIONS),print

custom: pdf

cv: 
	$(MAKE) pdf PROJECT=cv

coverletter: 
	$(MAKE) pdf PROJECT=coverletter

default: cv coverletter


clean:
	@rm -rf $(BUILDDIR)
	@echo "Removed $(BUILDDIR) directory"
