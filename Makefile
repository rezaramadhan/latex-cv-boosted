# A Simple Makefile for LaTeX
# Author: Lester James V. Miranda
# E-mail: ljvmiranda@gmail.com
# Modified by Jesper Dramsch
.DEFAULT_GOAL := default

default: pdf clean

# Default variables which can be edited via the terminal
BUILDDIR = _build
COMPILER = xelatex
PROJECT = cv
BIBLIOGRAPHY = bibliography

pdf:
	@echo "Building $(PROJECT) in $(BUILDDIR) directory using $(COMPILER)..."
	@echo "Creating $(BUILDDIR) directory..."
	@mkdir $(BUILDDIR)
	@$(COMPILER) -interaction=nonstopmode -halt-on-error -output-directory=$(BUILDDIR) $(PROJECT).tex
	@echo "First pass (via $(COMPILER)) done!"
	@cp $(BIBLIOGRAPHY).bib $(BUILDDIR)
	@biber --output_directory=$(BUILDDIR) $(PROJECT)
	@echo "Second pass (via bibtex) done!"
	@$(COMPILER) -interaction=nonstopmode -halt-on-error -output-directory=$(BUILDDIR) $(PROJECT).tex
	@echo "Third pass (via $(COMPILER)) done!"
	@echo "Compilation done. Output file can be seen in $(BUILDDIR)"

clean:
	@rm -rf $(BUILDDIR)
	@echo "Removed $(BUILDDIR) directory"