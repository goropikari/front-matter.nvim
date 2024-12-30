.PHONY: fmt
fmt:
	stylua -g '*.lua' -- .

.PHONY: lint
lint:
	typos -w

.PHONY: check
check: lint fmt

.PHONY: devc-up
devc-up:
	devcontainer up --workspace-folder=.

.PHONY: devc-up-new
devc-up-new:
	devcontainer up --workspace-folder=. --remove-existing-container

.PHONY: devc-exec
devc-exec:
	devcontainer exec --workspace-folder=. bash

.PHONY: setup
setup:
	mkdir -p ~/.local/share/$${NVIM_APPNAME:-nvim}/front-matter.nvim
	curl -s https://api.github.com/repos/goropikari/front-matter.nvim/releases/latest | jq -r '.assets[0].browser_download_url' | xargs -I {} curl {} -L -o - | tar zx -C ~/.local/share/$${NVIM_APPNAME:-nvim}/front-matter.nvim
