# Metaprogramming
* "metaprogramming" means "programs that operate on programs" or things related to process about writing code or working more efficiently
## Build systems
* You define a number of dependencies, a number of targets, and rules for going one to the other, and the build system will find all the transitive dependencies of that target, and then apply the rules to produce intermediate targets all the way until the final target has been produced
* Ideally, the build system does this process without unnecessarily executing rules for targets whose dependencies haven’t changed and where the result is available from a previous build
* `make`
    * `make` produce a file called `Makefile` in the current directory
    ```shell
    paper.pdf: paper.tex plot-data.png
            pdflatex paper.tex

    plot-%.png: %.dat plot.py
            ./plot.py -i $*.dat -o $@
    ```
    * Things named on the right-hand side are dependencies, the left-hand side is the target, and the indented block is a sequence of programs to produce the target from those dependencies
    * The `%` in a rule is a “pattern”, and will match the same string on the left and on the right. For example, if the target `plot-foo.png` is requested, make will look for the dependencies `foo.dat` and `plot.py`

---

## Dependency and management
* Repository: host a large number of dependencies in a single place, and provide a convenient mechanism for installing them
    * `PyPi` for Python
    * `apt` tool for Ubuntu
    * `RubyGems` for Ruby libraries
* Versioning
    * version number
    * semantic versioning: **major.minor.patch**
        * If a new release does not change the API, increase the patch version.
        * If you add to your API in a backwards-compatible way, increase the minor version.
        * If you change the API in a non-backwards-compatible way, increase the major version.
        * For example, Python2 and Python3 code do not mix very well
    * lock files
        * A lock file is simply a file that lists the exact version you are currently depending on of each dependency
        * Usually, you need to explicitly run an update program to upgrade to newer versions of your dependencies
        * *vendoring* is an extreme version of dependency locking

---

## Continuous integration systems
* Continuous integration, or CI, is an umbrella term for “stuff that runs whenever your code changes”
* GitHub Pages is a CI action that runs the Jekyll blog software on every push to master and makes the built site available on a particular GitHub domain
* testing terminology
    * Test suite: a collective term for all the tests
    * Unit test: a “micro-test” that tests a specific feature in isolation
    * Integration test: a “macro-test” that runs a larger part of the system to check that different feature or components work together
    * Regression test: a test that implements a particular pattern that previously caused a bug to ensure that the bug does not resurface
    * Mocking: to replace a function, module, or type with a fake implementation to avoid testing unrelated functionality. For example, you might “mock the network” or “mock the disk”

---

## Exercises
1. 
    ```makefile
    .PHONY: clean
    clean:
            git ls-files -o | xargs rm -f
    ```
2. Skip
3. Skip
4. Skip
5. Skip
