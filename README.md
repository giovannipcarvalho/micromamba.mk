# micromamba.mk

Manage micromamba environments and common workflows for Python *applications*
with `make`.

The goal is to make getting started as easy as `git clone && make`.

_(This is unstable, unsafe and not ready for production.)_


## Demo

```bash
git clone https://github.com/giovannipcarvalho/micromamba.mk
cd micromamba.mk/example

make            # creates env, syncs deps, checks code, and runs tests
make build run  # builds and runs docker image
```


## Requirements

* Linux, GNU Make & awk
* [micromamba](https://mamba.readthedocs.io/en/latest/micromamba-installation.html#install-script)

## Usage

1. Create a `Makefile` with the following contents:

```make
include micromamba.mk
micromamba.mk:
	curl \
		--output micromamba.mk \
		--location \
		"https://raw.githubusercontent.com/giovannipcarvalho/micromamba.mk/master/micromamba.mk"
```

2. Create an `environment.yml` file:

```yaml
channels:
  - conda-forge
dependencies:
  - python=3.11
  - pip:
    - pip-tools
```

3. Run `make help` to see available targets:

<pre>
<font color="#2A7BDE">$</font> make help
<font color="#26A269"><b>all         </b></font> Run main targets
<font color="#26A269"><b>env         </b></font> Create or update virtual environment
<font color="#26A269"><b>activate    </b></font> Open a new shell with the activated environment
<font color="#26A269"><b>deps        </b></font> Sync dependencies in the virtual environment
<font color="#26A269"><b>lockdeps    </b></font> Update or generate dependency lock files
<font color="#26A269"><b>check       </b></font> Run checkers, linters and auto-fixers
<font color="#26A269"><b>test        </b></font> Run tests
<font color="#26A269"><b>cov         </b></font> Run tests and report coverage
<font color="#26A269"><b>build       </b></font> Build artifacts
<font color="#26A269"><b>run         </b></font> Run main entrypoint
<font color="#26A269"><b>notebook    </b></font> Start jupyter notebook
<font color="#26A269"><b>clean       </b></font> Clean-up generated files
<font color="#26A269"><b>purge       </b></font> Clean-up and remove environment
<font color="#26A269"><b>help        </b></font> Show help
</pre>

Remember to ignore `micromamba.mk` and `.micromambaenv`, e.g.:

```bash
echo -e 'micromamba.mk\n.micromambaenv' >> .gitignore
```

This Makefile is designed to work with setuptools.  Check out `example/` for a
complete example.


## How to

### Override commands

```make
# file: Makefile
# [...]
build:
	@echo my custom build command
```

It works, but you'll get warnings such as:

    Makefile:3: warning: overriding recipe for target 'build'


## See also

* [Makefile.venv](https://github.com/sio/Makefile.venv)
* [Make Better Defaults](https://github.com/hackalog/make_better_defaults)
* [Towards clone to Red-Green-Refactor in one command](https://www.youtube.com/watch?v=WTsiO3brQwE)
