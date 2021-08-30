
2.0.0 / 2021-08-30
==================

  * (BREAKING) chore: pins pre-commit-hooks to v4.0.1.
  * (BREAKING) chore: pins aws provider to >= 3.5.
  * feat: add pre-commit-afcmf (v0.1.2).
  * chore: pins terraform to >= 0.14.
  * chore: bumps terraform + providers versions in example:
    * pins terraform to >= 0.14.
    * pins aws provider to >= 3.5.
  * chore: bumps s3 module version to last release (todo: pins version 4.0.0 once
    new s3 module release is merged).
  * refactor: version constraints, use new syntax.
  * refactor: get rid of empty data.tf file.
  * fix: license file: add year + company name.
  * fix: failing tests, add prefix parameter based on the random string.
  * refactor: lint main.tf file in root module.
  * refactor: providers.tf and versions.tf in example.
  * refactor: use mirror vpc module from internal VCS.

1.0.1 / 2021-06-16
==================

  * fix: subnet_id for emr
  * fix: change subnetid for emr

1.0.0 / 2021-06-08
==================

  * feat: first version of EMR module.
