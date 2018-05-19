# A Simple Makefile for LaTeX
# Author: Lester James V. Miranda
# E-mail: ljvmiranda@gmail.com
# Modified by Jesper Dramsch
.DEFAULT_GOAL := default

default: pdf

comma = ,

# Default variables which can be edited via the terminal
BUILDDIR = _build
COMPILER = xelatex
PROJECT = cv
BIBLIOGRAPHY = bibliography
DOCOPTIONS ?= heros
DOCSTR = $(subst $(comma),-,$(DOCOPTIONS))

define compiletex =
	@echo "Building $(PROJECT) in $(BUILDDIR) directory using $(COMPILER)."
	@echo "\documentclass[^$]{friggeri-cv}" > head.tex
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
endef

pdf: $(DOCOPTIONS) 
	$(compiletex)

a4pdf: a4paper,$(DOCOPTIONS) 
	$(compiletex)

print: print
	$(compiletex)
	
nocolors: nocolors
	$(compiletex)

clean:
	@rm -rf $(BUILDDIR)
	@echo "Removed $(BUILDDIR) directory"
