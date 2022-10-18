use std::collections::BTreeSet;
use std::path::Path;
use xshell::Shell;

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
  let sh = Shell::new().unwrap();
  sh.change_dir(env!("CARGO_MANIFEST_DIR"));
  let mut path = Path::new("src").to_owned();
  let mut entries = sh.read_dir(&path).unwrap();
  entries.retain(|x| x.extension().is_none());
  for dir in entries {
    let dir_name = dir
      .file_name()
      .expect("no file name for dir")
      .to_str()
      .expect("cannot convert dirname to str");
    let mod_path = dir.as_path().with_extension("rs");
    path.push(mod_path);
    let mod_file = sh.read_file(&path).unwrap();
    let prefix = format!("  \"{dir_name}/");
    let in_order: BTreeSet<_> =
      mod_file.lines().filter_map(|x| x.strip_prefix(&prefix)?.strip_suffix(".sml\",")).collect();
    assert!(path.pop());
    path.push(&dir);
    let sml_dir = sh.read_dir(&path).unwrap();
    let in_files: BTreeSet<_> = sml_dir
      .iter()
      .map(|x| x.file_name().unwrap().to_str().unwrap().strip_suffix(".sml").unwrap())
      .collect();
    eq_sets(
      &in_order,
      &in_files,
      "referenced files that don't exist",
      "existing files not referenced",
    );
  }
}
