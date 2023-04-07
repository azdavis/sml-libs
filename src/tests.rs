use std::collections::BTreeSet;

fn eq_sets<T>(lhs: &BTreeSet<T>, rhs: &BTreeSet<T>, only_lhs: &str, only_rhs: &str)
where
  T: Ord + std::fmt::Debug,
{
  let only_lhs_set: Vec<_> = lhs.difference(rhs).collect();
  assert!(only_lhs_set.is_empty(), "{only_lhs}: {only_lhs_set:?}");
  let only_rhs_set: Vec<_> = rhs.difference(lhs).collect();
  assert!(only_rhs_set.is_empty(), "{only_rhs}: {only_rhs_set:?}");
}

#[test]
fn all_used() {
  std::env::set_current_dir(env!("CARGO_MANIFEST_DIR")).unwrap();
  let entries = std::fs::read_dir("src").unwrap();
  for dir in entries {
    let dir = dir.unwrap();
    if dir.path().extension().is_some() {
      continue;
    }
    let dir_name = dir.file_name().into_string().expect("cannot convert dirname to str");
    let mod_path = dir.path().with_extension("rs");
    let mod_file = std::fs::read_to_string(&mod_path).unwrap();
    let prefix = format!("  \"{dir_name}/");
    let in_order: BTreeSet<_> =
      mod_file.lines().filter_map(|x| x.strip_prefix(&prefix)?.strip_suffix(".sml\",")).collect();
    let sml_dir = std::fs::read_dir(dir.path()).unwrap();
    let in_files: BTreeSet<_> =
      sml_dir.map(|x| x.unwrap().file_name().into_string().unwrap()).collect();
    let in_files: BTreeSet<_> = in_files.iter().map(|x| x.strip_suffix(".sml").unwrap()).collect();
    eq_sets(
      &in_order,
      &in_files,
      &format!("{}: referenced files that don't exist", dir.path().display()),
      &format!("{}: existing files not referenced", dir.path().display()),
    );
  }
}
