// Original (intended) file contents:
//fn main() {
//  println!("Hello world v{}!", env!("CARGO_PKG_VERSION"));
//}

use std::env::{ArgsOs, args_os};
use std::error::Error;
use std::fmt;

#[derive(Debug, Clone)]
pub(crate) struct ArgDecodeError {
  pub(crate) arg_index: usize,
}

impl fmt::Display for ArgDecodeError {
  fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
    write!(f, "Unable to decode argument with index {}", self.arg_index)?;
    Ok(())
  }
}

impl Error for ArgDecodeError {}

fn decode_prgm_args(prgm_args: ArgsOs) -> Result<Vec<String>, ArgDecodeError> {
  // https://doc.rust-lang.org/std/result/enum.Result.html#method.from_iter
  
  let converted_args: Result<Vec<String>, ArgDecodeError> =
    prgm_args
      .enumerate()
      .map(|(index, os_str)| match os_str.into_string() {
        Ok(str) => Ok(str),
        Err(_) => Err(ArgDecodeError { arg_index: index }),
      })
      .collect();
  
  return converted_args;
}

fn main() -> Result<(), Box<dyn Error>> {
  println!();
  println!("Rust Nix Template v{}", env!("CARGO_PKG_VERSION"));
  println!();
  
  println!("Command line arguments:");
  for (index, arg) in decode_prgm_args(args_os())?.iter().enumerate() {
    println!("{}: {}", index, arg);
  }
  println!();
  
  Ok(())
}
