# Onbe_CICD_template


## Introduction

This repository provides the necessary components to add to a [Prophecy](https://www.prophecy.io/) SQL Project's GitHub repository to satisfy Onbe's requirements for CI/CD automation.  The necessity of this customization arises from Onbe's requirement that default branches (usually named `main`) in Onbe's GitHub repositories are protected by GitHub rulesets that prevent developers from pushing Git commits directly to the default branch.  Instead, production-ready code that is to be deployed to the production environment must be reviewed and approved through GitHub's Pull Request(PR) mechanism to merge it into the default branch.  This repository defines a set of GitHub Actions workflows to perform the following operations during the lifecycle of a Pull Request that has the default branch as its target (or "base"):

Prior to the merge:
- Check that the Project minor version number[^2] in the Prophecy metadata on the feature (or "head") branch of the PR is greater than the default branch; if not; increment the minor version.
- Run the DBT tests defined in the Project using the [DBT Core CLI](https://docs.getdbt.com/reference/commands/test)(`dbt test`)

After the merge:
- Tag the merge commit with the new semantic version intorduced to the default branch from the feature branch

These actions correspond to the following [workflow definition files](https://docs.github.com/en/actions/writing-workflows/about-workflows) in the special `.github/workflows` folder at the root of the repository:
- `check-prophecy-minor-version.yml`
- `run-dbt-tests.yml`
- `tag-release.yml`

See the next section for details on the behavior of these workflows and other special files present in the repository necessary for their successful execution.


## Repository Contents

The following file tree diagram[^1] enumerates the special files that ship with this template.  The purpose of each of these files will be described in the reamainder of this document.  Other folders and files that may be present in this repository (usually on some bramch other than `main`) or a clone/fork of same are either generated and maintained automatically by the Prophecy platform or are in need of additional documentation here.

```
.
├── .github/workflows/
│   ├── check-prophecy-minor-version.yml
│   ├── run-dbt-tests.yml
│   └── tag-release.yml
├── .gitignore
├── .tool-versions
├── Onbe_CICD_template/
│   ├── models/
│   │   └── null_model.sql
│   ├── tests/
│   │   └── null_model.sql
│   └── [ other generated folders & files ] 
├── Pipfile
├── Pipfile.lock
├── README.md
├── profiles.yml
└── [ other generated files ]
```

### `.github/workflows/`

This folder contains the definitions of GitHub Actions that automate the CI/CD operations.  Review the [Introduction](#introduction) above for context regarding the following details.

These workflows each perform the following common setup actions before proceeding to their distinctive operations in an isolated execution environment provided by GitHub Actions:

- Clone the Project repository locally
- Checkout the feature branch
- Install Python, `pipenv`[^3], `pbt`[^4], `dbt`[^5] and their dependencies, including the Snowflake adapter for `dbt`.


#### `check-prophecy-minor-version.yml`

This workflow runs whenever a PR that has the default branch as its base is opened or updated with a new commit.  After setup, PBT looks for the most recent Git tag that it recognizes as a Prophecy release tag on the base branch. If the Project version in the Prophecy metadata files is not greater than that of the release tag that it found then it bumps the version to make it one minor version greater than the tag it found.  Then it commits and pushes the changed metadata files back to the incoming feature branch.  That new commit becomes the "head" of the feature branch.  Technically this results in a failed workflow but GHA detects a change to the PR itself and reinitiates the workflow.  The new check will succeed because of the new metadata in the feature branch. Any other failure mode will block the PR from merging and will require manual intervention because it is not anticipated by the existing workflow logic.


#### `run-dbt-tests.yml`

Like `check-prophecy-minor-version.yml`, this workflow also runs whenever a PR that has the default branch as its base is opened or updated with a new commit.  These two workflows are allowed to run concurrently because they have no interaction or interdependency.  This workflows performs the same setup, checks the connection to the Snowflake target specified by the local `profiles.yml` file (see [below](#profiles=yml)) and runs the tests defined in the Project using DBT.  If any test fails then the workflow will fail and the PR will not allow the merge to proceed.  The devloper must now determine what logic in the Model(s), or in the test(s) themselves, to adjust before repeating the tests by pusing a new commit to the feature branch.


#### `tag-release.yml`

This workflow runs upon completion of a PR's merge into the default branch.  It assumes that whatever Project version that is present in the Prophecy metadata is already set appropriately.  It attempts to create a new release tag based on the version information present in the Prophecy metadata in the default branch.  A failure of this workflow likely indicates that the particular release tag for the current Project version already exists in the repository.  This type of failure should not normally occur, so some inspection and manual intervention would be necessary in this scenario.


### `.gitignore`

This file tells Git what files it should ignore when reporting the current status of a working copy of a Git repository.  This is simply a convenience for developers working directly with the repository.


### `.tool-versions`

> [!NOTE]
> This file is only used by GHA, not Prophecy, `pbt`, `dbt`, or anything else.  Most users will not interact with it directly.

It contains the Python version required during the workflows' setup steps, currently pinned at `3.10.16`.  It also contains a version specification for `actionlint`, a tool used to validate GHA YAML files during development, but not directly relevant to the GHA workflows.

This style of tool version specification comes from the well-known [`asdf`](https://asdf-vm.com/) version menagement project and was adopted by the `setup-python` action template as of its [v5.5.0 release](https://github.com/actions/setup-python/releases/tag/v5.5.0) (see its PR [#1043](https://github.com/actions/setup-python/pull/1043) for details).


### `Onbe_CICD_template/`

> [!WARNING]
> As of the most recent update to this section, the GHA workflows defined in this project do not look for Prophecy projects in subfolders.  This repository should not be cloned or used as a template except to house a single Prophecy project in the repository's root folder (`./`) until this warning has been removed, indicating that additional logic has been added to the workflows to accommodate the possible presence of multiple Projects in subfolders.  This use of subfolders is the default when creating a new Project in Prophecy releases `>=4.0` and was adopted for this repository's layout simply to minimize the number of files and folders in its root folder.

This folder contains a minimal Prophecy SQL project here comprised of a single trivial Model and single trivial Test.  It will be utilized by a future version of this template to manage Prophecy version metadata and release tags, and run DBT tests, just as they would be currently for a Project defined in the repository's root folder. 


### `Pipfile` & `Pipfile.lock`



### `README.md`

This file.


### `profiles.yml`



## Notes

[^1]: File tree diagram generated using [tree.nathanfriend.com](https://tree.nathanfriend.com/) like [this](https://tree.nathanfriend.com/?s=(%27options!(%27fancy7~fullPath!false~trailingSlash7~rootDot7)~9(%279%27.github%2FworkflowsKcheck-prophecy-minor-45*run-dbt-tests5*tag-release52.gitignore2.tool-4s2Onbe_CICD_templateKF3test30oldH8%26%206J%20GG.lock2README.md2pro6s520ileJ%27)~4!%271%27)*2B0%5B%20othH%20genHated%20f2%5Cn3s*Bnull_F.sql*4vHsion5.yml6file7!true8s%209source!B%20%20FmodelG2Pip6HerJ8%5DK%2F*%01KJHGFB987654320*).

[^2]: As defined by "[semantic versioning](https://semver.org/)", mnemonicially respresented as `MAJOR.MINOR.PATCH`. 

[^3]: [Pipenv](https://pipenv.pypa.io/en/latest/)("Python Dev Workflow for Humans"); "a Python virtualenv management tool that nicely bridges the gaps between `pip`, `python` and `virtualenv`."

[^4]: Prophecy Build Tool (PBT) ([doc](https://docs.prophecy.io/engineers/prophecy-build-tool/)|[src](https://github.com/SimpleDataLabsInc/prophecy-build-tool)) allows integration of Prophecy SQL Projects with CI/CD tools (e.g. Github Actions), and build systems (e.g. Jenkins).  PBT's capabilities for SQL Projects are limited relative to Spark Projects as of release 1.2.49.

[^5]: dbt Core ([doc](https://docs.getdbt.com/docs/core/about-core-setup)|[src](https://github.com/dbt-labs/dbt-core) "is an open-source tool that enables data teams to transform data using analytics engineering best practices."  Used by the Prophecy platform to execute SQL Projects.
