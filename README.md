# Onbe_CICD_template


## Introduction

This repository provides the necessary components to add to a [Prophecy](https://www.prophecy.io/) SQL Project's GitHub repository to satisfy Onbe's requirements for CI/CD automation.  The necessity of this customization arises from Onbe's requirement that default branches (usually named `main`) in Onbe's GitHub repositories are protected by GitHub rulesets that prevent developers from pushing Git commits directly to the default branch.  Instead, production-ready code that is to be deployed to the production environment must be reviewed and approved through GitHub's Pull Request(PR) mechanism to merge it into the default branch.  This repository defines a set of GitHub Actions workflows to perform the following operations during the lifecycle of a Pull Request that has the default branch as its target (or "base"):

Prior to the merge:
- Check that the Project minor version number[^2] in the Prophecy metadata on the feature (or "head") branch of the PR is greater than the default branch; if not; increment the minor version.
- Run the DBT tests defined in the Project using the [DBT Core CLI](https://docs.getdbt.com/reference/commands/test)(`dbt test`)

After the merge:
- Tag the merge commit with the new semantic version intorduced to the default branch from the feature branch

These actions correspond to the following [workflow definition files](https://docs.github.com/en/actions/writing-workflows/about-workflows) in the special `.github/workflows` folder at the root of the repository:
- `chech-prophecy-minor-version.yml`
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

### `.github/workflows`

This folder contains the definitions of GitHub Actions that automate the CI/CD operations.  Review the [Introduction](#introduction) above for context regarding the following details.


#### `check-prophecy-version.yml`

This workflow runs whenever a PR that has the default branch as its base is opened or updated with a new commit.


## Notes

[^1]: File tree diagram generated using [tree.nathanfriend.com](https://tree.nathanfriend.com/) like [this](https://tree.nathanfriend.com/?s=(%27options!(%27fancy7~fullPath!false~trailingSlash7~rootDot7)~9(%279%27.github%2FworkflowsKcheck-prophecy-minor-45*run-dbt-tests5*tag-release52.gitignore2.tool-4s2Onbe_CICD_templateKF3test30oldH8%26%206J%20GG.lock2README.md2pro6s520ileJ%27)~4!%271%27)*2B0%5B%20othH%20genHated%20f2%5Cn3s*Bnull_F.sql*4vHsion5.yml6file7!true8s%209source!B%20%20FmodelG2Pip6HerJ8%5DK%2F*%01KJHGFB987654320*).

[^2]: As defined by "[semantic versioning](https://semver.org/)", mnemonicially respresented as `MAJOR.MINOR.PATCH`. 
