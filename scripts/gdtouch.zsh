#!/usr/bin/env zsh
set -euo pipefail

gd_ext=".gd"
uid_ext=".uid"

for filename in "$@"; do
  # Create filenames from args
  gd_file="${filename}${gd_ext}"
  uid_file="${filename}${gd_ext}${uid_ext}"

  # Create the files (won't error if they already exist)
  touch "$gd_file" "$uid_file"

  # Generate 13-char alphanumeric, then prepend scheme
  # temporarily disable pipefail to allow filewrite later
  set +o pipefail
  uid_string="$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 13)"
  set -o pipefail

  # Crete UID file file_contents
  file_contents="uid://${uid_string}"

  # Write contents to file and alert user
  echo "$file_contents" >> "$uid_file"
  echo "Created $gd_file and $uid_file"
done

