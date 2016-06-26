ZDOTDIR := ~/.zsh
ZSHENV := ~/.zshenv

SUBMODULES = $(shell git submodule | awk '{ print $$2 }')

.PHONY: export
export:
ifeq ("$(wildcard $(ZSHENV))","")
	echo "export ZDOTDIR=$(ZDOTDIR)" > $(ZSHENV)
endif

.PHONY: symlink
symlink:
ifeq ("$(wildcard $(ZDOTDIR))","")
	ln -s `pwd` $(ZDOTDIR)
endif

.PHONY: install
install: submodule-init export symlink

.PHONY: submodule-init
submodule-init:
	git submodule update --init

.PHONY: submodule-update
submodule-update:
	@for submodule in $(SUBMODULES); do \
	(\
		cd $$submodule; \
		git pull origin master;\
	)\
	done
