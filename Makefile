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
