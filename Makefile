# A Simple Makefile for LaTeX
# Author: Lester James V. Miranda
# E-mail: ljvmiranda@gmail.com
# Modified by Jesper Dramsch
.DEFAULT_GOAL := default

# Default variables which can be edited via the terminal
comma := ,
BUILDDIR = _build
COMPILER = xelatex
PROJECT = cv
BIBLIOGRAPHY = bibliography
DOCOPTIONS ?= heros
DOCSTR = $(DOCOPTIONS)



pdf: headon
	@echo "Building $(PROJECT) in $(BUILDDIR) directory using $(COMPILER)."
	@echo "Creating $(BUILDDIR) directory..."
	@mkdir $(BUILDDIR)
	@$(COMPILER) -interaction=nonstopmode -halt-on-error -output-directory=$(BUILDDIR) $(PROJECT).tex
	@echo "First pass (via $(COMPILER)) done!"
	@cp $(BIBLIOGRAPHY).bib $(BUILDDIR)
	@biber --output_directory=$(BUILDDIR) $(PROJECT)
	@echo "Second pass (via bibtex) done!"
	@$(COMPILER) -interaction=nonstopmode -halt-on-error -output-directory=$(BUILDDIR) $(PROJECT).tex
	@echo "Third pass (via $(COMPILER)) done!"
	@$(COMPILER) -interaction=nonstopmode -halt-on-error -output-directory=$(BUILDDIR) $(PROJECT).tex
	@echo "Last pass (via $(COMPILER)) done!"
	@cp $(BUILDDIR)/$(PROJECT).pdf $(PROJECT)-$(DOCSTR).pdf
	@echo "Compilation done. Output file is $(PROJECT)-$(DOCSTR).pdf"

docdate: export DOCOPTIONS	= $(DOCOPTIONS)
docstrdate: export DOCSTR = $(subst $(comma),-,$(strip $(DOCOPTIONS)))

headon:
ifneq ($(OPTIN),)
	@$(eval DOCOPTIONS:=$(DOCOPTIONS),$(OPTIN))
endif
	@echo "\documentclass[$(DOCOPTIONS)]{friggeri-cv}" > head.tex
	$(MAKE) docdate
	$(MAKE) docstrdate

a4pdf:
	$(MAKE) headon OPTIN=a4pdf 
	$(MAKE) pdf

nocolors:  
	$(MAKE) headon OPTIN=nocolors
	$(MAKE) pdf

print: 
	$(MAKE) headon OPTIN=print 
	$(MAKE) pdf

custom: pdf

default: pdf

clean:
	@rm -rf $(BUILDDIR)
	@echo "Removed $(BUILDDIR) directory"
