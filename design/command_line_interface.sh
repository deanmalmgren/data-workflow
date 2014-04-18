# The goal here is to try and write down what the ideal command line
# interface should look like. This is not intended to be exhaustive,
# but a good starting point to highlight typical use cases. For now,
# I'll assume the command that this all sits under is called
# `flo`

# By default, execute entire workflow, or at least the portion of it
# that is "out of sync". When you edit a particular file in the
# workflow and rerun `flo`, this should only re-execute the parts
# that been affected by the change. This makes it very easy to iterate
# quickly on data analysis problems without having to worry about
# re-running an arsenal of data analysis tasks.
flo run
nano path/to/some/file
flo run


# Sometimes, you've made a dramatic change and you want to re-run an
# entire workflow, ignoring the sha hash state of every file. This can
# also be useful when you want to rerun an analysis periodically after
# the original data set has changed
flo run --force


# Another common use case is to just delete the entire workflow
# without rerunning anything. This should delete all targets that are
# defined in the workflow; anything that matches a `creates` in
# `flo.yaml`. BEFORE deleting everything, this should verify that
# a user actually wants to remove all these files.
flo clean


# Similar to above, but do not require a user to verify that they want
# to delete everything
flo clean --force


# Another common use case during development is to run the workflow up
# to a partiuclar step to make sure that intermediate results make
# sense. This just runs the workflow up to and including the
# data/result.png. After editing a file that renders the result, it
# should only re-run the last step.
flo run data/result.png
nano src/render_result.py
flo run data/result.png


# Can also run more than one target from the command line, if that is
# easier
flo run data/result.png data/download.tgz


# Sometimes you end up editing several files and, before you run the
# workflow, you want to see the set of steps that are going to be run
# *without* actually running them to make sure you aren't going to
# redo a step that will take a long time. This could even try to
# estimate how long the process will take?
nano path/to/a/file
nano path/to/another/file
nano path/to/some/file
flo run --dry-run


# This is something that drives me crazy about GNU make --- you should
# be able to run a workflow from any subdirectory whose ancestor
# contains a flo.yaml file, the same way Fabric works with
# fabfiles or mercurial/git work with .hg/.git directories
cd path/to/a
nano file
flo run


# When you change a flo.yaml target in the yaml file itself, this
# should also trigger the necessary parts to be rerun. `flo` must
# be smart enough to detect when targets have changed. In this
# example, the first execution of `flo` runs the entire workflow
# to completion. Then the user edits a particular target in the
# flo.yaml file. The second execution of `flo` only runs the
# parts of the workflow that are affected by the changes.
flo run
nano flo.yaml
flo run


# to expedite development and iteration, it is often
# possible/advantageous to write targets that are run once per input
# file. To help with development in these situations, you often want
# to iterate on that element on the workflow on only one file, instead
# of all input files (see data/per_file target in flo.yaml)
flo run data/per_file --filename-root=a_specific_filename


# another way to expedite development and iteration is to limit the
# amount of time that each step takes. Should this be on a per-step
# basis or a total-time basis?
flo run data/per_file --time-limit=1s
